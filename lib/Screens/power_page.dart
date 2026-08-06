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

  late AnimationController _animationController;

  String? pressedCommand;


  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }



  void sendPowerCommand(String command) {


    if(command == "POWER_OFF") {


      showDialog(

        context: context,

        builder: (context) {


          return AlertDialog(

            backgroundColor: const Color(0xff111827),


            shape: RoundedRectangleBorder(

              borderRadius: BorderRadius.circular(25),

            ),


            title: const Row(

              children: [

                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.redAccent,
                  size: 32,
                ),


                SizedBox(width: 10),


                Text(
                  "Shutdown PC?",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],

            ),



            content: const Text(

              "Are you sure you want to shutdown your computer?",

              style: TextStyle(
                color: Colors.white70,
              ),

            ),



            actions: [


              TextButton(

                onPressed: () {

                  Navigator.pop(context);

                },


                child: const Text(
                  "CANCEL",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),

              ),



              ElevatedButton(

                style: ElevatedButton.styleFrom(

                  backgroundColor: Colors.redAccent,

                  shape: RoundedRectangleBorder(

                    borderRadius: BorderRadius.circular(15),

                  ),

                ),



                onPressed: () {


                  Navigator.pop(context);


                  SocketService.sendCommand(
                    "POWER_OFF",
                  );


                },


                child: const Text(
                  "SHUTDOWN",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),

              ),


            ],

          );

        },

      );


    }

    else {


      SocketService.sendCommand(command);


    }


  }





  @override
  Widget build(BuildContext context) {


    final width = MediaQuery.of(context).size.width;


    return Scaffold(

      backgroundColor: const Color(0xff050B18),


      body: SafeArea(

        child: SingleChildScrollView(


          child: Center(


            child: Padding(

              padding: const EdgeInsets.all(20),


              child: Column(

                children: [



                  const SizedBox(height: 25),



                  Row(

                    mainAxisAlignment: MainAxisAlignment.center,

                    children: const [


                      Icon(

                        Icons.power_settings_new,

                        color: Colors.blueAccent,

                        size: 36,

                      ),



                      SizedBox(width: 12),



                      Text(

                        "Power Controller",

                        style: TextStyle(

                          color: Colors.white,

                          fontSize: 28,

                          fontWeight: FontWeight.bold,

                        ),

                      ),


                    ],

                  ),




                  const SizedBox(height: 40),





                  glassCard(

                    width > 600 ? 430 : width * .9,


                    Column(

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

                            fontSize: 25,

                            fontWeight: FontWeight.bold,

                          ),

                        ),




                        const SizedBox(height: 25),




                        powerButton(

                          "POWER OFF",

                          Icons.power_settings_new,

                          Colors.redAccent,

                          "POWER_OFF",

                        )



                      ],

                    ),

                  ),




                  const SizedBox(height: 25),




                  Row(

                    children: [


                      Expanded(

                        child: smallButton(

                          "Restart",

                          Icons.restart_alt,

                          Colors.orangeAccent,

                          "RESTART",

                        ),

                      ),



                      const SizedBox(width: 15),



                      Expanded(

                        child: smallButton(

                          "Sleep",

                          Icons.bedtime,

                          Colors.blueAccent,

                          "SLEEP",

                        ),

                      ),


                    ],

                  ),



                ],

              ),

            ),


          ),

        ),

      ),

    );

  }






  Widget glassCard(double width, Widget child){


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

            color: Colors.white.withOpacity(.08),


            borderRadius: BorderRadius.circular(30),


            border: Border.all(

              color: Colors.white.withOpacity(.15),

            ),

          ),


          child: child,

        ),

      ),

    );


  }







  Widget powerButton(

      String title,

      IconData icon,

      Color color,

      String command,

      ){



    return GestureDetector(


      onTap: (){

        sendPowerCommand(command);

      },



      child: AnimatedContainer(

        duration: const Duration(milliseconds: 200),


        height: 70,


        decoration: BoxDecoration(

          gradient: LinearGradient(

            colors: [

              color,

              color.withOpacity(.6),

            ],

          ),


          borderRadius: BorderRadius.circular(22),


          boxShadow: [

            BoxShadow(

              color: color.withOpacity(.4),

              blurRadius: 20,

            )

          ],

        ),



        child: Row(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [


            Icon(

              icon,

              color: Colors.white,

              size: 32,

            ),


            const SizedBox(width: 12),



            Text(

              title,

              style: const TextStyle(

                color: Colors.white,

                fontSize: 20,

                fontWeight: FontWeight.bold,

              ),

            ),


          ],

        ),

      ),

    );

  }







  Widget smallButton(

      String title,

      IconData icon,

      Color color,

      String command,

      ){



    return GestureDetector(


      onTap: (){


        sendPowerCommand(command);


      },



      child: Container(

        height: 150,


        decoration: BoxDecoration(


          color: Colors.white.withOpacity(.07),


          borderRadius: BorderRadius.circular(25),



          border: Border.all(

            color: color.withOpacity(.5),

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

                fontSize: 18,

                fontWeight: FontWeight.bold,

              ),

            ),


          ],

        ),


      ),

    );


  }


}