import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:drinkingapp/Constants/ColorPalette.dart';
import 'package:drinkingapp/GameModeSelection.dart';
import 'package:drinkingapp/Question.dart';
import 'package:drinkingapp/questionsManager/ChallangesWheel.dart';
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

  final List<String> photoQuestions = [
    "Take a photo holding the most random Item of the house!",
    "Take a photo giving a Toast!",
    "Take a photo as one of you is going to jail!",
    "Take a photo as two of you are going to have your first professional MMA fight !"
  ];
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
  late Question currentQuestion ;
  Question getCurrentQuestion(){
    return currentQuestion = Question(type: "first", widget: Container(), nbrGlasses: 0);
  }
  Question getWidgetForQuestion(List<UserClass> players, context) {
    var doubleValue = Random().nextDouble();
    if (doubleValue <= 0.2) {
      this.currentQuestion = getWheelOfNames(players);
      return currentQuestion;
    } else if (doubleValue <= 0.3) {
      //This question is the random words question
      // does not do basically nothing so I reduced the odd a lot
      this.currentQuestion = getNewQuestion(players);
      return currentQuestion;
    } else if (doubleValue <= 0.6) {
      this.currentQuestion = getMostLikelyTo(players);
      return currentQuestion;
    } else if (doubleValue <= 0.8) {
      this.currentQuestion = getPhotoQuestion(players, context);
      return currentQuestion;
    } else if (doubleValue<= 0.9){
      this.currentQuestion = getWheelOfChallanges(players);
      return currentQuestion;

    }
    this.currentQuestion = get1vs1(players);
    return currentQuestion;


  }

  void addPhotoToFeed(String photoPath,List<UserClass>  playersInPhoto, String photoQuestionText) {
    feedManager.addPhoto(photoPath, playersInPhoto, photoQuestionText);
  }

  int getRandomNumberOfGlasses() {
    return Random().nextInt(8) + 1;
  }

  Question getPhotoQuestion(List<UserClass> players, context) {
    photoQuestions.shuffle();

    int player = Random().nextInt(players.length);

    players.shuffle();
    int randomNbr = Random().nextInt(players.length - 2 );
    List<UserClass> playersForPhoto = [];
    String textForQuestion = "";
    for(int i = 0 ; i < randomNbr + 2 ; i++){
      playersForPhoto.add(players[i]);
      textForQuestion = textForQuestion + players[i].username + ", ";
    }

    return Question(
        type: 'Photo Time',
        widget: Column(
          children: [
            Text( textForQuestion +   photoQuestions.first,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Font5')),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () async {
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
                            playersInPhoto: playersForPhoto,
                            photoQuestionText: photoQuestions.first,)));
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(),
                    Icon(Icons.photo_camera,
                        size: 25, color: Colors.deepOrangeAccent.shade700),
                    Text("Take Photo"),
                    SizedBox()
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for(int i = 0; i < playersForPhoto.length ; i++)
                  Container(
                    width:50,
                    height:50,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: playersForPhoto[i].photoPath.contains('avatar') ? AssetImage(playersForPhoto[i].photoPath) : Image.file(File(playersForPhoto[i].photoPath)).image,
                        fit: BoxFit.fill,
                      ),
                      shape: BoxShape.circle,
                      //border: Border.all(color: Colors.yellow.shade700, width: 3),
                      color: Colors.yellow.shade700,
                    ),
                  )

              ],
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 30,
            ),
          ],
        ),
        nbrGlasses: getRandomNumberOfGlasses());
  }

  Question getNewQuestion(List<UserClass> players) {
    GroupButton buttons = GroupButton(
        players: players, selected: List<bool>.filled(players.length, false));
    return Question(
      type: 'Normal Challenge',
      widget: Column(children: [
        Text(lorem(paragraphs: 1, words: 10),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                fontFamily: 'Font5')),
        SizedBox(height: 40),
        buttons,
      ]),
      nbrGlasses: getRandomNumberOfGlasses(),
    );
  }

  Question getWheelOfChallanges(List<UserClass> players) {
    Random random = new Random();
    int indexWinner = random.nextInt(4); // from 0 to 9 included
    feedManager.addNamesWheelPost(players[indexWinner]);
    ChallangesWheel nm = new ChallangesWheel(indexWinner: indexWinner);
    //nm.createState().
    //_NamesWheelS
    return Question(
        type: 'Challanges Wheel',
        widget: nm,
        nbrGlasses: getRandomNumberOfGlasses());
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
    GroupButton buttons = GroupButton(
        players: players, selected: List<bool>.filled(players.length, false));
    return Question(
        type: 'Most Likely To',
        widget: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(question,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Font5')),
              SizedBox(height: 50),
              buttons,
            ],
          ),
        ),
        complete: () {
          for (int i = 0; i < players.length; i++) {
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
    OneVsOne oneVone = OneVsOne(
        players: players,
        challenge: challenge,
        player1: player1,
        player2: player2,
        changeWinner: (newWinner) {
          winner = newWinner;
          return winner;
        });
    return Question(
        type: '1 vs 1',
        widget: oneVone,
        complete: () {
          if (winner != null) {
            feedManager.addOneVsOnePost(challenge, players[player1],
                players[player2], winner!.username);
          }
        },
        nbrGlasses: getRandomNumberOfGlasses());
  }
}

class OneVsOne extends StatefulWidget {
  final List<UserClass> players;
  final String challenge;
  final int player1;
  final int player2;
  final Function changeWinner;

  const OneVsOne(
      {super.key,
      required this.players,
      required this.challenge,
      required this.player1,
      required this.player2,
      required this.changeWinner});

  @override
  State<StatefulWidget> createState() => _OneVSOneState();
}

class _OneVSOneState extends State<OneVsOne> {
  UserClass? winner;

  changeWinner(player) {
    setState(() {
      if (winner == player) {
        winner = widget.changeWinner(null);
      } else {
        winner = widget.changeWinner(player);
      }
    });
    return winner;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Stack(
            children: [
              GestureDetector(
                  onTap: () {
                    changeWinner(widget.players[widget.player1]);
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: widget.players[widget.player1].photoPath.contains('avatar') ? AssetImage(
                            widget.players[widget.player1].photoPath) : Image.file(File(widget.players[widget.player1].photoPath)).image,
                        fit: BoxFit.fill,
                      ),
                      border: Border.all(
                          color: (winner == widget.players[widget.player1])
                              ? Colors.yellow
                              : Colors.white,
                          width: 4),
                      shape: BoxShape.circle,
                      //border: Border.all(color: Colors.yellow.shade700, width: 3),
                      color: Colors.yellow.shade700,
                    ),
                  )),
              winner == widget.players[widget.player1]
                  ? Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.yellow),
                        child: Icon(
                          Icons.emoji_events_rounded,
                          color: Colors.black,
                          size: 16,
                        ),
                      ))
                  : Container(),
            ],
          ),
          SizedBox(width: 20),
          Text("VS",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Font3',
                  fontSize: 28,
                  color: getTextColorForGameType('1 vs 1'))),
          SizedBox(width: 20),
          Stack(
            children: [
              GestureDetector(
                  onTap: () {
                    changeWinner(widget.players[widget.player2]);
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: widget.players[widget.player2].photoPath.contains('avatar') ? AssetImage(
                            widget.players[widget.player2].photoPath) : Image.file(File(widget.players[widget.player2].photoPath)).image,
                        fit: BoxFit.fill,
                      ),
                      border: Border.all(
                          color: (winner == widget.players[widget.player2])
                              ? Colors.yellow
                              : Colors.white,
                          width: 4),
                      shape: BoxShape.circle,
                      //border: Border.all(color: Colors.yellow.shade700, width: 3),
                      color: Colors.yellow.shade700,
                    ),
                  )),
              winner == widget.players[widget.player2]
                  ? Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.yellow),
                        child: Icon(
                          Icons.emoji_events_rounded,
                          color: Colors.black,
                          size: 16,
                        ),
                      ))
                  : Container(),
            ],
          )
        ]),
        const SizedBox(height: 40),
        Text('${widget.challenge}\nThe other players vote.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                fontFamily: 'Font5',
                color: getTextColorForGameType('1 vs 1'))),
        SizedBox(height: 50),
        ToggleButton(players: [
          widget.players[widget.player1],
          widget.players[widget.player2]
        ], changeWinner: changeWinner, winner: winner)
      ],
    );
  }
}

class ToggleButton extends StatelessWidget {
  final List<UserClass> players;
  final Function changeWinner;
  final UserClass? winner;

  const ToggleButton(
      {super.key,
      required this.players,
      required this.changeWinner,
      required this.winner});

  @override
  Widget build(BuildContext context) {
    return Wrap(
        spacing: 5,
        runSpacing: 5,
        alignment: WrapAlignment.center,
        children: [
          for (var i = 0; i < players.length; i++)
            PlayerButton(
                player: players[i],
                isSelected: () {
                  return winner == players[i];
                },
                toggleFunc: changeWinner)
        ]);
  }
}

class GroupButton extends StatelessWidget {
  final List<UserClass> players;
  final List<bool> selected;

  toggle(UserClass player) {
    selected[players.indexOf(player)] = !selected[players.indexOf(player)];
  }

  const GroupButton({super.key, required this.players, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
        spacing: 5,
        runSpacing: 5,
        alignment: WrapAlignment.center,
        children: [
          for (var i = 0; i < players.length; i++)
            PlayerButton(
                player: players[i],
                isSelected: () {
                  return selected[i];
                },
                toggleFunc: toggle)
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

  const PlayerButton(
      {super.key,
      required this.player,
      required this.isSelected,
      required this.toggleFunc});

  @override
  _MyWidgetState createState() => _MyWidgetState();
// creating State Object of MyWidget
}

class _MyWidgetState extends State<PlayerButton> {
  // State Object

  @override
  Widget build(BuildContext context) {
    bool isFromCamera = widget.player.picsFromCamera.contains(widget.player.photoPath);
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
                  color: widget.isSelected()
                      ? Colors.deepOrangeAccent
                      : Colors.white,
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
                          image: isFromCamera ? Image.file(File(widget.player.photoPath)).image : AssetImage(widget.player.photoPath),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Text(widget.player.username,
                        style: TextStyle(
                            fontWeight: widget.isSelected()
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: widget.isSelected()
                                ? Colors.white
                                : Colors.black)),
                  ],
                )))));
  }
}
