import 'package:drinkingapp/questionsManager/UserClass.dart';
import 'package:drinkingapp/questionsManager/questionsManager.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'Game.dart';

class GameModeSelection extends StatelessWidget {
  final List<String> players;
  const GameModeSelection({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    bool odd = ((players.length % 2) == 0);

    return Scaffold(
      backgroundColor: Color(0xffb0e3df),
      body: Center(
          child: Column(
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
          SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(width: MediaQuery.of(context).size.width * 0.14 / 3),
            Text(" ${players.length} players",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
          ]),
          SizedBox(height: 40),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (var i = 0;
                      (odd && i < players.length) ||
                          (!odd && i < players.length - 1);
                      i = i + 2)
                    Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          PlayerView(username: players[i]),
                          PlayerView(username: players[i + 1])
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.14 / 3,
                      )
                    ]),
                  if (!odd)
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          PlayerView(username: players[players.length - 1]),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.43,
                          )
                        ]),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => Game(
                          players: players,
                          questionsManager: QuestionsManager(),
                        )),
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
      )),
    );
  }
}

class PlayerView extends StatelessWidget {
  final String username;

  const PlayerView({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * 0.43;
    return Container(
        width: width,
        height: width,
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: width * 0.55,
                      height: width * 0.55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.red,
                      ),
                    ),
                    Text(username),
                  ],
                ))));
  }
}
