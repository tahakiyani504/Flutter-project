import 'package:flutter/material.dart';
import '../services/socket_service.dart';

class MediaPage extends StatefulWidget {
  const MediaPage({super.key});

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage>
    with SingleTickerProviderStateMixin {

  double volume = 50;
  bool isPlaying = false;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;


  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 1.08,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  void sendCommand(String command) {
    SocketService.sendCommand(command);
  }


  void togglePlay() {

    setState(() {
      isPlaying = !isPlaying;
    });

    _controller.forward().then(
          (_) => _controller.reverse(),
    );

    sendCommand("MEDIA_PLAY_PAUSE");
  }


  void increaseVolume() {

    setState(() {

      volume += 5;

      if (volume > 100) {
        volume = 100;
      }

    });

    sendCommand("VOLUME_UP");
  }


  void decreaseVolume() {

    setState(() {

      volume -= 5;

      if (volume < 0) {
        volume = 0;
      }

    });

    sendCommand("VOLUME_DOWN");
  }



  Widget glassCard({
    required Widget child,
    double padding = 20,
  }) {

    return Container(

      padding: EdgeInsets.all(padding),

      decoration: BoxDecoration(

        color: Colors.white.withOpacity(0.06),

        borderRadius: BorderRadius.circular(28),

        border: Border.all(
          color: Colors.blueAccent.withOpacity(0.25),
          width: 1,
        ),

        boxShadow: [

          BoxShadow(

            color: Colors.blueAccent.withOpacity(0.15),

            blurRadius: 30,

            spreadRadius: 2,

          )

        ],

      ),

      child: child,

    );
  }



  Widget controlButton({

    required IconData icon,

    required VoidCallback onTap,

    Color color = Colors.white,

    double size = 60,

  }) {

    return InkWell(

      borderRadius: BorderRadius.circular(20),

      onTap: onTap,

      child: Container(

        height: size,

        width: size,

        decoration: BoxDecoration(

          color: Colors.white.withOpacity(0.08),

          borderRadius: BorderRadius.circular(20),

          border: Border.all(

            color: Colors.blueAccent.withOpacity(0.25),

          ),

        ),

        child: Icon(

          icon,

          color: color,

          size: size * 0.45,

        ),

      ),

    );
  }



  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;


    return Scaffold(

      backgroundColor: const Color(0xff07111f),


      body: SafeArea(

        child: Center(

          child: SingleChildScrollView(

            physics: const BouncingScrollPhysics(),

            padding: const EdgeInsets.all(20),


            child: ConstrainedBox(

              constraints: const BoxConstraints(

                maxWidth: 520,

              ),


              child: Column(

                mainAxisAlignment: MainAxisAlignment.center,

                children: [



                  Row(

                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [

                      const Icon(

                        Icons.music_note_rounded,

                        color: Colors.blueAccent,

                        size: 34,

                      ),

                      const SizedBox(width: 10),


                      Text(

                        "Media Controller",

                        style: Theme.of(context)

                            .textTheme

                            .headlineSmall

                            ?.copyWith(

                          color: Colors.white,

                          fontWeight: FontWeight.bold,

                          letterSpacing: 0.5,

                        ),

                      ),

                    ],

                  ),



                  const SizedBox(height: 30),



                  glassCard(

                    padding: 25,

                    child: Column(

                      children: [


                        ScaleTransition(

                          scale: _scaleAnimation,

                          child: GestureDetector(

                            onTap: togglePlay,

                            child: Container(

                              height: 110,

                              width: 110,

                              decoration: BoxDecoration(

                                shape: BoxShape.circle,

                                gradient: const LinearGradient(

                                  colors: [

                                    Color(0xff007BFF),

                                    Color(0xff00C6FF),

                                  ],

                                ),

                                boxShadow: [

                                  BoxShadow(

                                    color: Colors.blueAccent
                                        .withOpacity(0.45),

                                    blurRadius: 35,

                                    spreadRadius: 5,

                                  )

                                ],

                              ),

                              child: Icon(

                                isPlaying

                                    ? Icons.pause_rounded

                                    : Icons.play_arrow_rounded,

                                size: 60,

                                color: Colors.white,

                              ),

                            ),

                          ),

                        ),



                        const SizedBox(height: 35),



                        Row(

                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,

                          children: [


                            controlButton(

                              icon: Icons.skip_previous_rounded,

                              onTap: () {

                                sendCommand("MEDIA_PREV");

                              },

                            ),



                            controlButton(

                              icon: Icons.stop_rounded,

                              color: Colors.redAccent,

                              onTap: () {

                                sendCommand("MEDIA_STOP");

                                setState(() {

                                  isPlaying = false;

                                });

                              },

                            ),



                            controlButton(

                              icon: Icons.skip_next_rounded,

                              onTap: () {

                                sendCommand("MEDIA_NEXT");

                              },

                            ),


                          ],

                        ),

                      ],

                    ),

                  ),




                  const SizedBox(height: 25),




                  glassCard(

                    padding: 25,

                    child: Column(

                      children: [


                        Row(

                          mainAxisAlignment:
                          MainAxisAlignment.center,

                          children: [


                            const Icon(

                              Icons.volume_up_rounded,

                              color: Colors.blueAccent,

                            ),


                            const SizedBox(width: 10),


                            Text(

                              "${volume.round()}%",

                              style: const TextStyle(

                                color: Colors.white,

                                fontSize: 20,

                                fontWeight: FontWeight.bold,

                              ),

                            ),


                          ],

                        ),



                        const SizedBox(height: 15),



                        SliderTheme(

                          data: SliderTheme.of(context).copyWith(

                            trackHeight: 8,

                            thumbShape:
                            const RoundSliderThumbShape(

                              enabledThumbRadius: 10,

                            ),

                          ),

                          child: Slider(

                            value: volume,

                            min: 0,

                            max: 100,

                            activeColor: Colors.blueAccent,

                            inactiveColor:
                            Colors.white.withOpacity(0.15),

                            onChanged: (value) {

                              setState(() {

                                volume = value;

                              });

                            },

                          ),

                        ),



                        const SizedBox(height: 20),



                        Row(

                          mainAxisAlignment:
                          MainAxisAlignment.center,

                          children: [


                            Expanded(

                              child: ElevatedButton.icon(

                                style:
                                ElevatedButton.styleFrom(

                                  backgroundColor:
                                  Colors.white.withOpacity(0.08),

                                  foregroundColor:
                                  Colors.white,

                                  padding:
                                  const EdgeInsets.symmetric(

                                    vertical: 15,

                                  ),

                                  shape:
                                  RoundedRectangleBorder(

                                    borderRadius:
                                    BorderRadius.circular(18),

                                  ),

                                ),

                                onPressed: decreaseVolume,

                                icon: const Icon(
                                  Icons.volume_down_rounded,
                                ),

                                label: const Text(
                                  "Volume -",
                                ),

                              ),

                            ),



                            const SizedBox(width: 15),



                            Expanded(

                              child: ElevatedButton.icon(

                                style:
                                ElevatedButton.styleFrom(

                                  backgroundColor:
                                  Colors.blueAccent,

                                  foregroundColor:
                                  Colors.white,

                                  padding:
                                  const EdgeInsets.symmetric(

                                    vertical: 15,

                                  ),

                                  shape:
                                  RoundedRectangleBorder(

                                    borderRadius:
                                    BorderRadius.circular(18),

                                  ),

                                ),

                                onPressed: increaseVolume,

                                icon: const Icon(
                                  Icons.volume_up_rounded,
                                ),

                                label: const Text(
                                  "Volume +",
                                ),

                              ),

                            ),


                          ],

                        ),

                      ],

                    ),

                  ),


                  SizedBox(

                    height: size.height * 0.03,

                  ),


                ],

              ),

            ),

          ),

        ),

      ),

    );

  }

}