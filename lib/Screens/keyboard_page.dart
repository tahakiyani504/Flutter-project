import 'package:flutter/material.dart';
import '../services/socket_service.dart';


class KeyboardPage extends StatefulWidget {

  const KeyboardPage({super.key});


  @override
  State<KeyboardPage> createState() =>
      _KeyboardPageState();

}



class _KeyboardPageState extends State<KeyboardPage> {



  String lastKey = "None";



  void sendKey(String key) {


    setState(() {

      lastKey = key;

    });



    SocketService.sendCommand(

      '{"type":"KEY_PRESS","key":"$key"}',

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


        LayoutBuilder(


          builder:(context,constraints){



            return SingleChildScrollView(



              child:


              Padding(


                padding:
                const EdgeInsets.all(16),



                child:


                Column(


                  children:[



                    Row(


                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,


                      children:[



                        const Text(

                          "Remote Keyboard",

                          style:

                          TextStyle(

                            color:
                            Colors.white,

                            fontSize:26,

                            fontWeight:
                            FontWeight.bold,

                          ),

                        ),





                        Container(

                          padding:

                          const EdgeInsets.symmetric(

                            horizontal:12,

                            vertical:7,

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

                              fontSize:13,

                            ),

                          ),



                        ),



                      ],



                    ),





                    const SizedBox(height:15),





                    Container(


                      width:
                      double.infinity,



                      padding:
                      const EdgeInsets.all(12),



                      decoration:

                      BoxDecoration(

                        color:
                        Colors.white.withOpacity(.06),


                        borderRadius:
                        BorderRadius.circular(18),


                        border:

                        Border.all(

                          color:
                          Colors.blueAccent.withOpacity(.3),

                        ),

                      ),



                      child:

                      Text(

                        "Last Key : $lastKey",

                        textAlign:
                        TextAlign.center,


                        style:

                        const TextStyle(

                          color:
                          Colors.white70,

                        ),

                      ),


                    ),





                    const SizedBox(height:20),





                    Container(


                      padding:
                      const EdgeInsets.all(18),



                      decoration:

                      BoxDecoration(

                        color:
                        Colors.white.withOpacity(.05),


                        borderRadius:
                        BorderRadius.circular(28),


                        border:

                        Border.all(

                          color:
                          Colors.blueAccent.withOpacity(.35),

                          width:1.5,

                        ),


                        boxShadow:[


                          BoxShadow(

                            color:
                            Colors.blueAccent.withOpacity(.15),

                            blurRadius:30,

                          )

                        ],



                      ),




                      child:


                      Column(



                        children:[




                          _keyboardRow([

                            "1","2","3","4","5",

                            "6","7","8","9","0",

                            "BACKSPACE"

                          ]),




                          const SizedBox(height:10),





                          _keyboardRow([

                            "TAB",

                            "Q","W","E","R","T",

                            "Y","U","I","O","P"

                          ]),




                          const SizedBox(height:10),





                          _keyboardRow([


                            "CAPS",

                            "A","S","D","F","G",

                            "H","J","K","L",

                            "ENTER"


                          ]),





                          const SizedBox(height:10),





                          _keyboardRow([


                            "SHIFT",

                            "Z","X","C","V",

                            "B","N","M",

                            "SHIFT"


                          ]),






                          const SizedBox(height:10),





                          Row(


                            mainAxisAlignment:
                            MainAxisAlignment.center,


                            children:[



                              _smallKey("CTRL"),



                              _smallKey("ALT"),



                              Expanded(

                                child:

                                _spaceKey(),

                              ),



                              _smallKey("ALT"),



                              _smallKey("WIN"),



                            ],


                          ),



                        ],



                      ),



                    ),





                    const SizedBox(height:25),






                    const Text(

                      "Navigation",

                      style:

                      TextStyle(

                        color:
                        Colors.white,

                        fontSize:18,

                        fontWeight:
                        FontWeight.bold,

                      ),

                    ),




                    const SizedBox(height:12),





                    Column(


                      children:[



                        _arrowKey("↑"),



                        Row(


                          mainAxisAlignment:
                          MainAxisAlignment.center,


                          children:[



                            _arrowKey("←"),



                            _arrowKey("↓"),



                            _arrowKey("→"),



                          ],


                        ),



                      ],


                    ),




                  ],

                ),

              ),



            );


          },


        ),


      ),


    );


  }








  Widget _keyboardRow(List<String> keys){


    return Row(


      mainAxisAlignment:
      MainAxisAlignment.center,


      children:


      keys.map((key){


        return Flexible(


          child:


          Padding(


            padding:
            const EdgeInsets.all(3),



            child:

            _keyButton(key),


          ),


        );


      }).toList(),



    );


  }







  Widget _keyButton(String key){


    return GestureDetector(


      onTap:

          (){


        sendKey(key);


      },



      child:


      AnimatedContainer(


        duration:
        const Duration(milliseconds:120),



        height:45,



        decoration:

        BoxDecoration(


          gradient:

          const LinearGradient(

            colors:[

              Color(0xff123B72),

              Color(0xff081B36),

            ],

          ),



          borderRadius:
          BorderRadius.circular(10),



          border:

          Border.all(

            color:
            Colors.blueAccent.withOpacity(.4),

          ),


        ),




        child:


        Center(


          child:


          FittedBox(


            child:


            Text(

              key,


              style:

              const TextStyle(

                color:
                Colors.white,

                fontSize:11,

                fontWeight:
                FontWeight.bold,

              ),


            ),


          ),


        ),



      ),



    );


  }







  Widget _smallKey(String text){


    return Padding(

      padding:
      const EdgeInsets.all(3),


      child:

      SizedBox(

        width:55,

        child:

        _keyButton(text),


      ),


    );


  }







  Widget _spaceKey(){


    return GestureDetector(


      onTap:

          (){


        sendKey("SPACE");


      },



      child:


      Container(


        height:45,


        decoration:

        BoxDecoration(

          gradient:

          const LinearGradient(

            colors:[

              Color(0xff123B72),

              Color(0xff081B36),

            ],

          ),


          borderRadius:
          BorderRadius.circular(10),



          border:

          Border.all(

            color:
            Colors.blueAccent.withOpacity(.4),

          ),


        ),



        child:

        const Center(

          child:

          Text(

            "SPACE",

            style:

            TextStyle(

              color:
              Colors.white,

              fontSize:11,

              fontWeight:
              FontWeight.bold,

            ),

          ),

        ),



      ),



    );


  }







  Widget _arrowKey(String key){


    return Padding(


      padding:
      const EdgeInsets.all(5),


      child:

      SizedBox(

        width:55,

        height:45,


        child:

        _keyButton(key),


      ),


    );


  }



}