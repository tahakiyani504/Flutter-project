import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

class SocketService {
  static Socket? socket;

  static ValueNotifier<bool> connectionStatus =
  ValueNotifier<bool>(false);

  static DateTime _lastMouseMove =
  DateTime.fromMillisecondsSinceEpoch(0);

  // ===============================
  // CONNECT
  // ===============================

  static Future<bool> connect(
      String ip,
      int port,
      ) async {
    try {
      await disconnect();

      socket = await Socket.connect(
        ip,
        port,
        timeout: const Duration(seconds: 5),
      );

      connectionStatus.value = true;

      print("Connected Successfully");

      socket!.listen(
            (data) {
          final msg = utf8.decode(data);
          print("Server: $msg");
        },
        onError: (error) {
          print("Socket Error: $error");

          connectionStatus.value = false;

          socket = null;
        },
        onDone: () {
          print("Server Disconnected");

          connectionStatus.value = false;

          socket = null;
        },
        cancelOnError: true,
      );

      return true;
    } catch (e) {
      print("Connection Failed: $e");

      socket = null;

      connectionStatus.value = false;

      return false;
    }
  }

  // ===============================
  // NORMAL COMMAND
  // ===============================

  static void sendCommand(String command) {
    final s = socket;

    if (s == null || !connectionStatus.value) {
      return;
    }

    try {
      s.add(utf8.encode("$command\n"));
    } catch (e) {
      print("Send Error: $e");

      connectionStatus.value = false;
    }
  }

  // ===============================
  // FAST MOUSE MOVE
  // ===============================

  static void sendMouseMove(
      String command,
      ) {
    final s = socket;

    if (s == null || !connectionStatus.value) {
      return;
    }

    final now = DateTime.now();

    // 60 FPS
    if (now.difference(_lastMouseMove).inMilliseconds < 16) {
      return;
    }

    _lastMouseMove = now;

    try {
      s.add(utf8.encode("$command\n"));
    } catch (e) {
      print("Mouse Send Error: $e");
    }
  }

  // ===============================
  // DISCONNECT
  // ===============================

  static Future<void> disconnect() async {
    try {
      final oldSocket = socket;

      socket = null;

      connectionStatus.value = false;

      if (oldSocket != null) {
        await oldSocket.close();
      }
    } catch (e) {
      print("Disconnect Error: $e");
    }
  }
}