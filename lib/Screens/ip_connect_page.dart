import 'package:flutter/material.dart';

import '../services/socket_service.dart';
import '../services/discovery_service.dart';


class IPConnectPage extends StatefulWidget {

  const IPConnectPage({super.key});

  @override
  State<IPConnectPage> createState() =>
      _IPConnectPageState();

}



class _IPConnectPageState extends State<IPConnectPage> {


  final TextEditingController ipController =
  TextEditingController();


  String status =
      "Not Connected";


  bool isLoading =
  false;


  static const int serverPort = 12345;



  @override
  void dispose() {

    ipController.dispose();

    super.dispose();

  }




  Future<void> autoDetectPC() async {


    setState(() {

      isLoading = true;
      status = "Searching PC...";

    });



    try {


      List<String> pcs =
      await DiscoveryService.findPCs();



      if(pcs.isNotEmpty){


        ipController.text =
            pcs.first;



        setState(() {

          status =
          "PC Found: ${pcs.first}";

        });



      }

      else{


        setState(() {

          status =
          "No PC Found";

        });


      }



    }

    catch(e){


      setState(() {

        status =
        "Discovery Failed";

      });


    }




    setState(() {

      isLoading = false;

    });


  }






  Future<void> connectToPC() async {


    String ip =
    ipController.text.trim();



    if(ip.isEmpty){


      setState(() {

        status =
        "Enter IP Address";

      });


      return;

    }




    setState(() {

      isLoading = true;
      status = "Connecting...";

    });




    bool connected =
    await SocketService.connect(
      ip,
      serverPort,
    );





    if(connected){


      setState(() {

        status =
        "Connected";

      });




      await Future.delayed(

        const Duration(milliseconds:500),

      );



      if(mounted){

        Navigator.pushReplacementNamed(
          context,
          "/home",
        );

      }


    }

    else{


      setState(() {

        status =
        "Connection Failed";

      });


    }




    setState(() {

      isLoading = false;

    });


  }





  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor:
      const Color(0xff050816),



      body:

      SafeArea(

        child:

        Center(

          child:

          SingleChildScrollView(

            padding:
            const EdgeInsets.all(24),



            child:

            Column(

              mainAxisAlignment:
              MainAxisAlignment.center,


              children: [



                Container(

                  height:90,

                  width:90,


                  decoration:

                  BoxDecoration(

                    shape:
                    BoxShape.circle,


                    gradient:

                    const LinearGradient(

                      colors:[

                        Colors.blueAccent,

                        Colors.cyanAccent,

                      ],

                    ),


                    boxShadow:[

                      BoxShadow(

                        color:
                        Colors.blueAccent
                            .withOpacity(.4),

                        blurRadius:30,

                      )

                    ],

                  ),



                  child:

                  const Icon(

                    Icons.computer,

                    size:45,

                    color:Colors.white,

                  ),

                ),




                const SizedBox(height:25),




                const Text(

                  "PC Controller",

                  style:

                  TextStyle(

                    color:Colors.white,

                    fontSize:30,

                    fontWeight:FontWeight.bold,

                  ),

                ),




                const SizedBox(height:10),




                Text(

                  "Connect your PC using WiFi",

                  style:

                  TextStyle(

                    color:Colors.grey,

                    fontSize:15,

                  ),

                ),




                const SizedBox(height:35),





                Container(

                  padding:
                  const EdgeInsets.all(20),


                  decoration:

                  BoxDecoration(

                    color:
                    Colors.white.withOpacity(.08),


                    borderRadius:
                    BorderRadius.circular(25),


                    border:

                    Border.all(

                      color:
                      Colors.blueAccent
                          .withOpacity(.3),

                    ),

                  ),



                  child:

                  Column(

                    children:[



                      TextField(

                        controller:
                        ipController,


                        style:

                        const TextStyle(

                          color:Colors.white,

                        ),



                        decoration:

                        InputDecoration(

                          hintText:
                          "Enter PC IP Address",


                          hintStyle:

                          TextStyle(

                            color:
                            Colors.grey.shade500,

                          ),



                          prefixIcon:

                          const Icon(

                            Icons.wifi,

                            color:
                            Colors.blueAccent,

                          ),



                          filled:true,


                          fillColor:
                          Colors.black26,



                          border:

                          OutlineInputBorder(

                            borderRadius:
                            BorderRadius.circular(15),

                            borderSide:
                            BorderSide.none,

                          ),

                        ),

                      ),





                      const SizedBox(height:20),




                      SizedBox(

                        width:
                        double.infinity,


                        height:55,


                        child:

                        ElevatedButton.icon(


                          onPressed:
                          isLoading
                              ? null
                              : autoDetectPC,



                          icon:

                          const Icon(
                            Icons.search,
                          ),



                          label:

                          const Text(
                            "Auto Detect PC",
                          ),



                          style:

                          ElevatedButton.styleFrom(

                            backgroundColor:
                            Colors.blueAccent,

                            foregroundColor:
                            Colors.white,


                            shape:

                            RoundedRectangleBorder(

                              borderRadius:
                              BorderRadius.circular(15),

                            ),

                          ),



                        ),

                      ),




                      const SizedBox(height:15),





                      SizedBox(

                        width:
                        double.infinity,


                        height:55,



                        child:

                        ElevatedButton.icon(



                          onPressed:
                          isLoading
                              ? null
                              : connectToPC,



                          icon:

                          isLoading

                              ?

                          const SizedBox(

                            height:20,

                            width:20,

                            child:

                            CircularProgressIndicator(

                              strokeWidth:2,

                              color:Colors.white,

                            ),

                          )


                              :

                          const Icon(
                            Icons.link,
                          ),




                          label:

                          Text(

                            isLoading
                                ? "Connecting..."
                                : "Connect",

                          ),




                          style:

                          ElevatedButton.styleFrom(

                            backgroundColor:
                            Colors.transparent,


                            foregroundColor:
                            Colors.white,


                            side:

                            const BorderSide(

                              color:
                              Colors.blueAccent,

                            ),



                            shape:

                            RoundedRectangleBorder(

                              borderRadius:
                              BorderRadius.circular(15),

                            ),

                          ),



                        ),

                      ),



                    ],

                  ),

                ),





                const SizedBox(height:25),




                Container(

                  padding:

                  const EdgeInsets.symmetric(

                    horizontal:20,

                    vertical:12,

                  ),



                  decoration:

                  BoxDecoration(

                    color:
                    Colors.black45,


                    borderRadius:
                    BorderRadius.circular(30),

                  ),



                  child:


                  Text(

                    status,

                    style:

                    const TextStyle(

                      color:Colors.white,

                    ),

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