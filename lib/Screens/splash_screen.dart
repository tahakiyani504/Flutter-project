import 'dart:ui';

import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});


  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();

}



class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {



  late AnimationController _scaleController;

  late AnimationController _fadeController;

  late AnimationController _glowController;

  late Animation<double> _scaleAnimation;

  late Animation<double> _fadeAnimation;

  late Animation<double> _glowAnimation;





  @override
  void initState() {

    super.initState();



    _scaleController = AnimationController(

      vsync: this,

      duration:
      const Duration(milliseconds:1200),

    );



    _fadeController = AnimationController(

      vsync: this,

      duration:
      const Duration(milliseconds:1500),

    );



    _glowController = AnimationController(

      vsync: this,

      duration:
      const Duration(seconds:2),

    );



    _scaleAnimation = Tween<double>(

      begin:0.5,

      end:1.0,

    ).animate(

      CurvedAnimation(

        parent:_scaleController,

        curve:Curves.easeOutBack,

      ),

    );





    _fadeAnimation = Tween<double>(

      begin:0,

      end:1,

    ).animate(

      CurvedAnimation(

        parent:_fadeController,

        curve:Curves.easeIn,

      ),

    );





    _glowAnimation = Tween<double>(

      begin:10,

      end:40,

    ).animate(

      CurvedAnimation(

        parent:_glowController,

        curve:Curves.easeInOut,

      ),

    );





    _scaleController.forward();

    _fadeController.forward();



    _glowController.repeat(

      reverse:true,

    );





    Future.delayed(

      const Duration(seconds:3),

          () {


        if(mounted){


          Navigator.pushReplacementNamed(

            context,

            "/connect",

          );


        }


      },

    );



  }






  @override
  void dispose() {


    _scaleController.dispose();

    _fadeController.dispose();

    _glowController.dispose();


    super.dispose();

  }






  @override
  Widget build(BuildContext context) {


    final size =
        MediaQuery.of(context).size;



    return Scaffold(


      backgroundColor:
      const Color(0xff030712),



      body:

      Container(

        width:
        size.width,

        height:
        size.height,



        decoration:

        const BoxDecoration(


          gradient:

          LinearGradient(


            begin:
            Alignment.topLeft,


            end:
            Alignment.bottomRight,



            colors:[


              Color(0xff020617),

              Color(0xff071A35),

              Color(0xff020617),


            ],


          ),


        ),



        child:


        Center(


          child:


          FadeTransition(

            opacity:
            _fadeAnimation,



            child:


            Column(


              mainAxisAlignment:
              MainAxisAlignment.center,



              children:[





                AnimatedBuilder(

                  animation:
                  _glowAnimation,


                  builder:
                      (context,child){


                    return ScaleTransition(

                      scale:
                      _scaleAnimation,



                      child:


                      Container(


                        height:
                        size.width < 600
                            ? 120
                            : 160,


                        width:
                        size.width < 600
                            ? 120
                            : 160,



                        decoration:

                        BoxDecoration(


                          shape:
                          BoxShape.circle,



                          gradient:

                          const LinearGradient(


                            colors:[


                              Color(0xff007BFF),

                              Color(0xff00D4FF),


                            ],


                          ),



                          boxShadow:[


                            BoxShadow(


                              color:

                              Colors.blueAccent
                                  .withOpacity(.55),


                              blurRadius:
                              _glowAnimation.value,


                              spreadRadius:
                              5,


                            ),


                          ],



                        ),




                        child:


                        const Icon(


                          Icons.computer_rounded,


                          color:
                          Colors.white,


                          size:75,


                        ),



                      ),


                    );


                  },


                ),





                const SizedBox(height:35),





                const Text(


                  "PC Controller",


                  textAlign:
                  TextAlign.center,



                  style:


                  TextStyle(


                    color:
                    Colors.white,


                    fontSize:34,


                    fontWeight:
                    FontWeight.w700,



                    letterSpacing:
                    1.2,


                  ),



                ),





                const SizedBox(height:12),





                Text(


                  "Control Your PC\nWirelessly",


                  textAlign:
                  TextAlign.center,



                  style:


                  TextStyle(


                    color:
                    Colors.white.withOpacity(.7),


                    fontSize:16,


                    height:1.5,


                  ),



                ),





                const SizedBox(height:45),





                Container(


                  width:
                  size.width * 0.45,


                  height:
                  5,



                  decoration:


                  BoxDecoration(


                    borderRadius:
                    BorderRadius.circular(20),


                    color:
                    Colors.white.withOpacity(.15),


                  ),



                  child:


                  const _LoadingBar(),



                ),




                const SizedBox(height:18),





                Text(


                  "Starting...",


                  style:


                  TextStyle(


                    color:
                    Colors.white.withOpacity(.5),


                    fontSize:14,


                  ),



                ),



              ],



            ),



          ),



        ),



      ),



    );

  }


}





class _LoadingBar extends StatefulWidget {


  const _LoadingBar();



  @override
  State<_LoadingBar> createState() =>
      _LoadingBarState();


}



class _LoadingBarState extends State<_LoadingBar>
    with SingleTickerProviderStateMixin {


  late AnimationController controller;



  @override
  void initState(){

    super.initState();


    controller =
    AnimationController(

      vsync:this,

      duration:
      const Duration(seconds:1),

    )..repeat();


  }





  @override
  Widget build(BuildContext context){


    return AnimatedBuilder(

      animation:
      controller,


      builder:
          (context,child){


        return FractionallySizedBox(


          alignment:
          Alignment(
            controller.value * 2 - 1,
            0,
          ),


          widthFactor:
          0.35,


          child:


          Container(


            decoration:


            BoxDecoration(


              gradient:


              const LinearGradient(


                colors:[


                  Colors.blueAccent,

                  Colors.cyanAccent,


                ],


              ),



              borderRadius:
              BorderRadius.circular(20),


            ),


          ),


        );


      },


    );


  }



  @override
  void dispose(){

    controller.dispose();

    super.dispose();

  }


}