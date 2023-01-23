import 'dart:io';

import 'package:drag_and_drop_lists/drag_and_drop_item.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list.dart';
import 'package:drinkingapp/questionsManager/UserClass.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class RouletteWheel extends StatefulWidget {
  const RouletteWheel({Key? key, required this.indexWinner})
      : super(key: key);

  final int indexWinner;

  @override
  _RouletteWheelState createState() => _RouletteWheelState(indexWinner);
}

class _RouletteWheelState extends State<RouletteWheel> {
  _RouletteWheelState( this.indexWinner);
  final int indexWinner;
  final List<int> numbers = [0,32,15,19,4,21,2,25,17,34,6,27,13,36,11,30,8,23,10,5,24,16,33,1,20,14,31,9,22,18,29,7,28,12,35,3,26];
  String winner = "";
  StreamController<int> selected = StreamController<int>();


  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * 0.8;
    return Column(
      children: [
        Container(
          //color: Colors.red,
          //margin: const EdgeInsets.only(40.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  //debugPrint("Selected Player: ${players[indexWinner]}");
                  winner = numbers[indexWinner].toString();
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
                        for (var number in numbers)
                          FortuneItem(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  //SizedBox(height: 5),

                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    number.toString(),
                                    style: TextStyle(fontSize: 16),
                                  ),

                                ]),
                            style: FortuneItemStyle(
                                color:(numbers.indexOf(number) == 0) ? Colors.green : (numbers.indexOf(number) % 2 == 0)
                                    ? Colors.black
                                    : Colors
                                    .red, // <-- custom circle slice fill color
                                // <-- custom circle slice stroke color
                                borderWidth: 0.5,
                                textStyle: TextStyle(
                                  color: (numbers.indexOf(number) % 2 == 0)
                                      ? Colors.white
                                      : Colors.white,
                                ) // <-- custom circle slice stroke width
                            ),
                          ),
                      ],
                    ),
                  ),


                ],
              ),
            ))
      ],
    );


  }



}

