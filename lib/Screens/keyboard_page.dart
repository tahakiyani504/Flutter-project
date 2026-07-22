import 'package:flutter/material.dart';
import '../services/socket_service.dart';

class KeyboardPage extends StatefulWidget {
  const KeyboardPage({super.key});

  @override
  State<KeyboardPage> createState() => _KeyboardPageState();
}

class _KeyboardPageState extends State<KeyboardPage> {


  void sendKey(String key) {
    SocketService.sendCommand(
      '{"type":"KEY_PRESS","key":"$key"}',
    );
  }


  void sendCombo(String combo) {
    SocketService.sendCommand(
      '{"type":"KEY_COMBO","keys":"$combo"}',
    );
  }


  Widget keyButton(String text,
      {double width = 45, String? command}) {

    return Container(
      margin: const EdgeInsets.all(3),

      child: SizedBox(
        width: width,
        height: 45,

        child: ElevatedButton(

          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: Colors.grey[850],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),

          onPressed: () {
            sendKey(command ?? text);
          },

          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
            ),
          ),

        ),
      ),
    );
  }



  Widget keyboardRow(List<Widget> keys){

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: keys,
    );

  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor: const Color(0xff121212),

      appBar: AppBar(

        title: const Text(
          "Keyboard",
        ),

        centerTitle: true,

      ),


      body: SingleChildScrollView(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [


            const SizedBox(height: 15),


            // Number Row
            keyboardRow([

              keyButton("Esc"),

              keyButton("1"),
              keyButton("2"),
              keyButton("3"),
              keyButton("4"),
              keyButton("5"),
              keyButton("6"),
              keyButton("7"),
              keyButton("8"),
              keyButton("9"),
              keyButton("0"),

              keyButton("-"),
              keyButton("="),

              keyButton(
                "Back",
                width: 70,
                command: "BACKSPACE",
              ),

            ]),



            // Q Row
            keyboardRow([

              keyButton(
                "Tab",
                width: 60,
              ),

              keyButton("Q"),
              keyButton("W"),
              keyButton("E"),
              keyButton("R"),
              keyButton("T"),
              keyButton("Y"),
              keyButton("U"),
              keyButton("I"),
              keyButton("O"),
              keyButton("P"),

              keyButton("["),
              keyButton("]"),

            ]),



            // A Row
            keyboardRow([

              keyButton(
                "Caps",
                width: 70,
              ),

              keyButton("A"),
              keyButton("S"),
              keyButton("D"),
              keyButton("F"),
              keyButton("G"),
              keyButton("H"),
              keyButton("J"),
              keyButton("K"),
              keyButton("L"),

              keyButton(";"),
              keyButton("'"),

              keyButton(
                "Enter",
                width: 75,
                command: "ENTER",
              ),

            ]),




            // Z Row
            keyboardRow([


              keyButton(
                "Shift",
                width: 85,
              ),


              keyButton("Z"),
              keyButton("X"),
              keyButton("C"),
              keyButton("V"),
              keyButton("B"),
              keyButton("N"),
              keyButton("M"),

              keyButton(","),
              keyButton("."),
              keyButton("/"),


              keyButton(
                "Shift",
                width: 85,
              ),


            ]),




            // Bottom Row

            keyboardRow([


              keyButton(
                "Ctrl",
                width: 60,
              ),


              keyButton(
                "Alt",
                width: 55,
              ),



              SizedBox(

                width: 180,
                height: 45,

                child: ElevatedButton(

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[850],
                    foregroundColor: Colors.white,
                  ),


                  onPressed: (){

                    sendKey("SPACE");

                  },


                  child: const Text(
                    "SPACE",
                  ),

                ),

              ),



              keyButton(
                "Alt",
                width: 55,
              ),



              keyButton(
                "Ctrl",
                width: 60,
              ),



            ]),



            const SizedBox(height: 25),



            // Arrow Keys

            keyboardRow([


              keyButton(
                "↑",
                command: "ARROW_UP",
              )


            ]),



            keyboardRow([

              keyButton(
                "←",
                command: "ARROW_LEFT",
              ),


              keyButton(
                "↓",
                command: "ARROW_DOWN",
              ),


              keyButton(
                "→",
                command: "ARROW_RIGHT",
              ),


            ]),



            const SizedBox(height:20),



            // Shortcut Buttons

            Wrap(

              alignment: WrapAlignment.center,

              children: [


                ElevatedButton(

                  onPressed: (){

                    sendCombo(
                      "CTRL+ALT+DELETE",
                    );

                  },

                  child: const Text(
                    "CTRL + ALT + DEL",
                  ),

                ),



                const SizedBox(width:10),



                ElevatedButton(

                  onPressed: (){

                    sendCombo(
                      "ALT+TAB",
                    );

                  },

                  child: const Text(
                    "ALT + TAB",
                  ),

                ),



              ],

            )



          ],

        ),

      ),

    );
  }
}