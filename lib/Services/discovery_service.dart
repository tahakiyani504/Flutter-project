import 'dart:async';
import 'dart:convert';
import 'dart:io';


class DiscoveryService {


  static const int discoveryPort = 9999;


  static const String discoverMessage =
      "DISCOVER_PC_CONTROLLER";



  static Future<List<String>> findPCs() async {


    List<String> discoveredIPs = [];



    RawDatagramSocket socket =
    await RawDatagramSocket.bind(
      InternetAddress.anyIPv4,
      0,
    );



    socket.broadcastEnabled = true;



    try {


      socket.send(

        utf8.encode(discoverMessage),

        InternetAddress("255.255.255.255"),

        discoveryPort,

      );




      Completer<List<String>> completer =
      Completer<List<String>>();





      socket.listen((event) {


        if(event ==
            RawSocketEvent.read) {


          Datagram? datagram =
          socket.receive();



          if(datagram != null) {


            String message =
            utf8.decode(
              datagram.data,
            ).trim();



            if(message ==
                "PC_CONTROLLER_HERE") {


              String ip =
                  datagram.address.address;



              if(!discoveredIPs.contains(ip)) {

                discoveredIPs.add(ip);

              }


            }


          }


        }


      });





      Timer(

        const Duration(seconds:3),

            () {


          socket.close();



          if(!completer.isCompleted) {


            completer.complete(
                discoveredIPs
            );


          }


        },

      );




      return completer.future;



    }

    catch(e) {


      socket.close();


      return [];


    }


  }


}