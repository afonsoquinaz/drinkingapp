import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class NamesWheel extends StatefulWidget {
  const NamesWheel({Key? key, required this.players, required this.indexWinner}) : super(key: key);
  final List<String> players;
  final int indexWinner;

  @override
  _NamesWheelState createState() => _NamesWheelState(players, indexWinner);
}

class _NamesWheelState extends State<NamesWheel> {
  _NamesWheelState(this.players, this.indexWinner);
  final List<String> players;
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
    return
      Expanded(
        child:
        Container(
          //color: Colors.red,
          //margin: const EdgeInsets.only(40.0),
          child: GestureDetector(
            onTap: () {
              setState(() {

                debugPrint("Selected Player: ${players[indexWinner]}");
                winner = players[indexWinner];
                selected.add(
                  indexWinner,
                );
              });
            },
            child: Column(
              children: [
                Expanded(
                  child: Container(margin: const EdgeInsets.symmetric(horizontal: 80.0),
            child:
                  FortuneWheel(
                    animateFirst: false,
                    selected: selected.stream,
                    items: [
                      for (var playerName in players) FortuneItem(child: Text(playerName)),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
      );
  }
}