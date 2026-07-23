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



  double mouseSpeed = 1.0;


  Offset? lastPosition;


  late AnimationController glowController;




  @override
  void initState() {

    super.initState();


    glowController = AnimationController(

      vsync:this,

      duration:
      const Duration(seconds:2),

    )..repeat(

      reverse:true,

    );

  }





  @override
  void dispose() {

    glowController.dispose();

    super.dispose();

  }





  void sendMouseMove(
      double dx,
      double dy,
      ) {


    int moveX =
    (dx * mouseSpeed).round();


    int moveY =
    (dy * mouseSpeed).round();



    if(moveX == 0 && moveY == 0){

      return;

    }



    SocketService.sendCommand(

      '{"type":"MOUSE_MOVE","x":$moveX,"y":$moveY}',

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







  void scrollMouse(
      int amount,
      ){


    SocketService.sendCommand(

      '{"type":"MOUSE_SCROLL","amount":$amount}',

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
                      Colors.green
                          .withOpacity(.15),

                      borderRadius:
                      BorderRadius.circular(20),

                      border:

                      Border.all(

                        color:
                        Colors.greenAccent,

                      ),

                    ),



                    child:


                    const Row(

                      children:[


                        Icon(

                          Icons.circle,

                          size:10,

                          color:
                          Colors.greenAccent,

                        ),


                        SizedBox(width:8),


                        Text(

                          "Connected",

                          style:

                          TextStyle(

                            color:
                            Colors.greenAccent,

                            fontSize:13,

                          ),

                        ),


                      ],

                    ),

                  ),



                ],

              ),





              const SizedBox(height:25),






              Expanded(


                child:


                AnimatedBuilder(

                  animation:
                  glowController,


                  builder:
                      (context,child){



                    return Container(



                      decoration:

                      BoxDecoration(



                        borderRadius:
                        BorderRadius.circular(30),



                        color:

                        Colors.white
                            .withOpacity(.06),




                        border:

                        Border.all(

                          color:

                          Colors.blueAccent
                              .withOpacity(.4),

                          width:1.5,

                        ),



                        boxShadow:[



                          BoxShadow(

                            color:

                            Colors.blueAccent
                                .withOpacity(

                              0.15 +
                                  glowController.value *
                                      .15,

                            ),


                            blurRadius:35,

                            spreadRadius:5,

                          ),


                        ],



                      ),




                      child:


                      GestureDetector(



                        onPanStart:(details){


                          lastPosition =
                              details.localPosition;


                        },





                        onPanUpdate:(details){



                          if(lastPosition != null){



                            Offset difference =

                                details.localPosition -
                                    lastPosition!;



                            sendMouseMove(

                              difference.dx,

                              difference.dy,

                            );



                            lastPosition =
                                details.localPosition;


                          }



                        },





                        onPanEnd:(details){


                          lastPosition = null;


                        },





                        onTap:


                        leftClick,





                        onLongPress:


                        rightClick,





                        onVerticalDragUpdate:


                            (details){


                          if(details.delta.dy > 0){

                            scrollMouse(-1);

                          }

                          else{

                            scrollMouse(1);

                          }


                        },





                        child:


                        Center(


                          child:


                          Column(


                            mainAxisAlignment:
                            MainAxisAlignment.center,



                            children:[




                              Icon(

                                Icons.touch_app_rounded,

                                size:80,

                                color:

                                Colors.blueAccent
                                    .withOpacity(.8),

                              ),





                              const SizedBox(height:20),




                              Text(


                                "Touchpad",


                                style:


                                TextStyle(


                                  color:
                                  Colors.white
                                      .withOpacity(.9),


                                  fontSize:24,


                                  fontWeight:
                                  FontWeight.bold,


                                ),


                              ),




                              const SizedBox(height:10),




                              Text(


                                "Drag to move mouse\nTap for left click\nHold for right click",


                                textAlign:
                                TextAlign.center,


                                style:


                                TextStyle(


                                  color:
                                  Colors.grey.shade400,


                                  height:1.5,


                                ),


                              ),




                            ],



                          ),



                        ),



                      ),



                    );


                  },

                ),

              ),





              const SizedBox(height:20),





              Row(


                children:[



                  Expanded(


                    child:


                    _mouseButton(

                      icon:
                      Icons.ads_click,

                      title:
                      "Left Click",

                      onTap:
                      leftClick,

                    ),

                  ),





                  const SizedBox(width:15),




                  Expanded(


                    child:


                    _mouseButton(

                      icon:
                      Icons.mouse,

                      title:
                      "Right Click",

                      onTap:
                      rightClick,

                    ),

                  ),




                ],

              ),





              const SizedBox(height:20),






              Row(


                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,



                children:[




                  const Text(

                    "Mouse Speed",

                    style:

                    TextStyle(

                      color:
                      Colors.white,

                      fontSize:16,

                    ),

                  ),




                  Text(

                    "${mouseSpeed.toStringAsFixed(1)}x",

                    style:

                    const TextStyle(

                      color:
                      Colors.blueAccent,

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),




                ],

              ),





              Slider(


                value:
                mouseSpeed,



                min:
                0.5,


                max:
                3.0,



                divisions:
                10,



                activeColor:
                Colors.blueAccent,



                onChanged:(value){



                  setState((){


                    mouseSpeed =
                        value;


                  });


                },


              ),





            ],

          ),

        ),

      ),


    );

  }






  Widget _mouseButton({

    required IconData icon,

    required String title,

    required VoidCallback onTap,

  }){


    return GestureDetector(


      onTap:
      onTap,



      child:


      Container(


        height:60,


        decoration:


        BoxDecoration(



          color:

          Colors.white
              .withOpacity(.08),



          borderRadius:
          BorderRadius.circular(18),



          border:

          Border.all(

            color:
            Colors.blueAccent
                .withOpacity(.3),

          ),



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

              title,

              style:

              const TextStyle(

                color:
                Colors.white,

                fontWeight:
                FontWeight.bold,

              ),

            ),



          ],

        ),



      ),



    );


  }


}