import 'package:flutter/material.dart';
import '../services/socket_service.dart';


class PowerPage extends StatelessWidget {
  const PowerPage({super.key});


  void confirmAndSend(BuildContext context, String command) {

    String message;

    switch(command) {

      case "POWER_OFF":
        message = "Shut down the PC?";
        break;

      case "RESTART":
        message = "Restart the PC?";
        break;

      case "SLEEP":
        message = "Put PC to sleep?";
        break;

      default:
        message = "Continue?";
    }


    showDialog(
      context: context,

      builder: (context) {

        return AlertDialog(

          title: const Text("Confirm Action"),

          content: Text(message),


          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("Cancel"),
            ),


            ElevatedButton(

              onPressed: () {

                Navigator.pop(context);

                sendCommand(context, command);

              },

              child: const Text("Yes"),

            ),

          ],
        );

      },
    );

  }



  void sendCommand(BuildContext context, String command) {

    try {

      SocketService.sendCommand(command);


      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(
          content: Text("$command sent"),
        ),

      );


    } catch(e) {


      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content: Text("Failed to send command"),
        ),

      );


    }

  }




  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar: AppBar(

        title: const Text("Power Control"),

        centerTitle: true,

      ),



      body: Center(

        child: Container(

          width: 322,

          padding: const EdgeInsets.symmetric(
            vertical: 50,
            horizontal: 32,
          ),


          decoration: BoxDecoration(

            color: const Color(0xFF1F1F24),

            borderRadius: BorderRadius.circular(36),

            border: Border.all(
              color: const Color(0xFF2C2C30),
            ),

            boxShadow: const [

              BoxShadow(
                blurRadius: 10,
              ),

            ],

          ),



          child: Column(

            mainAxisSize: MainAxisSize.min,

            children: [


              powerButton(

                text: "Power Off",

                color: Colors.red,

                icon: Icons.power_settings_new,

                onTap: () {

                  confirmAndSend(
                    context,
                    "POWER_OFF",
                  );

                },

              ),



              const SizedBox(height: 20),



              powerButton(

                text: "Restart",

                color: Colors.orange,

                icon: Icons.restart_alt,

                onTap: () {

                  confirmAndSend(
                    context,
                    "RESTART",
                  );

                },

              ),



              const SizedBox(height: 20),



              powerButton(

                text: "Sleep",

                color: Colors.green,

                icon: Icons.bedtime,

                onTap: () {

                  confirmAndSend(
                    context,
                    "SLEEP",
                  );

                },

              ),



            ],

          ),

        ),

      ),

    );

  }





  Widget powerButton({

    required String text,

    required Color color,

    required IconData icon,

    required VoidCallback onTap,

  }) {


    return SizedBox(

      width: 240,

      height: 52,


      child: ElevatedButton.icon(

        onPressed: onTap,


        icon: Icon(
          icon,
          color: Colors.white,
        ),


        label: Text(

          text,

          style: const TextStyle(

            color: Colors.white,

            fontSize: 15,

          ),

        ),



        style: ElevatedButton.styleFrom(

          backgroundColor: color,

          shape: RoundedRectangleBorder(

            borderRadius: BorderRadius.circular(26),

          ),

        ),

      ),

    );

  }


}