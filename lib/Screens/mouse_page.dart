import 'package:flutter/material.dart';
import '../services/socket_service.dart';


class MousePage extends StatefulWidget {

  const MousePage({super.key});


  @override
  State<MousePage> createState() =>
      _MousePageState();

}



class _MousePageState extends State<MousePage>
    with SingleTickerProviderStateMixin {


  Offset? lastPosition;

  double mouseSpeed = 2.0;


  late AnimationController glowController;



  @override
  void initState() {

    super.initState();


    glowController =
    AnimationController(

      vsync: this,

      duration:
      const Duration(seconds: 2),

    )..repeat(
      reverse:true,
    );

  }



  @override
  void dispose(){

    glowController.dispose();

    super.dispose();

  }





  void sendMouseMove(double dx,double dy){


    int x =
    (dx * mouseSpeed).round();


    int y =
    (dy * mouseSpeed).round();



    if(x == 0 && y == 0){
      return;
    }



    SocketService.sendCommand(

      '{"type":"MOUSE_MOVE","dx":$x,"dy":$y}',

    );


  }






  void leftClick(){

    SocketService.sendCommand(

      '{"type":"MOUSE_LEFT_CLICK"}',

    );

  }






  void rightClick(){

    SocketService.sendCommand(

      '{"type":"MOUSE_RIGHT_CLICK"}',

    );

  }






  void scroll(int value){

    SocketService.sendCommand(

      '{"type":"MOUSE_SCROLL","amount":$value}',

    );

  }







  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor:
      const Color(0xff050816),



      body:

      SafeArea(

        child:

        Padding(

          padding:
          const EdgeInsets.all(20),


          child:

          Column(

            children:[



              Row(

                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,


                children:[


                  const Text(

                    "Remote Mouse",

                    style:

                    TextStyle(

                      color:Colors.white,

                      fontSize:28,

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),



                  Container(

                    padding:
                    const EdgeInsets.symmetric(

                      horizontal:12,

                      vertical:8,

                    ),


                    decoration:

                    BoxDecoration(

                      color:
                      Colors.green.withOpacity(.15),


                      borderRadius:
                      BorderRadius.circular(20),


                      border:

                      Border.all(

                        color:
                        Colors.greenAccent,

                      ),

                    ),



                    child:

                    const Text(

                      "Connected",

                      style:

                      TextStyle(

                        color:
                        Colors.greenAccent,

                      ),

                    ),

                  )


                ],

              ),



              const SizedBox(height:25),






              Expanded(

                child:


                AnimatedBuilder(

                  animation:
                  glowController,


                  builder:(context,child){


                    return Container(


                      decoration:

                      BoxDecoration(

                        color:
                        Colors.white.withOpacity(.06),


                        borderRadius:
                        BorderRadius.circular(30),


                        border:

                        Border.all(

                          color:
                          Colors.blueAccent,

                        ),


                        boxShadow:[

                          BoxShadow(

                            blurRadius:30,

                            spreadRadius:5,

                            color:
                            Colors.blueAccent
                                .withOpacity(
                                .2),

                          )

                        ],

                      ),





                      child:


                      Listener(

                        onPointerDown:(event){


                          lastPosition =
                              event.localPosition;


                        },



                        onPointerMove:(event){


                          if(lastPosition != null){


                            double dx =

                                event.localPosition.dx -
                                    lastPosition!.dx;


                            double dy =

                                event.localPosition.dy -
                                    lastPosition!.dy;



                            sendMouseMove(dx, dy);



                            lastPosition =
                                event.localPosition;


                          }


                        },



                        onPointerUp:(event){

                          lastPosition=null;

                        },



                        child:

                        GestureDetector(


                          onTap:
                          leftClick,


                          onLongPress:
                          rightClick,



                          child:


                          Center(

                            child:

                            Column(

                              mainAxisAlignment:
                              MainAxisAlignment.center,


                              children:[


                                Icon(

                                  Icons.touch_app,

                                  size:80,

                                  color:
                                  Colors.blueAccent,

                                ),



                                const SizedBox(height:20),



                                const Text(

                                  "Touchpad",

                                  style:

                                  TextStyle(

                                    color:
                                    Colors.white,

                                    fontSize:25,

                                    fontWeight:
                                    FontWeight.bold,

                                  ),

                                ),



                                const SizedBox(height:10),



                                Text(

                                  "Drag = Move Mouse\nTap = Left Click\nHold = Right Click",

                                  textAlign:
                                  TextAlign.center,


                                  style:

                                  TextStyle(

                                    color:
                                    Colors.grey,

                                    height:1.5,

                                  ),

                                )


                              ],


                            ),

                          ),

                        ),

                      ),

                    );


                  },

                ),

              ),




              const SizedBox(height:15),




              GestureDetector(

                onVerticalDragUpdate:(details){


                  if(details.delta.dy > 0){

                    scroll(-3);

                  }

                  else{

                    scroll(3);

                  }

                },



                child:


                Container(

                  height:60,


                  width:220,


                  decoration:

                  BoxDecoration(

                    color:
                    Colors.white.withOpacity(.08),


                    borderRadius:
                    BorderRadius.circular(20),


                    border:

                    Border.all(

                      color:
                      Colors.blueAccent,

                    ),

                  ),



                  child:


                  const Center(

                    child:

                    Text(

                      "Scroll Area",

                      style:

                      TextStyle(

                        color:
                        Colors.white,

                        fontWeight:
                        FontWeight.bold,

                      ),

                    ),

                  ),


                ),

              ),






              const SizedBox(height:20),






              Row(

                children:[


                  Expanded(

                    child:

                    button(

                      Icons.ads_click,

                      "Left",

                      leftClick,

                    ),

                  ),



                  const SizedBox(width:15),



                  Expanded(

                    child:

                    button(

                      Icons.mouse,

                      "Right",

                      rightClick,

                    ),

                  ),



                ],

              ),





              const SizedBox(height:15),





              Row(

                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,


                children:[


                  const Text(

                    "Speed",

                    style:

                    TextStyle(

                      color:
                      Colors.white,

                    ),

                  ),



                  Text(

                    "${mouseSpeed.toStringAsFixed(1)}x",

                    style:

                    const TextStyle(

                      color:
                      Colors.blueAccent,

                    ),

                  )



                ],

              ),



              Slider(

                value:
                mouseSpeed,


                min:.5,

                max:5,


                divisions:10,


                onChanged:(v){

                  setState((){

                    mouseSpeed=v;

                  });

                },


              )



            ],

          ),

        ),

      ),

    );

  }






  Widget button(
      IconData icon,
      String text,
      VoidCallback action
      ){


    return GestureDetector(

      onTap:action,


      child:

      Container(

        height:55,


        decoration:

        BoxDecoration(

          color:
          Colors.white.withOpacity(.08),


          borderRadius:
          BorderRadius.circular(18),


        ),


        child:

        Row(

          mainAxisAlignment:
          MainAxisAlignment.center,


          children:[


            Icon(
              icon,
              color:
              Colors.blueAccent,
            ),


            const SizedBox(width:10),


            Text(

              text,

              style:

              const TextStyle(

                color:
                Colors.white,

                fontWeight:
                FontWeight.bold,

              ),

            )


          ],

        ),

      ),

    );


  }


}