import 'package:flutter/material.dart';
import '../services/socket_service.dart';


class PowerPage extends StatefulWidget {

  const PowerPage({super.key});


  @override
  State<PowerPage> createState() => _PowerPageState();

}



class _PowerPageState extends State<PowerPage> {



  void confirmAndSend(
      BuildContext context,
      String command,
      ) {


    String title;
    String message;



    switch(command){


      case "POWER_OFF":

        title = "Shutdown PC";

        message =
        "Are you sure you want to shutdown your PC?";

        break;



      case "RESTART":

        title = "Restart PC";

        message =
        "Are you sure you want to restart your PC?";

        break;



      case "SLEEP":

        title = "Sleep Mode";

        message =
        "Put your PC into sleep mode?";

        break;



      default:

        title = "Confirm";

        message =
        "Continue this action?";

    }





    showDialog(

      context: context,


      builder:(context){


        return AlertDialog(


          backgroundColor:
          const Color(0xff202020),



          shape:
          RoundedRectangleBorder(

            borderRadius:
            BorderRadius.circular(20),

          ),



          title:Text(

            title,

            style:
            const TextStyle(

              color:Colors.white,

              fontWeight:
              FontWeight.bold,

            ),

          ),



          content:Text(

            message,

            style:
            const TextStyle(

              color:Colors.white70,

            ),

          ),




          actions:[



            TextButton(

              onPressed:(){

                Navigator.pop(context);

              },


              child:
              const Text(

                "Cancel",

                style:

                TextStyle(

                  color:
                  Colors.grey,

                ),

              ),

            ),




            ElevatedButton(

              style:
              ElevatedButton.styleFrom(

                backgroundColor:
                Colors.blueAccent,

              ),


              onPressed:(){


                Navigator.pop(context);


                sendCommand(
                    context,
                    command
                );


              },



              child:
              const Text(

                "Confirm",

              ),


            ),


          ],



        );


      },

    );


  }







  void sendCommand(
      BuildContext context,
      String command,
      ){



    try{


      SocketService.sendCommand(command);



      ScaffoldMessenger.of(context)
          .showSnackBar(



        SnackBar(

          backgroundColor:
          Colors.blueAccent,


          content:
          Text(

            "$command sent",

          ),


        ),



      );



    }catch(e){


      ScaffoldMessenger.of(context)
          .showSnackBar(


        const SnackBar(

          content:
          Text(
            "Failed to send command",
          ),

        ),


      );


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

          "Power Control",

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



              child:ConstrainedBox(



                constraints:

                BoxConstraints(

                  minHeight:
                  constraints.maxHeight,

                ),



                child:Center(



                  child:Container(



                    width:

                    constraints.maxWidth > 500

                        ? 380

                        : constraints.maxWidth * .90,





                    margin:
                    const EdgeInsets.all(15),





                    padding:
                    EdgeInsets.all(

                      constraints.maxHeight < 500

                          ? 18

                          : 28,

                    ),






                    decoration:
                    BoxDecoration(



                      color:
                      const Color(0xff1c1c1c),




                      borderRadius:
                      BorderRadius.circular(30),




                      border:Border.all(

                        color:

                        Colors.blueAccent
                            .withOpacity(.25),

                      ),




                      boxShadow:[



                        BoxShadow(

                          blurRadius:20,

                          color:

                          Colors.black
                              .withOpacity(.5),

                        )

                      ],



                    ),







                    child:Column(



                      mainAxisSize:
                      MainAxisSize.min,



                      children:[




                        Container(



                          padding:
                          const EdgeInsets.all(15),




                          decoration:
                          const BoxDecoration(



                            shape:
                            BoxShape.circle,



                            color:
                            Color(0xff252525),



                          ),




                          child:
                          Icon(



                            Icons.power_settings_new,


                            size:

                            constraints.maxHeight < 500

                                ? 45

                                : 60,



                            color:
                            Colors.redAccent,


                          ),




                        ),






                        const SizedBox(height:15),







                        const Text(



                          "System Power",



                          style:
                          TextStyle(



                            color:
                            Colors.white,


                            fontSize:22,


                            fontWeight:
                            FontWeight.bold,


                          ),


                        ),







                        const SizedBox(height:25),






                        powerButton(


                          text:"Power Off",

                          icon:
                          Icons.power_settings_new,

                          color:
                          Colors.redAccent,

                          command:
                          "POWER_OFF",

                        ),






                        const SizedBox(height:12),






                        powerButton(


                          text:"Restart",

                          icon:
                          Icons.restart_alt,

                          color:
                          Colors.orangeAccent,

                          command:
                          "RESTART",

                        ),







                        const SizedBox(height:12),






                        powerButton(


                          text:"Sleep",

                          icon:
                          Icons.bedtime,

                          color:
                          Colors.green,

                          command:
                          "SLEEP",

                        ),




                      ],



                    ),



                  ),



                ),



              ),



            );


          },


        ),


      ),



    );

  }









  Widget powerButton({


    required String text,

    required IconData icon,

    required Color color,

    required String command,


  }) {



    return InkWell(



      borderRadius:
      BorderRadius.circular(18),




      onTap:(){



        confirmAndSend(

            context,

            command

        );



      },



      child:Container(



        width:
        double.infinity,



        height:
        55,



        decoration:
        BoxDecoration(



          color:
          color.withOpacity(.9),




          borderRadius:
          BorderRadius.circular(18),




          boxShadow:[



            BoxShadow(

              blurRadius:10,

              color:
              color.withOpacity(.35),

            )

          ],



        ),




        child:Row(



          mainAxisAlignment:
          MainAxisAlignment.center,



          children:[



            Icon(

              icon,

              color:
              Colors.white,

              size:26,

            ),





            const SizedBox(width:15),





            Text(



              text,



              style:
              const TextStyle(



                color:
                Colors.white,



                fontSize:16,



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