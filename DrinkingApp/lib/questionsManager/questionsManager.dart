import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' as rootBundle;
import 'package:drinkingapp/questionsManager/NamesWheel.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:flutter/material.dart';
import 'NamesWheel.dart';

class QuestionsManager {
  int index = 0;

  QuestionManager(){
    mostLikelyQuestions.shuffle();
  }
  final List<String> mostLikelyQuestions = ["Who is most likely to become a stripper?",
    "Who is most likely to become engaged?",
    "Who is most likely to spend all their savings?",
    "Who is most likely to be a drama queen?",
    "Who is most likely to be the first one skinny dipping?",
    "Who is most likely to stay in on the weekends?",
    "Who is most likely to watch a scary movie?",
    "Who is most likely to have a one night stand",
    "Who is most likely to end up on a reality show?",
    "Who is most likely to be in a horror movie?",
    "Who is most likely to end up as a stand-up comedian?",
    "Who is most likely to develop a fear of spiders?",
    "Who is most likely to get kissed first?",
    "Who is most likely to get an STD?",
    "Who is most likely to fall down stairs?",
    "Who is most likely to get arrested for urinating outside?",
    "Who is most likely to listen to classical music?",
    "Who is most likely to win the lottery?",
    "Who is most likely to fall asleep during sex?",
    "Who is most likely to marry a rich man or woman?",
    "Who is most likely forget to wear underwear?",
    "Who is most likely to perform a sexual act while drunk?",
    "Who is most likely to kiss on a first date?",
    "Who is most likely to pick up a stranger at a bar?",
    "Who is most likely to fall for a friend?",
    "Who is most likely to puke and then kiss someone?",
    "Who is most likely to have sex with another person in the room?",
    "Who is most likely to marry their cousin?",
    "Who is most likely to participate in an orgy?",
    "Who is most likely to watch porn?"
  ];

  Widget getWidgetForQuestion(List<String> players){
    var doubleValue = Random().nextDouble();
    if (doubleValue <= 0.0001) {
      return getNewQuestion(players);
    } else if (doubleValue <= 0.0002){
      return getWheelOfNames(players);
    }
    return getMostLikelyTo(players);
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

  Widget getMostLikelyTo(List<String> players) {
    if (index == mostLikelyQuestions.length){
      mostLikelyQuestions.shuffle();
      index = 0;
    }
    var question = mostLikelyQuestions[index];
    index++;
    return Column(
      children: [
        Text(question)
      ],
    );
  }



}