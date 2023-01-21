import 'package:drinkingapp/questionsManager/UserClass.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class ChallangesWheel extends StatefulWidget {
  const ChallangesWheel({Key? key, required this.indexWinner})
      : super(key: key);

  final int indexWinner;

  @override
  _ChallangesWheelState createState() => _ChallangesWheelState( indexWinner);
}

class _ChallangesWheelState extends State<ChallangesWheel> {
  _ChallangesWheelState( this.indexWinner);

  List<String> challanges = [
    "All Drink",
    "Girls Drink",
    "Boys Drink",
    "Gods Drink"
  ];

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
               winner = challanges[indexWinner];
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
                            Icons.sports_bar,
                            color: Colors.yellow.shade700,
                          ), // <-- changing the color of the indicator
                        ),
                        SizedBox(height: width*0.025),
                      ]),
                    ),
                  ],
                  animateFirst: false,
                  selected: selected.stream,
                  items: [
                    for (var challange in challanges)
                      FortuneItem(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //SizedBox(height: 5),

                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                challange,
                                style: TextStyle(fontSize: 16),
                              ),

                            ]),
                        style: FortuneItemStyle(
                            color: (challanges.indexOf(challange) % 2 == 0)
                                ? Colors.blue
                                : Colors
                                .white, // <-- custom circle slice fill color
                            // <-- custom circle slice stroke color
                            borderWidth: 0.5,
                            textStyle: TextStyle(
                              color: (challanges.indexOf(challange) % 2 == 0)
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
