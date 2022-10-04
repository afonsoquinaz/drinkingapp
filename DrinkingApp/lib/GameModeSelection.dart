import 'package:flutter/material.dart';
import 'main.dart';
import 'Game.dart';
class GameModeSelection extends StatelessWidget {
  final String Players;
  const GameModeSelection({ super.key , required this.Players});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,

      body: Center(
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const MyApp()),
                            (Route<dynamic> route) => false,
                      );
                    },
                  ),
                ],
              ),

              SizedBox(),
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) =>  Game(Players: Players)),
                        (Route<dynamic> route) => false,
                  );

                },
                child: const Text('Normal SinglePlayer',style: TextStyle(fontSize: 25, color: Colors.yellow)),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {},
                child: const Text('Multiplayer',style: TextStyle(fontSize: 25, color: Colors.yellow)),
              ),
              SizedBox(),
              SizedBox(),


            ],
          )

      ),
    );
  }
}