import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:drinkingapp/GameModeSelection.dart';
import 'package:drinkingapp/Question.dart';
import 'package:drinkingapp/questionsManager/FeedManager.dart';
import 'package:drinkingapp/questionsManager/TakePictureScreen.dart';
import 'package:drinkingapp/questionsManager/UserClass.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:drinkingapp/questionsManager/NamesWheel.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:flutter/material.dart';

import 'NamesWheel.dart';

class QuestionsManager {
  int index_mostLikely = 0;
  int index_challenges = 0;
  FeedManager feedManager = FeedManager();

  QuestionManager() async {
    mostLikelyQuestions.shuffle();
    challenges.shuffle();
  }

  List<Widget> getFeed() {
    return feedManager.getFeed();
  }

  final List<String> mostLikelyQuestions = [
    "Who is most likely to become a stripper?",
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

  final List<String> challenges = [
    "The best to imitate a dog wins."
  ];

  Question getWidgetForQuestion(List<UserClass> players, context) {
    var doubleValue = Random().nextDouble();
    if (doubleValue <= 0.1) {
      return getWheelOfNames(players);
    } else if (doubleValue <= 0.2) {
      //This question is the random words question
      // does not do basically nothing so I reduced the odd a lot
      return getNewQuestion(players);
    } else if (doubleValue <= 0.6) {
      return getMostLikelyTo(players);
    } else if (doubleValue <= 0.9) {
      return getPhotoQuestion(players, context);
    }

    return get1vs1(players);
  }

  void addPhotoToFeed(String photoPath, String player) {
    feedManager.addPhoto(photoPath, player);
  }
  int getRandomNumberOfGlasses(){
    return  Random().nextInt(4) + 1;
  }

   Question getPhotoQuestion(List<UserClass> players, context) {
    int player = Random().nextInt(players.length);

    return Question(type: 'Photo Time', widget: Column(
      children: [
        IconButton(
          icon: const Icon(Icons.photo_camera),
          color: Colors.black,
          onPressed: () async {
            WidgetsFlutterBinding.ensureInitialized();

            // Obtain a list of the available cameras on the device.
            final cameras = await availableCameras();

            // Get a specific camera from the list of available cameras.
            final firstCamera = cameras.first;

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TakePictureScreen(
                        camera: firstCamera,
                        questionsManager: this,
                        players: players,
                        player: players[player].username)));
          },
        ),
        Text('${players[player].username}'),
        SizedBox(height: 10),
        Text("IT IS PHOTO TIME!")
      ],
    ), nbrGlasses: getRandomNumberOfGlasses());
  }

  Question getNewQuestion(List<UserClass> players) {
    return Question(type: 'Normal Challenge', widget: Column(children: [
      Text(lorem(paragraphs: 1, words: 10), textAlign: TextAlign.center),
      SizedBox(height: 40),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[for (var player in players) Text(player.username)],
      )
    ]), nbrGlasses: getRandomNumberOfGlasses());
  }

  Question getWheelOfNames(List<UserClass> players) {
    Random random = new Random();
    int indexWinner = random.nextInt(players.length); // from 0 to 9 included
    feedManager.addNamesWheelPost(players[indexWinner].username);
    NamesWheel nm = new NamesWheel(players: players, indexWinner: indexWinner);
    //nm.createState().
    //_NamesWheelS
    return Question(type: 'Fortune Wheel', widget: nm, nbrGlasses: getRandomNumberOfGlasses());
  }

  Question getMostLikelyTo(List<UserClass> players) {
    if (index_mostLikely == mostLikelyQuestions.length) {
      mostLikelyQuestions.shuffle();
      index_mostLikely = 0;
    }
    var question = mostLikelyQuestions[index_mostLikely];
    index_mostLikely++;
    //feedManager.addMostLikelyToPost(question, "winner");
    return Question(type: 'Most Likely To',  widget: Column(
      children: [
        Text(question),
        for (var i = 0; i < players.length; i++)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent),
            onPressed: () {
              feedManager.addMostLikelyToPost(question, players[i].username);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 5),
                Text('${players[i].username}'),// <-- Text
              ],
            ),
          ),


      ],
    ), nbrGlasses: getRandomNumberOfGlasses());
  }

  Question get1vs1(List<UserClass> players) {
    int player1 = Random().nextInt(players.length);
    int player2;
    do {
      player2 = Random().nextInt(players.length);
    } while (player2 == player1);
    if (index_challenges >= challenges.length) {
      challenges.shuffle();
      index_challenges = 0;
    }
    print(index_challenges);
    print(challenges.length);
    var challenge = challenges[index_challenges];

    return Question(type: '1 vs 1', widget: Column(
      children: [
        Text(
          "${players[player1].username} vs ${players[player2].username}",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 40),
        Text('$challenge\nThe other players vote.', textAlign: TextAlign.center),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent),
              onPressed: () {
                index_challenges++;
                feedManager.addOneVsOnePost(challenge, players[player1].username,
                    players[player2].username, players[player1].username);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 5),
                  Text(players[player1].username),// <-- Text
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent),
              onPressed: () {
                index_challenges++;
                feedManager.addOneVsOnePost(challenge, players[player1].username,
                    players[player2].username, players[player2].username);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 5),
                  Text(players[player2].username),// <-- Text
                ],
              ),
            ),
          ],
        )
      ],
    ), nbrGlasses: getRandomNumberOfGlasses());
  }
}




class PlayerButton extends StatefulWidget { // immutable Widget
  final UserClass player;

  PlayerButton({required this.player});
  @override
  _MyWidgetState createState() => _MyWidgetState( player: player);
// creating State Object of MyWidget
}

class _MyWidgetState extends State<PlayerButton> { // State Object
  @override
  final UserClass player;

  _MyWidgetState({required this.player});


  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * 0.33;
    var buttonColor = Colors.white;

    return GestureDetector(
        onTap: () {
          print("clickou");
          setState(() {
            buttonColor = Colors.black;
          });
          }, // Image tapped
        child: Container(

            width: width,
            height: width,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400, //New
                  blurRadius: 10.0,
                )
              ],
            ),
            child: Container(
                decoration: BoxDecoration(
                  color: buttonColor,
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
                        Text(player.username, style: TextStyle(fontWeight: FontWeight.normal)),
                      ],
                    ))))
    );
  }
}