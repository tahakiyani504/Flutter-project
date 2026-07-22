import 'package:flutter/material.dart';

import 'screens/ip_connect_page.dart';
import 'screens/home_screen.dart';


void main() {

  runApp(
      const PCControllerApp()
  );

}



class PCControllerApp extends StatelessWidget {

  const PCControllerApp({super.key});


  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'PC Controller',


      theme: ThemeData(
        useMaterial3: true,
      ),


      initialRoute: "/connect",


      routes: {


        "/connect": (context) =>
        const IPConnectPage(),


        "/home": (context) =>
        const HomeScreen(),


      },

    );

  }

}