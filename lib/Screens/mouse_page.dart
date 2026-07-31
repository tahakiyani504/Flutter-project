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


  // Mouse movement optimization
  DateTime? lastMoveTime;

  int pendingX = 0;
  int pendingY = 0;



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





  // ===============================
  // OPTIMIZED MOUSE MOVE
  // ===============================

  void sendMouseMove(double dx,double dy){


    int x = (dx * mouseSpeed).round();

    int y = (dy * mouseSpeed).round();



    pendingX += x;

    pendingY += y;



    final now = DateTime.now();



    if(
    lastMoveTime == null ||
        now.difference(lastMoveTime!)
            .inMilliseconds >= 30
    ){


      if(pendingX !=0 || pendingY !=0){


        SocketService.sendCommand(
          '{"type":"MOUSE_MOVE","dx":$pendingX,"dy":$pendingY}',
        );


        pendingX = 0;

        pendingY = 0;

      }



      lastMoveTime = now;

    }


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


    final screenHeight =
        MediaQuery.of(context).size.height;


    final screenWidth =
        MediaQuery.of(context).size.width;




    final double touchpadHeight =
    (screenHeight * .38)
        .clamp(220.0,380.0);





    return Scaffold(

      backgroundColor: const Color(0xff050816),


      body: SafeArea(

        child: SingleChildScrollView(

          physics:
          const BouncingScrollPhysics(),


          padding:
          const EdgeInsets.all(20),



          child: Column(

            children: [



              Row(

                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,


                children: [


                  const Text(
                    "Remote Mouse",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),



                  Container(

                    padding:
                    const EdgeInsets.symmetric(
                      horizontal:12,
                      vertical:8,
                    ),


                    decoration: BoxDecoration(

                      color:
                      Colors.green.withOpacity(.15),

                      borderRadius:
                      BorderRadius.circular(20),

                      border:
                      Border.all(
                        color: Colors.greenAccent,
                      ),

                    ),


                    child:
                    const Text(
                      "Connected",
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  )

                ],

              ),





              const SizedBox(height:20),




              SizedBox(

                height: touchpadHeight,

                width: double.infinity,

                child: AnimatedBuilder(

                  animation: glowController,


                  builder:(context,child){


                    return Container(


                      decoration:BoxDecoration(

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

                            blurRadius:25,

                            spreadRadius:3,

                            color:
                            Colors.blueAccent
                                .withOpacity(
                                .2 +
                                    glowController.value*.1
                            ),

                          )

                        ],

                      ),





                      child: Listener(


                        onPointerDown:(e){

                          lastPosition =
                              e.localPosition;

                        },



                        onPointerMove:(e){


                          if(lastPosition != null){


                            double dx =
                                e.localPosition.dx -
                                    lastPosition!.dx;


                            double dy =
                                e.localPosition.dy -
                                    lastPosition!.dy;



                            sendMouseMove(dx,dy);



                            lastPosition =
                                e.localPosition;


                          }


                        },



                        onPointerUp:(e){

                          lastPosition=null;

                        },


                        onPointerCancel:(e){

                          lastPosition=null;

                        },



                        child: GestureDetector(


                          behavior:
                          HitTestBehavior.opaque,


                          onTap:leftClick,


                          onLongPress:rightClick,



                          child:
                          const Center(

                            child:Column(

                              mainAxisAlignment:
                              MainAxisAlignment.center,


                              children:[


                                Icon(
                                  Icons.touch_app,
                                  size:75,
                                  color:Colors.blueAccent,
                                ),



                                SizedBox(height:15),



                                Text(
                                  "Touchpad",
                                  style:TextStyle(
                                    color:Colors.white,
                                    fontSize:24,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),



                                SizedBox(height:8),



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

                onVerticalDragUpdate:(d){


                  if(d.delta.dy>0){

                    scroll(-3);

                  }
                  else{

                    scroll(3);

                  }

                },


                child:Container(

                  height:55,

                  width:220,


                  decoration:BoxDecoration(

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

                    child:Text(
                      "↕  Scroll Area",
                      style:
                      TextStyle(
                        color:Colors.white,
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
                    mouseButton(
                      "Left",
                      Icons.ads_click,
                      leftClick,
                    ),

                  ),



                  const SizedBox(width:15),



                  Expanded(

                    child:
                    mouseButton(
                      "Right",
                      Icons.mouse,
                      rightClick,
                    ),

                  )


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
                      color:Colors.white,
                      fontWeight:FontWeight.bold,
                    ),
                  ),



                  Text(
                    "${mouseSpeed.toStringAsFixed(1)}x",
                    style:
                    const TextStyle(
                      color:Colors.blueAccent,
                    ),
                  )

                ],

              ),





              Slider(

                value:mouseSpeed,

                min:.5,

                max:5,

                divisions:10,


                onChanged:(v){

                  setState(() {

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






  Widget mouseButton(
      String text,
      IconData icon,
      VoidCallback action,
      ){

    return GestureDetector(

      onTap:action,


      child:Container(

        height:55,


        decoration:BoxDecoration(

          color:
          Colors.white.withOpacity(.08),


          borderRadius:
          BorderRadius.circular(18),


        ),



        child:Row(

          mainAxisAlignment:
          MainAxisAlignment.center,


          children:[


            Icon(
              icon,
              color:Colors.blueAccent,
            ),


            const SizedBox(width:10),



            Text(
              text,
              style:
              const TextStyle(
                color:Colors.white,
                fontWeight:FontWeight.bold,
              ),
            )


          ],

        ),

      ),

    );


  }



}