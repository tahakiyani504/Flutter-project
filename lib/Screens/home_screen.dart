import 'package:flutter/material.dart';

import 'home_page.dart';
import 'mouse_page.dart';
import 'keyboard_page.dart';
import 'media_page.dart';
import 'power_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int currentIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    MousePage(),
    KeyboardPage(),
    MediaPage(),
    PowerPage(),
  ];


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: pages[currentIndex],

      bottomNavigationBar: NavigationBar(

        selectedIndex: currentIndex,

        destinations: const [

          NavigationDestination(
            icon: Icon(Icons.home),
            label: "Home",
          ),

          NavigationDestination(
            icon: Icon(Icons.mouse),
            label: "Mouse",
          ),

          NavigationDestination(
            icon: Icon(Icons.keyboard),
            label: "Keyboard",
          ),

          NavigationDestination(
            icon: Icon(Icons.music_note),
            label: "Media",
          ),

          NavigationDestination(
            icon: Icon(Icons.power_settings_new),
            label: "Power",
          ),

        ],

        onDestinationSelected: (index){

          setState(() {

            currentIndex=index;

          });

        },

      ),

    );

  }

}