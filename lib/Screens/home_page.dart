import 'package:flutter/material.dart';
import '../services/socket_service.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});


  @override
  State<HomePage> createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {


  bool connected = false;



  @override
  void initState() {
    super.initState();
    checkConnection();
  }



  void checkConnection() {

    setState(() {

      connected = SocketService.isConnected;

    });

  }



  void disconnectPC() {

    SocketService.disconnect();


    setState(() {

      connected = false;

    });


    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(

        content: Text(
            "Disconnected from PC"
        ),

      ),

    );

  }




  void connectPC() {

    Navigator.pushNamed(
      context,
      "/connect",
    );

  }





  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor: const Color(0xff070B14),


      body: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(20),


          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,


            children: [



              const Text(

                "PC Controller",

                style: TextStyle(

                  color: Colors.white,

                  fontSize: 32,

                  fontWeight: FontWeight.bold,

                ),

              ),



              const SizedBox(height: 6),



              Text(

                "Control your PC wirelessly",

                style: TextStyle(

                  color: Colors.grey.shade400,

                  fontSize: 16,

                ),

              ),



              const SizedBox(height: 25),




              Container(

                width: double.infinity,

                padding: const EdgeInsets.all(20),


                decoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(25),


                  gradient: LinearGradient(

                    colors: [

                      Colors.blue.withOpacity(0.35),

                      Colors.blue.withOpacity(0.08),

                    ],

                    begin: Alignment.topLeft,

                    end: Alignment.bottomRight,

                  ),


                  border: Border.all(

                    color: Colors.blue.withOpacity(0.3),

                  ),


                  boxShadow: [

                    BoxShadow(

                      color: Colors.blue.withOpacity(0.15),

                      blurRadius: 25,

                      spreadRadius: 2,

                    )

                  ],

                ),




                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,


                  children: [



                    Row(

                      children: [


                        Container(

                          height: 15,

                          width: 15,


                          decoration: BoxDecoration(

                            shape: BoxShape.circle,


                            color: connected

                                ? Colors.greenAccent

                                : Colors.redAccent,

                          ),

                        ),



                        const SizedBox(width: 12),




                        Text(

                          connected

                              ? "Connected"

                              : "Disconnected",


                          style: const TextStyle(

                            color: Colors.white,

                            fontSize: 20,

                            fontWeight: FontWeight.bold,

                          ),

                        ),


                      ],

                    ),



                    const SizedBox(height: 15),




                    Text(

                      connected

                          ? "Your PC is ready to receive commands"

                          : "Connect your PC to start controlling",


                      style: TextStyle(

                        color: Colors.grey.shade300,

                        fontSize: 15,

                      ),

                    ),



                    const SizedBox(height: 20),




                    SizedBox(

                      width: double.infinity,


                      child: ElevatedButton.icon(



                        onPressed: connected

                            ? disconnectPC

                            : connectPC,



                        icon: Icon(

                          connected

                              ? Icons.power_settings_new

                              : Icons.computer,

                        ),



                        label: Text(

                          connected

                              ? "Disconnect"

                              : "Connect To PC",

                        ),




                        style: ElevatedButton.styleFrom(


                          backgroundColor:

                          connected

                              ? Colors.redAccent

                              : Colors.blueAccent,



                          foregroundColor: Colors.white,



                          padding:

                          const EdgeInsets.symmetric(

                              vertical: 14),



                          shape: RoundedRectangleBorder(

                            borderRadius:

                            BorderRadius.circular(15),

                          ),

                        ),


                      ),


                    )



                  ],

                ),

              ),





              const SizedBox(height: 30),




              const Text(

                "About",

                style: TextStyle(

                  color: Colors.white,

                  fontSize: 22,

                  fontWeight: FontWeight.bold,

                ),

              ),




              const SizedBox(height: 12),




              glassCard(

                icon: Icons.computer,

                title: "Wireless PC Control",

                subtitle:

                "Control your computer using WiFi connection with fast response.",

              ),





              const SizedBox(height: 20),




              const Text(

                "Features",

                style: TextStyle(

                  color: Colors.white,

                  fontSize: 22,

                  fontWeight: FontWeight.bold,

                ),

              ),




              const SizedBox(height: 12),




              Row(

                children: [


                  Expanded(

                    child: featureCard(

                      Icons.mouse,

                      "Mouse",

                    ),

                  ),



                  const SizedBox(width: 12),



                  Expanded(

                    child: featureCard(

                      Icons.keyboard,

                      "Keyboard",

                    ),

                  ),



                ],

              ),




              const SizedBox(height: 15),




              Row(

                children: [


                  Expanded(

                    child: featureCard(

                      Icons.volume_up,

                      "Media",

                    ),

                  ),



                  const SizedBox(width: 12),




                  Expanded(

                    child: featureCard(

                      Icons.power,

                      "Power",

                    ),

                  ),


                ],

              ),



            ],

          ),

        ),

      ),

    );

  }







  Widget glassCard({

    required IconData icon,

    required String title,

    required String subtitle,

  }) {



    return Container(

      padding: const EdgeInsets.all(18),


      decoration: BoxDecoration(

        color: Colors.white.withOpacity(0.06),


        borderRadius: BorderRadius.circular(20),


        border: Border.all(

          color: Colors.white.withOpacity(0.12),

        ),

      ),



      child: Row(

        children: [



          Container(

            padding: const EdgeInsets.all(14),


            decoration: BoxDecoration(

              color: Colors.blue.withOpacity(0.2),

              borderRadius:

              BorderRadius.circular(15),

            ),



            child: Icon(

              icon,

              color: Colors.blueAccent,

              size: 30,

            ),

          ),




          const SizedBox(width: 15),




          Expanded(

            child: Column(

              crossAxisAlignment:

              CrossAxisAlignment.start,


              children: [


                Text(

                  title,

                  style: const TextStyle(

                    color: Colors.white,

                    fontSize: 17,

                    fontWeight: FontWeight.bold,

                  ),

                ),




                const SizedBox(height: 5),




                Text(

                  subtitle,

                  style: TextStyle(

                    color: Colors.grey.shade400,

                    fontSize: 14,

                  ),

                ),


              ],

            ),

          )

        ],

      ),

    );

  }







  Widget featureCard(

      IconData icon,

      String title,

      ) {


    return Container(

      height: 120,


      decoration: BoxDecoration(

        color: Colors.white.withOpacity(0.05),


        borderRadius:

        BorderRadius.circular(20),


        border: Border.all(

          color: Colors.blue.withOpacity(0.15),

        ),

      ),



      child: Column(

        mainAxisAlignment:

        MainAxisAlignment.center,


        children: [



          Icon(

            icon,

            size: 35,

            color: Colors.blueAccent,

          ),




          const SizedBox(height: 10),




          Text(

            title,

            style: const TextStyle(

              color: Colors.white,

              fontSize: 16,

              fontWeight: FontWeight.w600,

            ),

          ),



        ],

      ),

    );

  }


}