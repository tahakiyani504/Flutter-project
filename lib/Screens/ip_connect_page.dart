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


  static const int serverPort = 12345;


  String status = "Not Connected";


  bool isLoading = false;


  bool isConnecting = false;


  List<String> availablePCs = [];


  String? selectedIP;



  @override
  void dispose() {

    ipController.dispose();

    super.dispose();

  }




  Future<void> autoDetectPCs() async {


    setState(() {

      isLoading = true;

      status = "Searching for PCs...";

      availablePCs.clear();

    });



    try {


      List<String> pcs =
      await DiscoveryService.findPCs();



      setState(() {


        availablePCs = pcs;


        isLoading = false;



        if (pcs.isNotEmpty) {


          selectedIP = pcs.first;


          ipController.text =
              pcs.first;


          status =
          "${pcs.length} PC(s) Found";


        }

        else {


          status =
          "No PC Found";

        }


      });



    }

    catch(e) {


      setState(() {


        isLoading = false;

        status =
        "Discovery Failed";


      });


    }


  }







  Future<void> connectToPC() async {


    String ip =
    ipController.text.trim();



    if(ip.isEmpty) {


      setState(() {

        status =
        "Enter IP Address";

      });


      return;

    }




    setState(() {


      isConnecting = true;

      status =
      "Connecting...";


    });





    bool connected =
    await SocketService.connect(
      ip,
      serverPort,
    );





    if(connected) {


      setState(() {


        status =
        "Connected Successfully";


        isConnecting = false;


      });



      Navigator.pushReplacementNamed(
        context,
        "/home",
      );



    }

    else {


      setState(() {


        status =
        "Connection Failed";


        isConnecting = false;


      });


    }



  }







  Widget buildHeader() {


    return Container(

      width: double.infinity,

      padding:
      const EdgeInsets.all(24),


      decoration: const BoxDecoration(

        gradient: LinearGradient(

          colors: [

            Color(0xff1565C0),

            Color(0xff42A5F5),

          ],

          begin: Alignment.topLeft,

          end: Alignment.bottomRight,

        ),

        borderRadius: BorderRadius.only(

          bottomLeft: Radius.circular(30),

          bottomRight: Radius.circular(30),

        ),

      ),


      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,


        children: [


          const Icon(

            Icons.computer_rounded,

            color: Colors.white,

            size: 50,

          ),



          const SizedBox(height: 12),



          const Text(

            "PC Controller",

            style: TextStyle(

              color: Colors.white,

              fontSize: 28,

              fontWeight: FontWeight.bold,

            ),

          ),



          const SizedBox(height: 6),



          Text(

            "Connect your PC wirelessly",

            style: TextStyle(

              color:
              Colors.white.withOpacity(.9),

              fontSize: 15,

            ),

          ),


        ],


      ),


    );


  }








  Widget buildStatusCard() {


    return Card(

      elevation: 4,

      shape: RoundedRectangleBorder(

        borderRadius:
        BorderRadius.circular(18),

      ),


      child: Padding(

        padding:
        const EdgeInsets.all(18),


        child: Row(


          children: [


            CircleAvatar(

              radius: 22,

              backgroundColor:
              status.contains("Connected")

                  ? Colors.green

                  : Colors.orange,


              child: Icon(

                status.contains("Connected")

                    ? Icons.check

                    : Icons.wifi_find,

                color: Colors.white,

              ),

            ),



            const SizedBox(width: 15),



            Expanded(

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,


                children: [


                  const Text(

                    "Connection Status",

                    style: TextStyle(

                      fontWeight:
                      FontWeight.bold,

                      fontSize: 16,

                    ),

                  ),



                  const SizedBox(height: 4),



                  Text(status),


                ],


              ),

            )



          ],


        ),


      ),


    );


  }








  Widget buildPCList() {


    if(isLoading) {


      return const Padding(

        padding:
        EdgeInsets.all(25),

        child: Center(

          child:
          CircularProgressIndicator(),

        ),

      );


    }



    if(availablePCs.isEmpty) {


      return Card(


        child: Padding(

          padding:
          const EdgeInsets.all(25),


          child: Column(


            children: const [


              Icon(

                Icons.search_off,

                size: 45,

                color: Colors.grey,

              ),



              SizedBox(height:10),



              Text(

                "No PC detected",

                style: TextStyle(

                  fontSize:16,

                  fontWeight:
                  FontWeight.bold,

                ),

              ),


              SizedBox(height:5),


              Text(

                "Press Auto Detect to search",

                textAlign:
                TextAlign.center,

              )

            ],


          ),

        ),

      );


    }






    return Column(


      crossAxisAlignment:
      CrossAxisAlignment.start,


      children: [



        const Text(

          "Available PCs",

          style: TextStyle(

            fontSize:20,

            fontWeight:
            FontWeight.bold,

          ),

        ),



        const SizedBox(height:10),




        ...availablePCs.map((ip){



          bool selected =
              selectedIP == ip;




          return Card(

            elevation:
            selected ? 6 : 2,


            color:
            selected

                ? Colors.blue.shade50

                : null,



            shape:
            RoundedRectangleBorder(

              borderRadius:
              BorderRadius.circular(16),

            ),



            child: ListTile(



              leading: CircleAvatar(

                backgroundColor:
                Colors.blue,

                child: const Icon(

                  Icons.desktop_windows,

                  color: Colors.white,

                ),

              ),




              title: Text(

                "PC Controller",

                style: TextStyle(

                  fontWeight:
                  FontWeight.bold,

                ),

              ),



              subtitle: Text(ip),



              trailing:

              selected

                  ? const Icon(

                Icons.check_circle,

                color: Colors.green,

              )

                  : null,





              onTap: () {


                setState(() {


                  selectedIP = ip;


                  ipController.text =
                      ip;


                });


              },


            ),

          );


        })



      ],


    );


  }








  @override
  Widget build(BuildContext context) {


    return Scaffold(


      body: SafeArea(


        child: SingleChildScrollView(


          child: Column(


            children: [


              buildHeader(),



              Padding(

                padding:
                const EdgeInsets.all(20),


                child: Column(


                  children: [



                    buildStatusCard(),



                    const SizedBox(height:20),




                    TextField(

                      controller:
                      ipController,


                      decoration:
                      InputDecoration(

                        labelText:
                        "Enter PC IP Address",

                        prefixIcon:
                        const Icon(

                          Icons.language,

                        ),


                        border:
                        OutlineInputBorder(

                          borderRadius:
                          BorderRadius.circular(15),

                        ),

                      ),

                    ),





                    const SizedBox(height:15),





                    SizedBox(

                      width:
                      double.infinity,


                      child: ElevatedButton.icon(


                        onPressed:
                        isLoading
                            ? null
                            : autoDetectPCs,


                        icon:
                        const Icon(
                          Icons.wifi_find,
                        ),


                        label:
                        const Text(
                          "Auto Detect PC",
                        ),


                      ),

                    ),




                    const SizedBox(height:15),





                    SizedBox(

                      width:
                      double.infinity,


                      child: ElevatedButton.icon(


                        onPressed:
                        isConnecting
                            ? null
                            : connectToPC,


                        icon:

                        isConnecting

                            ? const SizedBox(

                          width:20,

                          height:20,

                          child:
                          CircularProgressIndicator(

                            strokeWidth:2,

                            color:
                            Colors.white,

                          ),

                        )

                            : const Icon(
                          Icons.login,
                        ),



                        label:
                        Text(

                          isConnecting

                              ? "Connecting..."

                              : "Connect",

                        ),


                      ),

                    ),





                    const SizedBox(height:25),




                    buildPCList(),




                  ],


                ),

              )



            ],


          ),


        ),


      ),


    );


  }


}