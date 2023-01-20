import 'dart:math';

import 'package:drinkingapp/questionsManager/UserClass.dart';
import 'package:drinkingapp/questionsManager/questionsManager.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'Game.dart';

class GameModeSelection extends StatefulWidget {
  final List<UserClass> players;

  const GameModeSelection({super.key, required this.players});

  @override
  State<GameModeSelection> createState() => _GameModeSelectionState();
}

class _GameModeSelectionState extends State<GameModeSelection> {
  onPressedAction(int index) {
    setState(() {
      widget.players.removeAt(index);
    });
  }

  changePlayerPicture(UserClass player, String newPath) {
    setState(() {
      player.setPhotoPath(newPath);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<UserClass> players = widget.players;
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
                          PlayerView(
                              player: players[i],
                              onPressed: () {
                                onPressedAction(i);
                              },
                              changePhoto: changePlayerPicture),
                          PlayerView(
                              player: players[i + 1],
                              onPressed: () {
                                onPressedAction(i + 1);
                              },
                              changePhoto: changePlayerPicture)
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
                          PlayerView(
                              player: players[players.length - 1],
                              onPressed: () {
                                onPressedAction(players.length - 1);
                              },
                              changePhoto: changePlayerPicture),
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
          SizedBox(height: 20)
        ],
      )),
    );
  }
}

class PlayerView extends StatelessWidget {
  final UserClass player;
  final Function onPressed;
  final Function changePhoto;

  const PlayerView(
      {super.key,
      required this.player,
      required this.onPressed,
      required this.changePhoto});

  String getAvatar() {
    Random random = new Random();
    int randomNumber = random.nextInt(4) + 1;
    return 'images/avatar' + randomNumber.toString() + '.jpeg';
  }

  @override
  Widget build(BuildContext context) {
    if (player.photoPath == '') {
      player.setPhotoPath(getAvatar());
    }
    var width = MediaQuery.of(context).size.width * 0.43;
    return Container(
        width: width,
        height: width,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400, //New
              blurRadius: 10.0,
            )
          ],
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Stack(children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade800,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  iconSize: 18,
                  padding: EdgeInsets.all(2),
                  constraints: BoxConstraints(),
                  icon: Icon(Icons.close),
                  color: Colors.white,
                  onPressed: () {
                    onPressed();
                  },
                )),
          ),
          Center(
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            height: width * 0.55,
                            width: width * 0.55,
                            child: Stack(children: [
                              Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(player.photoPath),
                                    fit: BoxFit.fill,
                                  ),
                                  shape: BoxShape.circle,
                                  //border: Border.all(color: Colors.yellow.shade700, width: 3),
                                  color: Colors.yellow.shade700,
                                ),
                              ),
                              Container(
                                  height: width * 0.55,
                                  width: width * 0.55,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 3, color: Colors.white),
                                      boxShadow: [
                                        BoxShadow(
                                            spreadRadius: 2,
                                            blurRadius: 10,
                                            color:
                                                Colors.black.withOpacity(0.1))
                                      ],
                                      shape: BoxShape.circle,
                                      color: Colors.grey.withOpacity(0.5),
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.camera_alt_rounded,
                                          color: Colors.white.withOpacity(0.9)),
                                      iconSize: 26,
                                      onPressed: () {
                                        changePhoto(player, getAvatar());
                                      },
                                    ),
                                  )),
                              // Positioned(
                              //     bottom: 0,
                              //     right: 0,
                              //     child: GestureDetector(onTap: () {
                              //       changePhoto(player, getAvatar());
                              //     }, child: Container(
                              //       width: 30,
                              //       height: 30,
                              //       decoration: BoxDecoration(
                              //           shape: BoxShape.circle,
                              //           border: Border.all(
                              //               width: 2, color: Colors.white),
                              //           color: Colors.black),
                              //       child: Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16,),
                              //     )))
                            ])),
                        //SizedBox(height: 5),
                        Text(
                          player.username,
                          style: TextStyle(fontSize: 16),
                        )
                      ]))),
        ]));
  }
}
