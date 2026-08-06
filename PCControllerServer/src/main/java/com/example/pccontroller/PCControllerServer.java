package com.example.pccontroller;

import java.awt.*;
import java.awt.event.InputEvent;
import java.awt.event.KeyEvent;
import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.List;
import java.util.concurrent.*;

/**
 * PC Controller Server
 *
 * Features:
 * - UDP discovery on port 9999
 * - TCP command server on port 12345
 * - SINGLE CLIENT ONLY
 * - Mouse control
 * - Keyboard control
 * - Media control
 * - Volume control
 * - Power control
 * - Windows + macOS support
 *
 * Flutter JSON examples:
 *
 * {"type":"MOUSE_MOVE","dx":10,"dy":-5}
 * {"type":"MOUSE_LEFT_CLICK"}
 * {"type":"MOUSE_RIGHT_CLICK"}
 * {"type":"MOUSE_SCROLL","amount":3}
 *
 * {"type":"KEY_PRESS","key":"A"}
 * {"type":"KEY_DOWN","key":"CTRL"}
 * {"type":"KEY_UP","key":"CTRL"}
 * {"type":"KEY_COMBO","combo":"CTRL+C"}
 *
 * {"type":"VOLUME_UP"}
 * {"type":"VOLUME_DOWN"}
 * {"type":"MEDIA_PLAY_PAUSE"}
 * {"type":"MEDIA_NEXT"}
 * {"type":"MEDIA_PREV"}
 * {"type":"MEDIA_STOP"}
 *
 * {"type":"SLEEP"}
 * {"type":"RESTART"}
 * {"type":"POWER_OFF"}
 */
public class PCControllerServer {

    public static final int UDP_PORT = 9999;
    public static final int TCP_PORT = 12345;

    private volatile boolean running = true;
    private volatile Socket activeClient;
    private final Object clientLock = new Object();

    private Robot robot;

    private ExecutorService acceptorExecutor;
    private ExecutorService clientExecutor;
    private ExecutorService udpExecutor;
    private ExecutorService slowOpsExecutor;

    public static void main(String[] args) {
        PCControllerServer server = new PCControllerServer();
        Runtime.getRuntime().addShutdownHook(new Thread(server::shutdown));
        server.start();
    }

    public void start() {
        try {
            robot = new Robot();
            robot.setAutoDelay(0);
            robot.setAutoWaitForIdle(false);
        } catch (AWTException e) {
            log("ERROR: Unable to initialize Robot: " + e.getMessage());
            return;
        }

        log("======================================");
        log("       PC CONTROLLER SERVER");
        log("======================================");
        log("Operating System: " + System.getProperty("os.name"));
        log("Java Version: " + System.getProperty("java.version"));
        log("UDP Discovery Port: " + UDP_PORT);
        log("TCP Command Port: " + TCP_PORT);
        log("Client Mode: SINGLE CLIENT");
        logLocalAddresses();

        udpExecutor = Executors.newSingleThreadExecutor(r -> {
            Thread t = new Thread(r, "UDP-Discovery");
            t.setDaemon(true);
            return t;
        });
        udpExecutor.submit(this::udpDiscoveryLoop);

        acceptorExecutor = Executors.newSingleThreadExecutor(r -> {
            Thread t = new Thread(r, "TCP-Acceptor");
            t.setDaemon(false);
            return t;
        });

        clientExecutor = Executors.newSingleThreadExecutor(r -> {
            Thread t = new Thread(r, "TCP-ClientHandler");
            t.setDaemon(false);
            return t;
        });

        slowOpsExecutor = Executors.newCachedThreadPool(r -> {
            Thread t = new Thread(r, "SlowOps");
            t.setDaemon(true);
            return t;
        });

        acceptorExecutor.submit(this::tcpAcceptLoop);

        log("Server started successfully.");
        log("Waiting for Android/iOS client...");
        log("Press Ctrl+C to stop.");

        try {
            while (running) {
                Thread.sleep(1000);
            }
        } catch (InterruptedException ignored) {
            Thread.currentThread().interrupt();
        } finally {
            shutdown();
        }
    }

    private void shutdown() {
        if (!running) {
            return;
        }
        running = false;
        log("Shutting down server...");

        if (udpExecutor != null) {
            udpExecutor.shutdownNow();
        }
        if (acceptorExecutor != null) {
            acceptorExecutor.shutdownNow();
        }
        if (clientExecutor != null) {
            clientExecutor.shutdownNow();
        }
        if (slowOpsExecutor != null) {
            slowOpsExecutor.shutdownNow();
        }

        closeActiveClient();
        log("Shutdown complete.");
    }

    private void udpDiscoveryLoop() {
        try (DatagramSocket socket = new DatagramSocket(UDP_PORT)) {
            socket.setBroadcast(true);
            socket.setSoTimeout(1000);
            byte[] buffer = new byte[1024];
            log("UDP discovery listener started.");

            while (running) {
                try {
                    DatagramPacket packet = new DatagramPacket(buffer, buffer.length);
                    socket.receive(packet);
                    String message = new String(packet.getData(), packet.getOffset(), packet.getLength(), StandardCharsets.UTF_8).trim();

                    if ("DISCOVER_PC_CONTROLLER".equals(message)) {
                        String clientIp = packet.getAddress().getHostAddress();
                        log("Discovery request from " + clientIp + ":" + packet.getPort());
                        byte[] reply = "PC_CONTROLLER_HERE".getBytes(StandardCharsets.UTF_8);
                        DatagramPacket response = new DatagramPacket(reply, reply.length, packet.getAddress(), packet.getPort());
                        socket.send(response);
                    }
                } catch (SocketTimeoutException ignored) {
                } catch (IOException e) {
                    if (running) {
                        log("UDP listener error: " + e.getMessage());
                    }
                }
            }
        } catch (SocketException e) {
            log("UDP socket error: " + e.getMessage());
        }
        log("UDP discovery listener stopped.");
    }

    private void tcpAcceptLoop() {
        try (ServerSocket serverSocket = new ServerSocket(TCP_PORT)) {
            serverSocket.setReuseAddress(true);
            log("TCP server listening on port " + TCP_PORT);

            while (running) {
                try {
                    Socket client = serverSocket.accept();
                    String clientIp = client.getInetAddress().getHostAddress();
                    log("Incoming client connection: " + clientIp);

                    client.setTcpNoDelay(true);
                    client.setSoTimeout(0);
                    client.setKeepAlive(true);

                    if (!registerClient(client)) {
                        log("Connection rejected: " + clientIp + " (server busy)");
                        sendBusyAndClose(client);
                        continue;
                    }

                    log("Client connected successfully: " + clientIp);
                    clientExecutor.submit(() -> handleClient(client));

                } catch (IOException e) {
                    if (running) {
                        log("TCP accept error: " + e.getMessage());
                    }
                }
            }
        } catch (IOException e) {
            log("Failed to start TCP server: " + e.getMessage());
        }
        log("TCP acceptor stopped.");
    }

    private boolean registerClient(Socket newClient) {
        synchronized (clientLock) {
            if (activeClient != null && !activeClient.isClosed()) {
                return false;
            }
            activeClient = newClient;
            return true;
        }
    }

    private void sendBusyAndClose(Socket client) {
        try {
            OutputStream out = client.getOutputStream();
            out.write("BUSY\n".getBytes(StandardCharsets.UTF_8));
            out.flush();
        } catch (IOException ignored) {
        } finally {
            try {
                client.close();
            } catch (IOException ignored) {
            }
        }
    }

    private void closeActiveClient() {
        synchronized (clientLock) {
            if (activeClient != null) {
                try {
                    activeClient.close();
                } catch (IOException ignored) {
                }
                activeClient = null;
            }
        }
    }

    private void handleClient(Socket client) {
        String ip = client.getInetAddress().getHostAddress();
        try {
            InputStream in = client.getInputStream();
            OutputStream out = client.getOutputStream();

            out.write("OK CONNECTED\n".getBytes(StandardCharsets.UTF_8));
            out.flush();

            BufferedReader reader = new BufferedReader(new InputStreamReader(in, StandardCharsets.UTF_8), 8192);
            String line;

            while (running && (line = reader.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty()) {
                    continue;
                }

                if (line.contains("MOUSE_MOVE")) {
                    processCommand(line);
                    continue;
                }

                processCommand(line);
                out.write("OK\n".getBytes(StandardCharsets.UTF_8));
                out.flush();
            }

        } catch (Exception e) {
            log("Client error " + ip + " : " + e.getMessage());
        } finally {
            try {
                client.close();
            } catch (IOException ignored) {
            }

            synchronized (clientLock) {
                if (activeClient == client) {
                    activeClient = null;
                }
            }
            log("Client disconnected: " + ip);
        }
    }

    private void processCommand(String raw) {
        if (raw.startsWith("{")) {
            Map<String, String> json = parseMiniJson(raw);
            String cmd = json.get("cmd");
            if (cmd == null) {
                cmd = json.get("type");
            }
            if (cmd == null) {
                throw new IllegalArgumentException("Missing command type");
            }

            cmd = cmd.toUpperCase(Locale.ROOT);

            switch (cmd) {
                case "MOUSE_MOVE" -> {
                    int dx = Integer.parseInt(json.getOrDefault("dx", "0"));
                    int dy = Integer.parseInt(json.getOrDefault("dy", "0"));
                    mouseMoveBy(dx, dy);
                }
                case "MOUSE_LEFT_CLICK" -> mouseClick(InputEvent.BUTTON1_DOWN_MASK);
                case "MOUSE_RIGHT_CLICK" -> mouseClick(InputEvent.BUTTON3_DOWN_MASK);
                case "MOUSE_SCROLL" -> {
                    int amount = Integer.parseInt(json.getOrDefault("amount", "0"));
                    robot.mouseWheel(amount);
                }
                case "KEY_PRESS" -> {
                    String key = json.get("key");
                    if (key == null) {
                        throw new IllegalArgumentException("Missing key");
                    }
                    keyPress(key);
                }
                case "KEY_DOWN" -> {
                    String key = json.get("key");
                    if (key == null) {
                        throw new IllegalArgumentException("Missing key");
                    }
                    keyDown(key);
                }
                case "KEY_UP" -> {
                    String key = json.get("key");
                    if (key == null) {
                        throw new IllegalArgumentException("Missing key");
                    }
                    keyUp(key);
                }
                case "KEY_COMBO" -> {
                    String combo = json.get("combo");
                    if (combo == null) {
                        throw new IllegalArgumentException("Missing combo");
                    }
                    keyCombo(combo);
                }
                case "PING" -> {
                }
                case "SLEEP" -> {
                    log("Power command: SLEEP");
                    slowOpsExecutor.submit(() -> executePowerAction("SLEEP"));
                }
                case "RESTART" -> {
                    log("Power command: RESTART");
                    slowOpsExecutor.submit(() -> executePowerAction("RESTART"));
                }
                case "POWER_OFF" -> {
                    log("Power command: POWER_OFF");
                    slowOpsExecutor.submit(() -> executePowerAction("POWER_OFF"));
                }
                case "VOLUME_UP" -> slowOpsExecutor.submit(() -> executeMediaAction("VOLUME_UP"));
                case "VOLUME_DOWN" -> slowOpsExecutor.submit(() -> executeMediaAction("VOLUME_DOWN"));
                case "MEDIA_PLAY_PAUSE" -> slowOpsExecutor.submit(() -> executeMediaAction("MEDIA_PLAY_PAUSE"));
                case "MEDIA_NEXT" -> slowOpsExecutor.submit(() -> executeMediaAction("MEDIA_NEXT"));
                case "MEDIA_PREV" -> slowOpsExecutor.submit(() -> executeMediaAction("MEDIA_PREV"));
                case "MEDIA_STOP" -> slowOpsExecutor.submit(() -> executeMediaAction("MEDIA_STOP"));
                default -> throw new IllegalArgumentException("Unknown cmd: " + cmd);
            }
            return;
        }

        String[] parts = raw.split("\\s+");
        if (parts.length == 0) {
            return;
        }

        String cmd = parts[0].toUpperCase(Locale.ROOT);

        switch (cmd) {
            case "MOUSE_MOVE" -> {
                int dx = parseIntArg(parts, 1, 0);
                int dy = parseIntArg(parts, 2, 0);
                mouseMoveBy(dx, dy);
            }
            case "MOUSE_LEFT_CLICK" -> mouseClick(InputEvent.BUTTON1_DOWN_MASK);
            case "MOUSE_RIGHT_CLICK" -> mouseClick(InputEvent.BUTTON3_DOWN_MASK);
            case "MOUSE_SCROLL" -> {
                int amount = parseIntArg(parts, 1, 0);
                robot.mouseWheel(amount);
            }
            case "KEY_PRESS" -> keyPress(requireArg(parts, 1));
            case "KEY_DOWN" -> keyDown(requireArg(parts, 1));
            case "KEY_UP" -> keyUp(requireArg(parts, 1));
            case "KEY_COMBO" -> keyCombo(requireArg(parts, 1));
            case "PING" -> {
            }
            case "SLEEP" -> slowOpsExecutor.submit(() -> executePowerAction("SLEEP"));
            case "RESTART" -> slowOpsExecutor.submit(() -> executePowerAction("RESTART"));
            case "POWER_OFF" -> slowOpsExecutor.submit(() -> executePowerAction("POWER_OFF"));
            case "VOLUME_UP" -> slowOpsExecutor.submit(() -> executeMediaAction("VOLUME_UP"));
            case "VOLUME_DOWN" -> slowOpsExecutor.submit(() -> executeMediaAction("VOLUME_DOWN"));
            case "MEDIA_PLAY_PAUSE" -> slowOpsExecutor.submit(() -> executeMediaAction("MEDIA_PLAY_PAUSE"));
            case "MEDIA_NEXT" -> slowOpsExecutor.submit(() -> executeMediaAction("MEDIA_NEXT"));
            case "MEDIA_PREV" -> slowOpsExecutor.submit(() -> executeMediaAction("MEDIA_PREV"));
            case "MEDIA_STOP" -> slowOpsExecutor.submit(() -> executeMediaAction("MEDIA_STOP"));
            default -> throw new IllegalArgumentException("Unknown command: " + cmd);
        }
    }

    private void mouseMoveBy(int dx, int dy) {
        try {
            Point p = MouseInfo.getPointerInfo().getLocation();
            robot.mouseMove(p.x + dx, p.y + dy);
        } catch (Exception e) {
        }
    }

    private void mouseClick(int buttonMask) {
        robot.mousePress(buttonMask);
        robot.mouseRelease(buttonMask);
    }

    private void keyPress(String key) {
        int code = toKeyCode(key);
        robot.keyPress(code);
        robot.keyRelease(code);
    }

    private void keyDown(String key) {
        robot.keyPress(toKeyCode(key));
    }

    private void keyUp(String key) {
        robot.keyRelease(toKeyCode(key));
    }

    private void keyCombo(String combo) {
        String[] keys = combo.split("[+]");
        int[] codes = Arrays.stream(keys).map(String::trim).mapToInt(this::toKeyCode).toArray();

        for (int code : codes) {
            robot.keyPress(code);
        }

        for (int i = codes.length - 1; i >= 0; i--) {
            robot.keyRelease(codes[i]);
        }
    }

    private int toKeyCode(String key) {
        String k = key.trim().toUpperCase(Locale.ROOT);

        if (k.length() == 1) {
            char c = k.charAt(0);
            if ((c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9')) {
                return KeyEvent.getExtendedKeyCodeForChar(c);
            }
        }

        return switch (k) {
            case "ENTER", "RETURN" -> KeyEvent.VK_ENTER;
            case "SPACE" -> KeyEvent.VK_SPACE;
            case "BACKSPACE" -> KeyEvent.VK_BACK_SPACE;
            case "TAB" -> KeyEvent.VK_TAB;
            case "ESC", "ESCAPE" -> KeyEvent.VK_ESCAPE;
            case "CTRL", "CONTROL" -> KeyEvent.VK_CONTROL;
            case "ALT" -> KeyEvent.VK_ALT;
            case "SHIFT" -> KeyEvent.VK_SHIFT;
            case "META", "CMD", "COMMAND", "WIN" -> KeyEvent.VK_META;
            case "UP" -> KeyEvent.VK_UP;
            case "DOWN" -> KeyEvent.VK_DOWN;
            case "LEFT" -> KeyEvent.VK_LEFT;
            case "RIGHT" -> KeyEvent.VK_RIGHT;
            case "DEL", "DELETE" -> KeyEvent.VK_DELETE;
            case "INS", "INSERT" -> KeyEvent.VK_INSERT;
            case "HOME" -> KeyEvent.VK_HOME;
            case "END" -> KeyEvent.VK_END;
            case "PGUP", "PAGE_UP" -> KeyEvent.VK_PAGE_UP;
            case "PGDN", "PAGE_DOWN" -> KeyEvent.VK_PAGE_DOWN;
            case "F1" -> KeyEvent.VK_F1;
            case "F2" -> KeyEvent.VK_F2;
            case "F3" -> KeyEvent.VK_F3;
            case "F4" -> KeyEvent.VK_F4;
            case "F5" -> KeyEvent.VK_F5;
            case "F6" -> KeyEvent.VK_F6;
            case "F7" -> KeyEvent.VK_F7;
            case "F8" -> KeyEvent.VK_F8;
            case "F9" -> KeyEvent.VK_F9;
            case "F10" -> KeyEvent.VK_F10;
            case "F11" -> KeyEvent.VK_F11;
            case "F12" -> KeyEvent.VK_F12;
            case "MINUS", "-" -> KeyEvent.VK_MINUS;
            case "EQUALS", "=" -> KeyEvent.VK_EQUALS;
            case "COMMA", "," -> KeyEvent.VK_COMMA;
            case "PERIOD", "." -> KeyEvent.VK_PERIOD;
            case "SLASH", "/" -> KeyEvent.VK_SLASH;
            case "SEMICOLON", ";" -> KeyEvent.VK_SEMICOLON;
            case "QUOTE", "'" -> KeyEvent.VK_QUOTE;
            case "BACK_QUOTE", "`" -> KeyEvent.VK_BACK_QUOTE;
            case "BACK_SLASH", "\\" -> KeyEvent.VK_BACK_SLASH;
            case "OPEN_BRACKET", "[" -> KeyEvent.VK_OPEN_BRACKET;
            case "CLOSE_BRACKET", "]" -> KeyEvent.VK_CLOSE_BRACKET;
            default -> throw new IllegalArgumentException("Unknown key: " + key);
        };
    }

    private void executeMediaAction(String action) {
        String os = System.getProperty("os.name", "").toLowerCase(Locale.ROOT);
        if (os.contains("win")) {
            executeWindowsMediaAction(action);
            return;
        }
        if (os.contains("mac")) {
            executeMacMediaAction(action);
            return;
        }
        log("[Media] Unsupported OS: " + os);
    }

    private void executeWindowsMediaAction(String action) {
        int virtualKey;

        switch (action) {
            case "VOLUME_DOWN" -> virtualKey = 0xAE;
            case "VOLUME_UP" -> virtualKey = 0xAF;
            case "MEDIA_NEXT" -> virtualKey = 0xB0;
            case "MEDIA_PREV" -> virtualKey = 0xB1;
            case "MEDIA_STOP" -> virtualKey = 0xB2;
            case "MEDIA_PLAY_PAUSE" -> virtualKey = 0xB3;
            default -> {
                log("[Windows Media] Unknown action: " + action);
                return;
            }
        }

        try {
            sendWindowsVirtualKey(virtualKey);
            log("[Windows Media] " + action + " executed");
        } catch (Exception e) {
            log("[Windows Media Error] " + e.getMessage());
        }
    }

    private void sendWindowsVirtualKey(int virtualKey) throws IOException, InterruptedException {
        String script = "Add-Type @'\n" + "using System;\n" + "using System.Runtime.InteropServices;\n" + "public static class PCControllerNative {\n" + "    [DllImport(\"user32.dll\")]\n" + "    public static extern void keybd_event(" + "byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo" + ");\n" + "}\n" + "'@;\n" + "[PCControllerNative]::keybd_event(" + virtualKey + ",0,0,[UIntPtr]::Zero);\n" + "[PCControllerNative]::keybd_event(" + virtualKey + ",0,2,[UIntPtr]::Zero);";

        Process process = new ProcessBuilder("powershell.exe", "-NoProfile", "-NonInteractive", "-ExecutionPolicy", "Bypass", "-Command", script).redirectErrorStream(true).start();

        int exitCode = process.waitFor();

        if (exitCode != 0) {
            throw new IOException("Windows media command failed. Exit code: " + exitCode);
        }
    }

    private void executeMacMediaAction(String action) {
        try {
            boolean success = false;

            if ("VOLUME_UP".equals(action)) {
                success = runAppleScript("set volume output volume " + "(output volume of " + "(get volume settings) + 6)");
            } else if ("VOLUME_DOWN".equals(action)) {
                success = runAppleScript("set volume output volume " + "(output volume of " + "(get volume settings) - 6)");
            }

            if (!success && isProcessRunning("Music")) {
                String script = switch (action) {
                    case "MEDIA_PLAY_PAUSE" -> "tell application \"Music\" " + "to playpause";
                    case "MEDIA_NEXT" -> "tell application \"Music\" " + "to next track";
                    case "MEDIA_PREV" -> "tell application \"Music\" " + "to previous track";
                    case "MEDIA_STOP" -> "tell application \"Music\" " + "to stop";
                    default -> null;
                };

                if (script != null) {
                    success = runAppleScript(script);
                }
            }

            if (!success && isProcessRunning("Spotify")) {
                String script = switch (action) {
                    case "MEDIA_PLAY_PAUSE" -> "tell application \"Spotify\" " + "to playpause";
                    case "MEDIA_NEXT" -> "tell application \"Spotify\" " + "to next track";
                    case "MEDIA_PREV" -> "tell application \"Spotify\" " + "to previous track";
                    case "MEDIA_STOP" -> "tell application \"Spotify\" " + "to pause";
                    default -> null;
                };

                if (script != null) {
                    success = runAppleScript(script);
                }
            }

            if (success) {
                log("[Mac Media] " + action + " executed");
            } else {
                log("[Mac Media] No supported media app found.");
            }

        } catch (Exception e) {
            log("[Mac Media Error] " + e.getMessage());
        }
    }

    private boolean runAppleScript(String script) {
        try {
            Process process = new ProcessBuilder("osascript", "-e", script).start();
            int exitCode = process.waitFor();
            return exitCode == 0;
        } catch (Exception e) {
            return false;
        }
    }

    private boolean isProcessRunning(String appName) {
        try {
            Process process = new ProcessBuilder("osascript", "-e", "application \"" + appName + "\" is running").start();

            try (BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream(), StandardCharsets.UTF_8))) {
                String output = reader.readLine();
                process.waitFor();
                return output != null && output.trim().equalsIgnoreCase("true");
            }
        } catch (Exception e) {
            return false;
        }
    }

    private void executePowerAction(String action) {
        String os = System.getProperty("os.name", "").toLowerCase(Locale.ROOT);
        boolean isWindows = os.contains("win");
        boolean isMac = os.contains("mac");
        String command;

        if (isWindows) {
            switch (action) {
                case "SLEEP" -> command = "rundll32.exe " + "powrprof.dll," + "SetSuspendState " + "0,1,0";
                case "RESTART" -> command = "shutdown -r -t 0";
                case "POWER_OFF" -> command = "shutdown -s -t 0";
                default -> throw new IllegalArgumentException("Unknown power action: " + action);
            }
        } else if (isMac) {
            switch (action) {
                case "SLEEP" -> command = "pmset sleepnow";
                case "RESTART" -> command = "sudo shutdown -r now";
                case "POWER_OFF" -> command = "sudo shutdown -h now";
                default -> throw new IllegalArgumentException("Unknown power action: " + action);
            }
        } else {
            throw new IllegalArgumentException("Unsupported operating system: " + os);
        }

        executePowerCommand(command);
    }

    private void executePowerCommand(String command) {
        try {
            new ProcessBuilder(parseCommand(command)).start();
            log("Power action executed: " + command);
        } catch (IOException e) {
            log("Power command failed: " + e.getMessage());
        }
    }

    private String[] parseCommand(String command) {
        return command.split(" ");
    }

    private int parseIntArg(String[] parts, int index, int defaultValue) {
        if (index >= parts.length) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(parts[index]);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private String requireArg(String[] parts, int index) {
        if (index >= parts.length) {
            throw new IllegalArgumentException("Missing argument at index " + index);
        }
        return parts[index];
    }

    private Map<String, String> parseMiniJson(String raw) {
        Map<String, String> map = new HashMap<>();

        try {
            String s = raw.trim();

            if (!s.startsWith("{") || !s.endsWith("}")) {
                throw new IllegalArgumentException("Invalid JSON");
            }

            s = s.substring(1, s.length() - 1).trim();

            if (s.isEmpty()) {
                return map;
            }

            List<String> pairs = splitTopLevel(s, ',');

            for (String pair : pairs) {
                List<String> keyValue = splitTopLevel(pair, ':');

                if (keyValue.size() != 2) {
                    continue;
                }

                String key = stripQuotes(keyValue.get(0).trim());
                String value = stripQuotes(keyValue.get(1).trim());

                map.put(key, value);
            }

        } catch (Exception e) {
            throw new IllegalArgumentException("Invalid JSON: " + e.getMessage());
        }

        return map;
    }

    private List<String> splitTopLevel(String s, char delimiter) {
        List<String> result = new ArrayList<>();
        boolean inQuotes = false;
        StringBuilder current = new StringBuilder();

        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);

            if (c == '"') {
                inQuotes = !inQuotes;
                current.append(c);
            } else if (c == delimiter && !inQuotes) {
                result.add(current.toString());
                current.setLength(0);
            } else {
                current.append(c);
            }
        }

        result.add(current.toString());
        return result;
    }

    private String stripQuotes(String value) {
        String trimmed = value.trim();

        if (trimmed.startsWith("\"") && trimmed.endsWith("\"") && trimmed.length() >= 2) {
            return trimmed.substring(1, trimmed.length() - 1);
        }

        return trimmed;
    }

    private String safeMsg(String message) {
        if (message == null) {
            return "";
        }
        return message.replace('\n', ' ').replace('\r', ' ');
    }

    private void logLocalAddresses() {
        try {
            Enumeration<NetworkInterface> interfaces = NetworkInterface.getNetworkInterfaces();

            while (interfaces.hasMoreElements()) {
                NetworkInterface networkInterface = interfaces.nextElement();

                if (!networkInterface.isUp() || networkInterface.isLoopback() || networkInterface.isVirtual()) {
                    continue;
                }

                Enumeration<InetAddress> addresses = networkInterface.getInetAddresses();

                while (addresses.hasMoreElements()) {
                    InetAddress address = addresses.nextElement();

                    if (address instanceof Inet4Address) {
                        log("Interface " + networkInterface.getName() + " IPv4: " + address.getHostAddress());
                    }
                }
            }
        } catch (SocketException e) {
            log("Failed to enumerate network interfaces: " + e.getMessage());
        }
    }

    private void log(String message) {
        System.out.println("[PCControllerServer] " + message);
    }
}
