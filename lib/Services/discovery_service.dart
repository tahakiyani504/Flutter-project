import 'dart:async';
import 'dart:io';
import 'dart:convert';

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


    InternetAddress broadcastAddress =
    InternetAddress("255.255.255.255");


    try {

      socket.send(
        utf8.encode(discoverMessage),
        broadcastAddress,
        discoveryPort,
      );


      Completer<List<String>> completer =
      Completer<List<String>>();


      Timer(
        const Duration(seconds: 3),
            () {

          socket.close();

          if (!completer.isCompleted) {
            completer.complete(discoveredIPs);
          }

        },
      );


      socket.listen(
            (RawSocketEvent event) {

          if (event ==
              RawSocketEvent.read) {


            Datagram? datagram =
            socket.receive();


            if (datagram != null) {


              String message =
              utf8.decode(
                datagram.data,
              ).trim();



              if (message ==
                  "PC_CONTROLLER_HERE") {


                String ip =
                    datagram.address.address;



                if (!discoveredIPs.contains(ip)) {

                  discoveredIPs.add(ip);

                }


              }


            }


          }

        },
      );



      return discoveredIPs;



    } catch (e) {

      socket.close();

      return [];

    }


  }


}