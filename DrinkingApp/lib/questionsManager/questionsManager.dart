import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' as rootBundle;
import 'package:drinkingapp/questionsManager/NamesWheel.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:flutter/material.dart';
import 'NamesWheel.dart';

class QuestionsManager {
  int index_mostLikely = 0;
  int index_challenges = 0;

  QuestionManager(){
    mostLikelyQuestions.shuffle();
    challenges.shuffle();
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

  final List<String> challenges = ["The best to imitate a dog wins.\nThe other players vote."];

  Widget getWidgetForQuestion(List<String> players){
    var doubleValue = Random().nextDouble();
    if (doubleValue <= 0.1) {
      return getWheelOfNames(players);
    } else if (doubleValue <= 0.45){
      return getNewQuestion(players);
    } else if (doubleValue <= 0.8){
      return getMostLikelyTo(players);
    }
    return get1vs1(players);
  }

  Column getNewQuestion(List<String> players){
    return
    Column(
      children: [
        Text(lorem(paragraphs: 1, words: 10), textAlign: TextAlign.center),
        SizedBox(height: 40),
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
    if (index_mostLikely == mostLikelyQuestions.length){
      mostLikelyQuestions.shuffle();
      index_mostLikely = 0;
    }
    var question = mostLikelyQuestions[index_mostLikely];
    index_mostLikely++;
    return Column(
      children: [
        Text(question)
      ],
    );
  }

  Widget get1vs1(List<String> players){
    int player1 = Random().nextInt(players.length);
    int player2;
    do {
      player2 = Random().nextInt(players.length);
    } while (player2 == player1);
    if (index_challenges == challenges.length){
      challenges.shuffle();
      index_challenges = 0;
    }
    var challenge = challenges[index_challenges];
    index_challenges++;
    return Column(
      children: [
        Text("${players[player1]} vs ${players[player2]}", textAlign:TextAlign.center, style: TextStyle(fontSize: 20),),
        const SizedBox( height: 40),
        Text(challenge, textAlign:TextAlign.center)
      ],
    );
  }



}