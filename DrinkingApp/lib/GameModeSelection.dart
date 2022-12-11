import 'package:drinkingapp/questionsManager/questionsManager.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'Game.dart';
class GameModeSelection extends StatelessWidget {
  final List<String> players;
  const GameModeSelection({ super.key , required this.players});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffb0e3df),

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
              Column(
                children: [
                  for(var i = 0 ; i < players.length; i++)
                    Column(
                      children: [
                        Container(
                          width: 200,
                          height: 50,
                         // Change this to edit the container color
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.person),
                              SizedBox(height: 10),
                              Text("  " + players[i]), // Change this to the user's name
                            ],
                          ),
                        ),

                      ],
                    )
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
                    MaterialPageRoute(builder: (context) =>  Game(players: players, questionsManager: QuestionsManager(),)),
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