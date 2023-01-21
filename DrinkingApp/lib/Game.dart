import 'package:camera/camera.dart';
import 'package:drinkingapp/Constants/ColorPalette.dart';
import 'package:drinkingapp/Question.dart';
import 'package:drinkingapp/questionsManager/TakePictureScreen.dart';
import 'package:drinkingapp/questionsManager/UserClass.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:async';
import 'package:drinkingapp/questionsManager/questionsManager.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'Views/EndGameView.dart';
import 'Views/GameFeedView.dart';

class Game extends StatelessWidget {
  final List<UserClass> players;
  final QuestionsManager questionsManager;
  const Game({Key? key, required this.players, required this.questionsManager})
      : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
          title: 'Flutter Demo Home Page',
          players: players,
          questionsManager: questionsManager),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {Key? key,
      required this.title,
      required this.players,
      required this.questionsManager})
      : super(key: key);
  final List<UserClass> players;
  final String title;
  final QuestionsManager questionsManager;

  @override
  State<StatefulWidget> createState() =>
      _MyHomePageState(questionsManager: questionsManager, players: players);
}

class _MyHomePageState extends State<MyHomePage> {
  final QuestionsManager questionsManager;
  final List<UserClass> players;

  _MyHomePageState({required this.questionsManager, required this.players});

  Question question = Question(
      type: "Game started!",
      widget: Text("The game starts here"),
      nbrGlasses: 1);

  @override
  void initState() {
      if(questionsManager.getCurrentQuestion().type != "first" && questionsManager.currentQuestion.type != ("Photo Time"))
        question = questionsManager.getCurrentQuestion();
      else
        question = questionsManager.getWidgetForQuestion(players, context);

  }

  // StreamController<int> selected = StreamController<int>();

  // @override
  // void dispose() {
  //   selected.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onHorizontalDragEnd: (details) {
          // Note: Sensitivity is integer used when you don't want to mess up vertical drag
          // int sensitivity = 5;
          // if (details.delta.dx > sensitivity) {
          debugPrint("swipe ${details.velocity}");
          if (question.complete != null) {
            question.complete!();
          }
          setState(() {
            question =
                questionsManager.getWidgetForQuestion(widget.players, context);
          });
          // } else if (details.delta.dx < -sensitivity) {
          //   debugPrint("swipe left");
          //   setState(() {
          //     question = q.getWidgetForQuestion(widget.players);
          //   });
          // }
        },
        child: Scaffold(
          //0xffb0e3df
          backgroundColor: getColorForGameType(question.type),
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Row(
              //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //  children: [
              //    SizedBox(),
              //    IconButton(
              //     icon: const Icon(Icons.close),
              //      color: Colors.white,
              //      onPressed: () {
              //        Navigator.pushAndRemoveUntil(
              //          context,
              //          MaterialPageRoute(
              //             builder: (context) => const EndGameView()),
              //             (Route<dynamic> route) => false,
              //       );
              //       },
              //    ),
              //   ],
              // ),
              Column(children: [
                SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'HOME',
                        style: TextStyle(
                            color: getTextColorForGameType(question.type)),
                      ),
                    ),
                    Container(
                      color: getTextColorForGameType(question.type)
                          .withOpacity(0.8),
                      height: 20,
                      width: 2,
                    ),
                    Opacity(
                      opacity: 0.3,
                      child: TextButton(
                        onPressed: () async {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GameFeedView(
                                      questionsManager: questionsManager,
                                      players: players,
                                    )),
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: Text(
                          'FEED',
                          style: TextStyle(
                              color: getTextColorForGameType(question.type)),
                        ),
                      ),
                    ),
                  ],
                )
              ]),
              // Text(questionText),
              SizedBox(),
              SizedBox(),
              Text(
                question.type,
                style: TextStyle(
                    fontSize: 36,
                    color: getTextColorForGameType(question.type),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Font3'),
              ),
              SizedBox(),
              question.widget,
              SizedBox(),
              SizedBox(),
              Column(
                children: [
                  Text(
                    "The winner drinks " +
                        question.nbrGlasses.toString() +
                        " sips",
                    style: TextStyle(
                        color: getTextColorForGameType(question.type)
                            .withOpacity(0.7)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < question.nbrGlasses; i++)
                        Container(
                          width: 42,
                          height: 35,
                          child: Image.asset("images/cocktail.png"),)

                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      getTextColorForGameType(question.type),
                                ),
                                onPressed: () {
                                  if (question.complete != null) {
                                    question.complete!();
                                  }
                                  setState(() {
                                    question =
                                        questionsManager.getWidgetForQuestion(
                                            widget.players, context);
                                    // questionText = q.getNewQuestion().toString();
                                    // print(q.getNewQuestion());
                                  });
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(width: 5),
                                    Text('NEXT',
                                        style: TextStyle(

                                            color: (getTextColorForGameType(
                                                        question.type) ==
                                                    Color.fromARGB(
                                                        255, 255, 255, 255))
                                                ? Color.fromARGB(255, 0, 0, 0)
                                                : Color.fromARGB(255, 255, 255,
                                                    255))), // <-- Text
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      // <-- Icon
                                      Icons.navigate_next_outlined,
                                      size: 24.0,
                                      color: (getTextColorForGameType(
                                                  question.type) ==
                                              Color.fromARGB(
                                                  255, 255, 255, 255))
                                          ? Color.fromARGB(255, 0, 0, 0)
                                          : Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ],
              )
            ],
          )),
        ));
  }
}
