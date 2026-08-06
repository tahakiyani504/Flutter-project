import 'dart:math';
import 'package:flutter/material.dart';
import '../services/socket_service.dart';

class MousePage extends StatefulWidget {
  const MousePage({super.key});

  @override
  State<MousePage> createState() => _MousePageState();
}

class _MousePageState extends State<MousePage>
    with SingleTickerProviderStateMixin {
  Offset? lastPosition;
  double mouseSpeed = 2.0;
  late AnimationController glowController;
  bool isTouchpadActive = false;

  @override
  void initState() {
    super.initState();
    glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    glowController.dispose();
    super.dispose();
  }

  double _accelerationFor(double distance) {
    if (distance < 1.5) return 0.5;
    if (distance < 4) return 0.85;
    if (distance < 9) return 1.35;
    if (distance < 18) return 1.9;
    if (distance < 30) return 2.4;
    return 2.9;
  }

  void sendMouseMove(double dx, double dy) {
    final double distance = sqrt(dx * dx + dy * dy);
    final double accel = _accelerationFor(distance);
    final int x = (dx * mouseSpeed * accel).round();
    final int y = (dy * mouseSpeed * accel).round();
    if (x == 0 && y == 0) return;
    SocketService.sendCommand('{"type":"MOUSE_MOVE","dx":$x,"dy":$y}');
  }

  void _resetMovementState() {
    lastPosition = null;
  }

  void leftClick() {
    SocketService.sendCommand('{"type":"MOUSE_LEFT_CLICK"}');
  }

  void rightClick() {
    SocketService.sendCommand('{"type":"MOUSE_RIGHT_CLICK"}');
  }

  void scroll(int value) {
    SocketService.sendCommand('{"type":"MOUSE_SCROLL","amount":$value}');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final double touchpadHeight = (screenHeight * .38).clamp(220.0, 380.0);
    final double horizontalPadding = (screenWidth * .05).clamp(16.0, 32.0);

    return Scaffold(
      backgroundColor: const Color(0xff050816),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff0a0f2c),
              Color(0xff050816),
              Color(0xff03040d),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: 20,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildHeader(),
                            const SizedBox(height: 22),
                            _buildTouchpad(touchpadHeight),
                            const SizedBox(height: 16),
                            _buildScrollArea(),
                            const SizedBox(height: 20),
                            _buildClickButtons(),
                            const SizedBox(height: 24),
                            _buildSpeedControl(),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Remote Mouse",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: .3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Trackpad Control",
              style: TextStyle(
                color: Colors.white.withOpacity(.45),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        _buildConnectionStatus(),
      ],
    );
  }

  Widget _buildConnectionStatus() {
    return AnimatedBuilder(
      animation: glowController,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.greenAccent.withOpacity(.7),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.greenAccent
                    .withOpacity(.15 + glowController.value * .15),
                blurRadius: 14,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.greenAccent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "Connected",
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTouchpad(double touchpadHeight) {
    return SizedBox(
      height: touchpadHeight,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: glowController,
        builder: (context, child) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(isTouchpadActive ? .10 : .06),
                  Colors.white.withOpacity(isTouchpadActive ? .04 : .02),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isTouchpadActive
                    ? Colors.blueAccent.withOpacity(.9)
                    : Colors.blueAccent.withOpacity(.35),
                width: isTouchpadActive ? 1.6 : 1.1,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: isTouchpadActive ? 35 : 25,
                  spreadRadius: isTouchpadActive ? 4 : 2,
                  color: Colors.blueAccent.withOpacity(
                    (isTouchpadActive ? .28 : .16) +
                        glowController.value * .08,
                  ),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Listener(
                onPointerDown: (e) {
                  lastPosition = e.localPosition;
                  setState(() => isTouchpadActive = true);
                },
                onPointerMove: (e) {
                  if (lastPosition != null) {
                    final double dx = e.localPosition.dx - lastPosition!.dx;
                    final double dy = e.localPosition.dy - lastPosition!.dy;
                    sendMouseMove(dx, dy);
                    lastPosition = e.localPosition;
                  }
                },
                onPointerUp: (e) {
                  _resetMovementState();
                  setState(() => isTouchpadActive = false);
                },
                onPointerCancel: (e) {
                  _resetMovementState();
                  setState(() => isTouchpadActive = false);
                },
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: leftClick,
                  onLongPress: rightClick,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.touch_app_rounded,
                          size: 70,
                          color: Colors.blueAccent
                              .withOpacity(isTouchpadActive ? 1 : .8),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          "Touchpad",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: .3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Drag = Move Mouse\nTap = Left Click\nHold = Right Click",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(.45),
                            height: 1.5,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScrollArea() {
    return GestureDetector(
      onVerticalDragUpdate: (d) {
        if (d.delta.dy > 0) {
          scroll(-3);
        } else {
          scroll(3);
        }
      },
      child: Container(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.06),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.blueAccent.withOpacity(.35),
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.unfold_more_rounded,
                color: Colors.blueAccent.withOpacity(.85),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                "Scroll Area",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClickButtons() {
    return Row(
      children: [
        Expanded(
          child: mouseButton(
            "Left",
            Icons.ads_click_rounded,
            leftClick,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: mouseButton(
            "Right",
            Icons.mouse_rounded,
            rightClick,
          ),
        ),
      ],
    );
  }

  Widget mouseButton(
      String text,
      IconData icon,
      VoidCallback action,
      ) {
    return _PressableButton(
      onTap: action,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(.10),
              Colors.white.withOpacity(.04),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(.12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.blueAccent,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeedControl() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(.08),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.speed_rounded,
                    color: Colors.blueAccent.withOpacity(.85),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Mouse Speed",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "${mouseSpeed.toStringAsFixed(1)}x",
                  style: const TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.blueAccent,
              inactiveTrackColor: Colors.white.withOpacity(.1),
              thumbColor: Colors.white,
              overlayColor: Colors.blueAccent.withOpacity(.2),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: mouseSpeed,
              min: .5,
              max: 5,
              divisions: 10,
              onChanged: (v) {
                setState(() {
                  mouseSpeed = v;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PressableButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _PressableButton({
    required this.child,
    required this.onTap,
  });

  @override
  State<_PressableButton> createState() => _PressableButtonState();
}

class _PressableButtonState extends State<_PressableButton> {
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => scale = .96),
      onTapUp: (_) => setState(() => scale = 1.0),
      onTapCancel: () => setState(() => scale = 1.0),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 100),
        child: widget.child,
      ),
    );
  }
}
