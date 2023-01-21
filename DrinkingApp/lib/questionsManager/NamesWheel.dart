import 'package:drinkingapp/questionsManager/UserClass.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class NamesWheel extends StatefulWidget {
  const NamesWheel({Key? key, required this.players, required this.indexWinner})
      : super(key: key);
  final List<UserClass> players;
  final int indexWinner;

  @override
  _NamesWheelState createState() => _NamesWheelState(players, indexWinner);
}

class _NamesWheelState extends State<NamesWheel> {
  _NamesWheelState(this.players, this.indexWinner);
  final List<UserClass> players;
  final int indexWinner;
  String winner = "";
  StreamController<int> selected = StreamController<int>();

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * 0.7;
    return Container(
      //color: Colors.red,
      //margin: const EdgeInsets.only(40.0),
        child: GestureDetector(
          onTap: () {
            setState(() {
              debugPrint("Selected Player: ${players[indexWinner]}");
              winner = players[indexWinner].username;
              selected.add(
                indexWinner,
              );
            });
          },
          child: Column(
            children: [
              Container(
                width: width,
                height: width,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 10,
                          blurRadius: 10,
                          color: Colors.yellow.withOpacity(0.5))
                    ],
                    border: Border.all(color: Colors.yellow.shade700, width: 6)),
                child: FortuneWheel(
                  indicators: <FortuneIndicator>[
                    FortuneIndicator(
                      alignment: Alignment
                          .center, // <-- changing the position of the indicator
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Container(
                            width: width * 0.025,
                            height: width * 0.025,
                            child: RotatedBox(
                                quarterTurns: -2,
                                child: TriangleIndicator(color: Colors.black))),
                        Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          child: Icon(
                            Icons.no_drinks,
                            color: Colors.white,
                          ), // <-- changing the color of the indicator
                        ),
                        SizedBox(height: width*0.025),
                      ]),
                    ),
                  ],
                  animateFirst: false,
                  selected: selected.stream,
                  items: [
                    for (var player in players)
                      FortuneItem(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //SizedBox(height: 5),

                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                player.username,
                                style: TextStyle(fontSize: 16),
                              ),
                              Container(
                                  width: 45,
                                  height: 45,
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
                                  ])),
                            ]),
                        style: FortuneItemStyle(
                            color: (players.indexOf(player) % 2 == 0)
                                ? Colors.red
                                : Colors
                                .white, // <-- custom circle slice fill color
                            // <-- custom circle slice stroke color
                            borderWidth: 0.5,
                            textStyle: TextStyle(
                              color: (players.indexOf(player) % 2 == 0)
                                  ? Colors.white
                                  : Colors.black,
                            ) // <-- custom circle slice stroke width
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
