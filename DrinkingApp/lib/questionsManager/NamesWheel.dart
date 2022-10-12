import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class NamesWheel extends StatefulWidget {
  const NamesWheel({Key? key, required this.players}) : super(key: key);
  final List<String> players;

  @override
  _NamesWheelState createState() => _NamesWheelState(players);
}

class _NamesWheelState extends State<NamesWheel> {
  _NamesWheelState(this.players);
  final List<String> players;

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
          margin: const EdgeInsets.all(40.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                var number = Fortune.randomInt(0, players.length);
                debugPrint("Selected Player: ${players[number]}");
                selected.add(
                  number,
                );
              });
            },
            child: Column(
              children: [
                Expanded(
                  child: FortuneWheel(
                    animateFirst: false,
                    selected: selected.stream,
                    items: [
                      for (var playerName in players) FortuneItem(child: Text(playerName)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}