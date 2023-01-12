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
                              Text(players[i]), // Change this to the user's name
                            ],
                          ),
                        ),

                      ],
                    )
                ],
              ),
              SizedBox(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black),
                onPressed: () {

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) =>  Game(players: players, questionsManager: QuestionsManager(),)),
                        (Route<dynamic> route) => false,
                  );

                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 5),
                    Text('PLAY'), // <-- Text
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      // <-- Icon
                      Icons.navigate_next_outlined,
                      size: 24.0,
                    ),
                  ],
                ),
              ),





            ],
          )

      ),
    );
  }
}