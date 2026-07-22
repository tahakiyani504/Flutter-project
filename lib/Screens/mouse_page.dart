import 'package:flutter/material.dart';
import '../services/socket_service.dart';

class MousePage extends StatefulWidget {
  const MousePage({super.key});

  @override
  State<MousePage> createState() => _MousePageState();
}

class _MousePageState extends State<MousePage> {
  Offset lastPosition = Offset.zero;

  void sendMouseMove(DragUpdateDetails details) {
    final dx = details.delta.dx.toInt();
    final dy = details.delta.dy.toInt();

    SocketService.sendCommand("MOVE:$dx,$dy");
  }

  void leftClick() {
    SocketService.sendCommand("LEFT_CLICK");
  }

  void rightClick() {
    SocketService.sendCommand("RIGHT_CLICK");
  }

  void scrollUp() {
    SocketService.sendCommand("SCROLL_UP");
  }

  void scrollDown() {
    SocketService.sendCommand("SCROLL_DOWN");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mouse Controller"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // Mouse Pad
            Expanded(
              child: GestureDetector(
                onPanUpdate: sendMouseMove,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.black26),
                  ),
                  child: const Center(
                    child: Text(
                      "Touch Here",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Left & Right Click
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: leftClick,
                    child: const Text("Left Click"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: rightClick,
                    child: const Text("Right Click"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Scroll Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: scrollUp,
                    child: const Icon(Icons.keyboard_arrow_up),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: scrollDown,
                    child: const Icon(Icons.keyboard_arrow_down),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}