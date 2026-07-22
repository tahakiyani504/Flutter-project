import 'package:flutter/material.dart';
import '../services/socket_service.dart';

class MediaPage extends StatelessWidget {
  const MediaPage({super.key});


  void sendMediaCommand(String command) {
    SocketService.sendCommand(command);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Media Control"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                mediaButton(
                  icon: Icons.skip_previous,
                  text: "Previous",
                  command: "MEDIA_PREV",
                ),


                mediaButton(
                  icon: Icons.play_arrow,
                  text: "Play/Pause",
                  command: "MEDIA_PLAY_PAUSE",
                ),


                mediaButton(
                  icon: Icons.skip_next,
                  text: "Next",
                  command: "MEDIA_NEXT",
                ),

              ],
            ),


            const SizedBox(height: 40),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [


                mediaButton(
                  icon: Icons.stop,
                  text: "Stop",
                  command: "MEDIA_STOP",
                ),


                mediaButton(
                  icon: Icons.volume_down,
                  text: "Volume -",
                  command: "VOLUME_DOWN",
                ),


                mediaButton(
                  icon: Icons.volume_up,
                  text: "Volume +",
                  command: "VOLUME_UP",
                ),

              ],
            ),


          ],
        ),
      ),
    );
  }



  Widget mediaButton({
    required IconData icon,
    required String text,
    required String command,
  }) {

    return ElevatedButton(

      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),


      onPressed: () {
        sendMediaCommand(command);
      },


      child: Column(
        children: [

          Icon(
            icon,
            size: 30,
          ),


          const SizedBox(height: 5),


          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),

        ],
      ),
    );
  }

}