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
import 'package:group_button/group_button.dart';

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

  final List<String> challenges = ["The best to imitate a dog wins."];

  Question getWidgetForQuestion(List<UserClass> players, context) {
    var doubleValue = Random().nextDouble();
    if (doubleValue <= 0.1) {
      return getWheelOfNames(players);
    } else if (doubleValue <= 0.2) {
      //This question is the random words question
      // does not do basically nothing so I reduced the odd a lot
      return getNewQuestion(players);
    } else if (doubleValue <= 0.8) {
      return getMostLikelyTo(players);
    } else if (doubleValue <= 0.81) {
      return getPhotoQuestion(players, context);
    }
    return get1vs1(players);
  }

  void addPhotoToFeed(String photoPath, UserClass player) {
    feedManager.addPhoto(photoPath, player);
  }

  int getRandomNumberOfGlasses() {
    return Random().nextInt(4) + 1;
  }

  Question getPhotoQuestion(List<UserClass> players, context) {
    int player = Random().nextInt(players.length);

    return Question(
        type: 'Photo Time',
        widget: Column(
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
                            player: players[player])));
              },
            ),
            Text('${players[player].username}'),
            SizedBox(height: 10),
            Text("IT IS PHOTO TIME!")
          ],
        ),
        nbrGlasses: getRandomNumberOfGlasses());
  }

  Question getNewQuestion(List<UserClass> players) {
    GroupButton buttons = GroupButton(players: players, selected: List<bool>.filled(players.length, false));
    return Question(
        type: 'Normal Challenge',
        widget: Column(children: [
          Text(lorem(paragraphs: 1, words: 10), textAlign: TextAlign.center),
          SizedBox(height: 40),
          buttons,
        ]),
        nbrGlasses: getRandomNumberOfGlasses(),
    );
  }

  Question getWheelOfNames(List<UserClass> players) {
    Random random = new Random();
    int indexWinner = random.nextInt(players.length); // from 0 to 9 included
    feedManager.addNamesWheelPost(players[indexWinner]);
    NamesWheel nm = new NamesWheel(players: players, indexWinner: indexWinner);
    //nm.createState().
    //_NamesWheelS
    return Question(
        type: 'Fortune Wheel',
        widget: nm,
        nbrGlasses: getRandomNumberOfGlasses());
  }

  Question getMostLikelyTo(List<UserClass> players) {
    if (index_mostLikely == mostLikelyQuestions.length) {
      mostLikelyQuestions.shuffle();
      index_mostLikely = 0;
    }
    var question = mostLikelyQuestions[index_mostLikely];
    index_mostLikely++;
    //feedManager.addMostLikelyToPost(question, "winner");
    GroupButton buttons = GroupButton(players: players, selected: List<bool>.filled(players.length, false));
    return Question(
        type: 'Most Likely To',
        widget: Column(
          children: [
            Text(question),
            SizedBox(height: 50),
            buttons,
          ],
        ),
        complete: () {
          for(int i=0; i<players.length; i++) {
            if (buttons.selected[i]) {
              feedManager.addMostLikelyToPost(question, players[i]);
            }
          }
        },
        nbrGlasses: getRandomNumberOfGlasses());
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
    UserClass? winner;
    ToggleButton buttons = ToggleButton(players: [players[player1], players[player2]], changeWinner: (player) {winner=player;});
    return Question(
        type: '1 vs 1',
        widget: Column(
          children: [
            Text(
              "${players[player1].username} vs ${players[player2].username}",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 40),
            Text('$challenge\nThe other players vote.',
                textAlign: TextAlign.center),
            SizedBox(height: 50),
            buttons
          ],
        ),
        complete: () {
          if (winner!=null) {
              feedManager.addOneVsOnePost(challenge, players[player1], players[player2], winner!.username);
            }
          },
        nbrGlasses: getRandomNumberOfGlasses());
  }
}

class ToggleButton extends StatefulWidget {
  final List<UserClass> players;
  final Function changeWinner;

  ToggleButton({super.key, required this.players, required this.changeWinner});

  @override
  State<StatefulWidget> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  UserClass? selected;

  toggle(UserClass player){
    setState(() {
      selected = player;
      widget.changeWinner(player);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 5, runSpacing: 5, alignment: WrapAlignment.center, children: [
      for (var i = 0; i < widget.players.length; i++)
        PlayerButton(player: widget.players[i], isSelected: () {return selected == widget.players[i];}, toggleFunc: toggle)
    ]);
  }
}

class GroupButton extends StatefulWidget {
  final List<UserClass> players;
  final List<bool> selected;

  toggle(UserClass player){
    selected[players.indexOf(player)] = !selected[players.indexOf(player)];
  }

  const GroupButton({super.key, required this.players, required this.selected});


  @override
  State<StatefulWidget> createState() => _GroupButtonState();
}

class _GroupButtonState extends State<GroupButton> {

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 5, runSpacing: 5, alignment: WrapAlignment.center, children: [
      for (var i = 0; i < widget.players.length; i++)
        PlayerButton(player: widget.players[i], isSelected: (){ return widget.selected[i]; }, toggleFunc: widget.toggle)
    ]);
    // return Container(height: 75, child: ListView(scrollDirection: Axis.horizontal, children: [
    //   for (var i = 0; i < widget.players.length; i++)
    //     Row(children: [
    //       PlayerButton(player: widget.players[i], selected: widget.selected, index: i,),
    //       SizedBox(width: 10)])
    // ]));
  }
}


class PlayerButton extends StatefulWidget {
  // immutable Widget
  final UserClass player;
  final Function isSelected;
  final Function toggleFunc;

  PlayerButton({required this.player, required this.isSelected, required this.toggleFunc});
  @override
  _MyWidgetState createState() => _MyWidgetState();
// creating State Object of MyWidget
}

class _MyWidgetState extends State<PlayerButton> {
  // State Object

  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            widget.toggleFunc(widget.player);
          });
        }, // Image tapped
        child: Container(
            width: 75,
            height: 75,
            child: Container(
                decoration: BoxDecoration(
                  color: widget.isSelected() ? Colors.deepOrangeAccent : Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(widget.player.photoPath),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Text(widget.player.username,
                            style: TextStyle(fontWeight: widget.isSelected() ? FontWeight.bold : FontWeight.normal, color: widget.isSelected() ? Colors.white : Colors.black)),
                      ],
                    )))));
  }
}