import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/socket_service.dart';

class PowerPage extends StatefulWidget {
  const PowerPage({super.key});

  @override
  State<PowerPage> createState() => _PowerPageState();
}

class _PowerPageState extends State<PowerPage>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  String? activeCommand;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  void sendPowerCommand(String command) {

    setState(() {
      activeCommand = command;
    });

    SocketService.sendCommand(command);


    Future.delayed(
      const Duration(milliseconds: 400),
          () {
        if (mounted) {
          setState(() {
            activeCommand = null;
          });
        }
      },
    );
  }



  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;


    return Scaffold(
      backgroundColor: const Color(0xff050B18),

      body: SafeArea(
        child: SingleChildScrollView(

          child: Center(

            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [


                  const SizedBox(height: 25),


                  // Heading

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: const [

                      Icon(
                        Icons.power_settings_new,
                        color: Colors.blueAccent,
                        size: 34,
                      ),

                      SizedBox(width: 12),


                      Text(
                        "Power Controller",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),


                  const SizedBox(height: 35),



                  // Main Power Card

                  _glassCard(

                    width: size.width > 600
                        ? 420
                        : size.width * 0.9,

                    child: Column(

                      children: [

                        const Icon(
                          Icons.power,
                          size: 90,
                          color: Colors.redAccent,
                        ),


                        const SizedBox(height: 15),


                        const Text(
                          "Shutdown PC",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),


                        const SizedBox(height: 10),


                        const Text(
                          "Turn off your computer instantly",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),


                        const SizedBox(height: 25),



                        _animatedButton(

                          title: "POWER OFF",

                          icon: Icons.power_settings_new,

                          color: Colors.redAccent,

                          command: "POWER_OFF",

                          height: 70,
                        ),


                      ],
                    ),
                  ),



                  const SizedBox(height: 25),



                  // Secondary actions


                  Row(

                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [

                      Expanded(

                        child: _actionCard(

                          title: "Restart",

                          icon: Icons.restart_alt,

                          color: Colors.orangeAccent,

                          command: "RESTART",

                        ),
                      ),


                      const SizedBox(width: 15),


                      Expanded(

                        child: _actionCard(

                          title: "Sleep",

                          icon: Icons.bedtime,

                          color: Colors.blueAccent,

                          command: "SLEEP",

                        ),
                      ),


                    ],
                  ),



                  const SizedBox(height: 35),


                  Container(

                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),

                    decoration: BoxDecoration(

                      color: Colors.white.withOpacity(0.05),

                      borderRadius: BorderRadius.circular(20),

                    ),


                    child: const Text(

                      "⚠ Power actions will affect your PC",

                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }




  Widget _glassCard({

    required Widget child,

    required double width,

  }) {


    return ClipRRect(

      borderRadius: BorderRadius.circular(30),


      child: BackdropFilter(

        filter: ImageFilter.blur(
          sigmaX: 15,
          sigmaY: 15,
        ),


        child: Container(

          width: width,

          padding: const EdgeInsets.all(25),


          decoration: BoxDecoration(

            color: Colors.white.withOpacity(0.08),

            borderRadius: BorderRadius.circular(30),


            border: Border.all(

              color: Colors.white.withOpacity(0.15),

            ),


            boxShadow: [

              BoxShadow(

                color: Colors.blue.withOpacity(0.15),

                blurRadius: 25,

                spreadRadius: 3,

              )

            ],

          ),


          child: child,
        ),
      ),
    );
  }




  Widget _actionCard({

    required String title,

    required IconData icon,

    required Color color,

    required String command,

  }) {


    return GestureDetector(

      onTapDown: (_) {

        _controller.forward();

      },


      onTapUp: (_) {

        _controller.reverse();

        sendPowerCommand(command);

      },


      onTapCancel: () {

        _controller.reverse();

      },


      child: AnimatedScale(

        scale: activeCommand == command ? 0.94 : 1,

        duration: const Duration(milliseconds: 150),


        child: ClipRRect(

          borderRadius: BorderRadius.circular(25),


          child: BackdropFilter(

            filter: ImageFilter.blur(
              sigmaX: 12,
              sigmaY: 12,
            ),


            child: Container(

              height: 150,


              decoration: BoxDecoration(

                color: Colors.white.withOpacity(0.07),


                borderRadius: BorderRadius.circular(25),


                border: Border.all(

                  color: color.withOpacity(0.4),

                ),

              ),


              child: Column(

                mainAxisAlignment: MainAxisAlignment.center,


                children: [

                  Icon(
                    icon,
                    size: 45,
                    color: color,
                  ),


                  const SizedBox(height: 15),


                  Text(

                    title,

                    style: const TextStyle(

                      color: Colors.white,

                      fontSize: 17,

                      fontWeight: FontWeight.bold,

                    ),
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }





  Widget _animatedButton({

    required String title,

    required IconData icon,

    required Color color,

    required String command,

    required double height,

  }) {


    return GestureDetector(

      onTapDown: (_) {

        _controller.forward();

      },


      onTapUp: (_) {

        _controller.reverse();

        sendPowerCommand(command);

      },


      onTapCancel: () {

        _controller.reverse();

      },


      child: AnimatedScale(

        scale: activeCommand == command ? 0.94 : 1,

        duration: const Duration(milliseconds: 150),


        child: Container(

          height: height,


          decoration: BoxDecoration(

            gradient: LinearGradient(

              colors: [

                color,

                color.withOpacity(0.65),

              ],

            ),


            borderRadius: BorderRadius.circular(22),


            boxShadow: [

              BoxShadow(

                color: color.withOpacity(0.5),

                blurRadius: 20,

                spreadRadius: 2,

              )

            ],

          ),


          child: Row(

            mainAxisAlignment: MainAxisAlignment.center,


            children: [


              Icon(

                icon,

                color: Colors.white,

                size: 30,

              ),


              const SizedBox(width: 12),


              Text(

                title,

                style: const TextStyle(

                  color: Colors.white,

                  fontSize: 20,

                  fontWeight: FontWeight.bold,

                  letterSpacing: 1,

                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

}