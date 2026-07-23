import 'package:flutter/material.dart';
import '../services/socket_service.dart';


class MediaPage extends StatefulWidget {

  const MediaPage({super.key});


  @override
  State<MediaPage> createState() => _MediaPageState();

}



class _MediaPageState extends State<MediaPage> {


  double volumeLevel = 50;



  void sendMediaCommand(String command){


    SocketService.sendCommand(command);



    if(command == "VOLUME_UP"){

      setState(() {

        volumeLevel =
            (volumeLevel + 5).clamp(0,100);

      });

    }



    if(command == "VOLUME_DOWN"){

      setState(() {

        volumeLevel =
            (volumeLevel - 5).clamp(0,100);

      });

    }


  }







  @override
  Widget build(BuildContext context) {


    return Scaffold(



      backgroundColor:
      const Color(0xff101010),





      appBar:AppBar(



        title:
        const Text(

          "Media Control",

          style:
          TextStyle(

            fontWeight:
            FontWeight.bold,

          ),

        ),



        centerTitle:true,

        backgroundColor:
        const Color(0xff101010),



      ),






      body:SafeArea(



        child:LayoutBuilder(



          builder:(context,constraints){



            return SingleChildScrollView(


              physics:
              const BouncingScrollPhysics(),



              padding:
              const EdgeInsets.all(16),



              child:Column(



                mainAxisAlignment:
                MainAxisAlignment.center,



                children:[







                  Container(



                    width:
                    constraints.maxWidth > 600

                        ? 500

                        : double.infinity,





                    padding:
                    EdgeInsets.all(

                      constraints.maxHeight < 500

                          ? 15

                          : 22,

                    ),





                    decoration:
                    BoxDecoration(



                      color:
                      const Color(0xff1c1c1c),




                      borderRadius:
                      BorderRadius.circular(25),




                      border:Border.all(

                        color:
                        Colors.blueAccent
                            .withOpacity(.3),

                      ),



                    ),






                    child:Column(



                      children:[





                        Icon(

                          Icons.music_note,

                          size:

                          constraints.maxHeight < 500

                              ? 45

                              : 60,


                          color:
                          Colors.blueAccent,

                        ),





                        const SizedBox(height:10),





                        const Text(



                          "Remote Media",



                          style:
                          TextStyle(



                            color:
                            Colors.white,



                            fontSize:20,



                            fontWeight:
                            FontWeight.bold,


                          ),


                        ),





                        const SizedBox(height:20),





                        Row(



                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,



                          children:[



                            mediaButton(

                              icon:
                              Icons.skip_previous,

                              text:"Prev",

                              command:
                              "MEDIA_PREV",

                              constraints:
                              constraints,

                            ),





                            mediaButton(

                              icon:
                              Icons.play_arrow,

                              text:"Play",

                              command:
                              "MEDIA_PLAY_PAUSE",

                              big:true,

                              constraints:
                              constraints,

                            ),





                            mediaButton(

                              icon:
                              Icons.skip_next,

                              text:"Next",

                              command:
                              "MEDIA_NEXT",

                              constraints:
                              constraints,

                            ),



                          ],


                        )



                      ],



                    ),




                  ),






                  const SizedBox(height:20),








                  Container(



                    width:
                    constraints.maxWidth > 600

                        ? 500

                        : double.infinity,




                    padding:
                    const EdgeInsets.all(20),





                    decoration:
                    BoxDecoration(



                      color:
                      const Color(0xff1c1c1c),



                      borderRadius:
                      BorderRadius.circular(25),



                    ),






                    child:Column(



                      children:[





                        Row(



                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,



                          children:[



                            const Text(

                              "Volume",

                              style:
                              TextStyle(

                                color:
                                Colors.white,

                                fontSize:18,

                                fontWeight:
                                FontWeight.bold,

                              ),

                            ),




                            Text(

                              "${volumeLevel.toInt()}%",

                              style:
                              const TextStyle(

                                color:
                                Colors.blueAccent,

                                fontSize:18,

                                fontWeight:
                                FontWeight.bold,

                              ),

                            ),



                          ],



                        ),






                        const SizedBox(height:15),






                        ClipRRect(



                          borderRadius:
                          BorderRadius.circular(20),



                          child:
                          LinearProgressIndicator(



                            minHeight:15,



                            value:
                            volumeLevel/100,



                            backgroundColor:
                            Colors.grey[800],




                            valueColor:
                            const AlwaysStoppedAnimation(

                              Colors.blueAccent,

                            ),




                          ),



                        ),





                        const SizedBox(height:25),







                        Row(



                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,



                          children:[



                            mediaButton(

                              icon:
                              Icons.volume_down,

                              text:"Vol -",

                              command:
                              "VOLUME_DOWN",

                              constraints:
                              constraints,

                            ),





                            mediaButton(

                              icon:
                              Icons.stop,

                              text:"Stop",

                              command:
                              "MEDIA_STOP",

                              constraints:
                              constraints,

                            ),





                            mediaButton(

                              icon:
                              Icons.volume_up,

                              text:"Vol +",

                              command:
                              "VOLUME_UP",

                              constraints:
                              constraints,

                            ),



                          ],



                        )




                      ],



                    ),




                  ),




                ],



              ),



            );



          },

        ),



      ),



    );


  }












  Widget mediaButton({


    required IconData icon,

    required String text,

    required String command,

    required BoxConstraints constraints,


    bool big=false,


  }) {



    double size = constraints.maxWidth < 400

        ? 65

        : 75;



    if(big){

      size += 15;

    }






    return InkWell(



      borderRadius:
      BorderRadius.circular(20),




      onTap:(){



        sendMediaCommand(command);



      },




      child:AnimatedContainer(



        duration:
        const Duration(milliseconds:200),




        width:size,

        height:size,




        decoration:
        BoxDecoration(



          color:

          big

              ? Colors.blueAccent

              : const Color(0xff252525),




          borderRadius:
          BorderRadius.circular(20),




          boxShadow:[



            BoxShadow(

              blurRadius:10,

              color:
              Colors.black.withOpacity(.5),

            )


          ],



        ),





        child:Column(



          mainAxisAlignment:
          MainAxisAlignment.center,



          children:[



            Icon(

              icon,

              size:
              big ? 35 : 28,

              color:
              Colors.white,

            ),





            const SizedBox(height:5),






            Text(



              text,



              textAlign:
              TextAlign.center,



              style:
              const TextStyle(



                color:
                Colors.white,



                fontSize:10,



                fontWeight:
                FontWeight.w600,


              ),



            ),



          ],



        ),




      ),



    );


  }



}