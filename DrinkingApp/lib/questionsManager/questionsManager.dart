import 'dart:async';
import 'dart:math';
import 'package:drinkingapp/questionsManager/NamesWheel.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:flutter/material.dart';
import 'NamesWheel.dart';
class QuestionsManager {

  Widget getWidgetForQuestion(List<String> players){
    var doubleValue = Random().nextDouble();
    if (doubleValue <= 0.7) {
      return getNewQuestion(players);
    }
    return getWheelOfNames(players);
  }

  Column getNewQuestion(List<String> players){
    return
    Column(
      children: [
        Text(lorem(paragraphs: 1, words: 10)),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for(var playerName in players) Text(playerName)
          ],
        )
      ]
    );
  }

  NamesWheel getWheelOfNames(List<String> players){
    return NamesWheel(players: players);
  }



}