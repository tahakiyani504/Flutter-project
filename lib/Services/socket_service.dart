import 'dart:io';
import 'package:flutter/foundation.dart';


class SocketService {


  static Socket? socket;


  static ValueNotifier<bool> connectionStatus =
  ValueNotifier<bool>(false);



  static Future<bool> connect(String ip, int port) async {

    try {


      socket = await Socket.connect(
        ip,
        port,
        timeout: const Duration(seconds: 5),
      );


      connectionStatus.value = true;


      print("Connected Successfully");


      return true;


    } catch(e) {


      print("Connection Error: $e");


      connectionStatus.value = false;


      return false;

    }

  }



  static bool get isConnected {

    return socket != null;

  }




  static void sendCommand(String command) {


    if(socket != null) {


      socket!.write(command);


      print("Command Sent: $command");


    }


  }




  static void disconnect() {


    socket?.close();


    socket = null;


    connectionStatus.value = false;


  }


}