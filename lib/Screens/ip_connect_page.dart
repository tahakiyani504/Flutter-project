import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/socket_service.dart';
import '../services/discovery_service.dart';

class IPConnectPage extends StatefulWidget {
  const IPConnectPage({super.key});

  @override
  State<IPConnectPage> createState() => _IPConnectPageState();
}

class _IPConnectPageState extends State<IPConnectPage> {
  final TextEditingController ipController =
  TextEditingController();

  String status = "Not Connected";

  bool isLoading = false;

  static const int serverPort = 12345;

  // =========================================================
  // MAC SERVER DOWNLOAD
  // =========================================================

  static final Uri macServerUrl = Uri.parse(
    'https://github.com/tahakiyani504/Flutter-project/releases/download/v1.0.0/PC.Controller.Server-1.0.0.dmg',
  );

  // =========================================================
  // WINDOWS SERVER RELEASE PAGE
  // =========================================================

  static final Uri windowsServerUrl = Uri.parse(
    'https://github.com/tahakiyani504/Flutter-project/releases/tag/v1.0.0',
  );

  @override
  void dispose() {
    ipController.dispose();
    super.dispose();
  }

  // =========================================================
  // OPEN URL
  // =========================================================

  Future<void> openUrl(Uri url) async {
    try {
      final bool opened = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (!opened && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Could not open the link",
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Unable to open the link",
            ),
          ),
        );
      }
    }
  }

  // =========================================================
  // SERVER SETUP POPUP
  // =========================================================

  void openServerSetup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xff0B1020),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Column(
            children: [
              Icon(
                Icons.download_rounded,
                color: Colors.cyanAccent,
                size: 40,
              ),
              SizedBox(height: 10),
              Text(
                "PC Server Setup",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Choose your computer",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 20),

              // =================================================
              // MAC BUTTON
              // =================================================

              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await openUrl(macServerUrl);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    Colors.white.withOpacity(0.10),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    side: BorderSide(
                      color: Colors.white.withOpacity(0.25),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.laptop_mac,
                        size: 28,
                      ),

                      const SizedBox(width: 14),

                      const Expanded(
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              "For Mac",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              "Download macOS Server (.dmg)",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // =================================================
              // WINDOWS BUTTON
              // =================================================

              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await openUrl(windowsServerUrl);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    Colors.blueAccent.withOpacity(0.15),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    side: BorderSide(
                      color: Colors.blueAccent.withOpacity(0.4),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.desktop_windows,
                        size: 28,
                        color: Colors.cyanAccent,
                      ),

                      const SizedBox(width: 14),

                      const Expanded(
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              "For Windows",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              "Download Windows Server (.exe)",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================================================
  // AUTO DETECT PC
  // =========================================================

  Future<void> autoDetectPC() async {
    setState(() {
      isLoading = true;
      status = "Searching PC...";
    });

    try {
      List<String> pcs = await DiscoveryService.findPCs();

      if (pcs.isNotEmpty) {
        ipController.text = pcs.first;

        setState(() {
          status = "PC Found: ${pcs.first}";
        });
      } else {
        setState(() {
          status = "No PC Found";
        });
      }
    } catch (e) {
      setState(() {
        status = "Discovery Failed";
      });
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // =========================================================
  // CONNECT TO PC
  // =========================================================

  Future<void> connectToPC() async {
    String ip = ipController.text.trim();

    if (ip.isEmpty) {
      setState(() {
        status = "Enter IP Address";
      });

      return;
    }

    setState(() {
      isLoading = true;
      status = "Connecting...";
    });

    bool connected = await SocketService.connect(
      ip,
      serverPort,
    );

    if (connected) {
      setState(() {
        status = "Connected";
      });

      await Future.delayed(
        const Duration(milliseconds: 500),
      );

      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          "/home",
        );
      }
    } else {
      setState(() {
        status = "Connection Failed";
      });
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff050816),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                // =================================================
                // APP ICON
                // =================================================

                Container(
                  height: 90,
                  width: 90,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    gradient: const LinearGradient(
                      colors: [
                        Colors.blueAccent,
                        Colors.cyanAccent,
                      ],
                    ),

                    boxShadow: [
                      BoxShadow(
                        color:
                        Colors.blueAccent.withOpacity(.4),
                        blurRadius: 30,
                      ),
                    ],
                  ),

                  child: const Icon(
                    Icons.computer,
                    size: 45,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 25),

                // =================================================
                // TITLE
                // =================================================

                const Text(
                  "PC Controller",

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Connect your PC using WiFi",

                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 30),

                // =================================================
                // SERVER SETUP BUTTON
                // =================================================

                GestureDetector(
                  onTap: isLoading
                      ? null
                      : openServerSetup,

                  child: Container(
                    width: double.infinity,

                    padding: const EdgeInsets.all(17),

                    decoration: BoxDecoration(
                      color:
                      Colors.blueAccent.withOpacity(.10),

                      borderRadius:
                      BorderRadius.circular(18),

                      border: Border.all(
                        color:
                        Colors.blueAccent.withOpacity(.45),
                      ),

                      boxShadow: [
                        BoxShadow(
                          color:
                          Colors.blueAccent.withOpacity(.08),
                          blurRadius: 20,
                          spreadRadius: 1,
                        ),
                      ],
                    ),

                    child: Row(
                      children: [
                        Container(
                          height: 44,
                          width: 44,

                          decoration: BoxDecoration(
                            color:
                            Colors.blueAccent
                                .withOpacity(.18),

                            borderRadius:
                            BorderRadius.circular(14),
                          ),

                          child: const Icon(
                            Icons.download_rounded,
                            color: Colors.cyanAccent,
                          ),
                        ),

                        const SizedBox(width: 14),

                        const Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,

                            children: [
                              Text(
                                "PC Server Setup",

                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 4),

                              Text(
                                "Download the server for your PC",

                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Icon(
                          Icons.open_in_new_rounded,
                          color: Colors.blueAccent,
                          size: 21,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // =================================================
                // CONNECTION CARD
                // =================================================

                Container(
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color:
                    Colors.white.withOpacity(.08),

                    borderRadius:
                    BorderRadius.circular(25),

                    border: Border.all(
                      color:
                      Colors.blueAccent.withOpacity(.3),
                    ),

                    boxShadow: [
                      BoxShadow(
                        color:
                        Colors.black.withOpacity(.15),
                        blurRadius: 25,
                      ),
                    ],
                  ),

                  child: Column(
                    children: [
                      // ===========================================
                      // IP FIELD
                      // ===========================================

                      TextField(
                        controller: ipController,

                        keyboardType:
                        TextInputType.number,

                        style: const TextStyle(
                          color: Colors.white,
                        ),

                        decoration:
                        InputDecoration(
                          hintText:
                          "Enter PC IP Address",

                          hintStyle:
                          TextStyle(
                            color:
                            Colors.grey.shade500,
                          ),

                          prefixIcon:
                          const Icon(
                            Icons.wifi,
                            color:
                            Colors.blueAccent,
                          ),

                          filled: true,

                          fillColor:
                          Colors.black26,

                          border:
                          OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(15),

                            borderSide:
                            BorderSide.none,
                          ),

                          focusedBorder:
                          OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(15),

                            borderSide:
                            const BorderSide(
                              color:
                              Colors.blueAccent,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ===========================================
                      // AUTO DETECT
                      // ===========================================

                      SizedBox(
                        width: double.infinity,
                        height: 55,

                        child:
                        ElevatedButton.icon(
                          onPressed: isLoading
                              ? null
                              : autoDetectPC,

                          icon: const Icon(
                            Icons.search,
                          ),

                          label: const Text(
                            "Auto Detect PC",
                          ),

                          style:
                          ElevatedButton.styleFrom(
                            backgroundColor:
                            Colors.blueAccent,

                            foregroundColor:
                            Colors.white,

                            elevation: 0,

                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // ===========================================
                      // CONNECT
                      // ===========================================

                      SizedBox(
                        width: double.infinity,
                        height: 55,

                        child:
                        ElevatedButton.icon(
                          onPressed: isLoading
                              ? null
                              : connectToPC,

                          icon: isLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,

                            child:
                            CircularProgressIndicator(
                              strokeWidth: 2,
                              color:
                              Colors.white,
                            ),
                          )
                              : const Icon(
                            Icons.link,
                          ),

                          label: Text(
                            isLoading
                                ? "Connecting..."
                                : "Connect",
                          ),

                          style:
                          ElevatedButton.styleFrom(
                            backgroundColor:
                            Colors.transparent,

                            foregroundColor:
                            Colors.white,

                            elevation: 0,

                            side:
                            const BorderSide(
                              color:
                              Colors.blueAccent,
                            ),

                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // =================================================
                // STATUS
                // =================================================

                Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.black45,

                    borderRadius:
                    BorderRadius.circular(30),

                    border: Border.all(
                      color:
                      Colors.white.withOpacity(.06),
                    ),
                  ),

                  child: Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Container(
                        width: 8,
                        height: 8,

                        decoration:
                        BoxDecoration(
                          color:
                          status == "Connected"
                              ? Colors.greenAccent
                              : Colors.orangeAccent,

                          shape: BoxShape.circle,
                        ),
                      ),

                      const SizedBox(width: 8),

                      Text(
                        status,

                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // =================================================
                // SERVER INFO
                // =================================================

                Text(
                  "Make sure the PC Server is running\n"
                      "on the computer you want to control.",

                  textAlign: TextAlign.center,

                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}