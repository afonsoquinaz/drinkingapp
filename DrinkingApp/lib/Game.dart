import 'package:camera/camera.dart';
import 'package:drinkingapp/questionsManager/TakePictureScreen.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:async';
import 'package:drinkingapp/questionsManager/questionsManager.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'Views/EndGameView.dart';
import 'Views/GameFeedView.dart';

class Game extends StatelessWidget {
  final List<String> players;
  final QuestionsManager questionsManager;
  const Game({Key? key, required this.players, required this.questionsManager}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page', players: players, questionsManager: questionsManager),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.players, required this.questionsManager})
      : super(key: key);
  final List<String> players;
  final String title;
  final QuestionsManager questionsManager;

  @override
  State<StatefulWidget> createState() => _MyHomePageState(questionsManager: questionsManager ,players: players);
}

class _MyHomePageState extends State<MyHomePage> {
  final QuestionsManager questionsManager;
  final List<String> players;

  _MyHomePageState({required this.questionsManager,required this.players});

  Widget question = Text("The game starts here");

  @override
  void initState() {

    question=  questionsManager.getWidgetForQuestion(widget.players, context);
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
          setState(() {
            question = questionsManager.getWidgetForQuestion(widget.players, context);
          });
          // } else if (details.delta.dx < -sensitivity) {
          //   debugPrint("swipe left");
          //   setState(() {
          //     question = q.getWidgetForQuestion(widget.players);
          //   });
          // }
        },
        child: Scaffold(
          backgroundColor: Color(0xffb0e3df),
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
                    SizedBox(height: 25),
                    Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(

                        icon: const Icon(Icons.home),
                        color: Colors.black,

                        onPressed: () {

                        },
                      ),
                      Container(color: Colors.black45, height: 20, width: 2,),

                      Opacity(
                        opacity: 0.3,
                        child: IconButton(

                          icon: const Icon(Icons.menu),
                          color: Colors.black,

                          onPressed: () async {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => GameFeedView(questionsManager: questionsManager, players: players ,)),
                                  (Route<dynamic> route) => false,
                            );

                          },
                        ),
                      ),



                    ],
                  )]),
                  SizedBox(),
                  SizedBox(),
                  // Text(questionText),
                  question,

                  SizedBox(),
                  SizedBox(),
                  SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(),
                      Row(
                        children: [

                          IconButton(
                            icon: const Icon(Icons.navigate_next_outlined),
                            iconSize: 60,
                            color: Colors.black,
                            onPressed: () {
                              setState(() {
                                question = questionsManager.getWidgetForQuestion(widget.players, context);
                                // questionText = q.getNewQuestion().toString();
                                // print(q.getNewQuestion());
                              });
                            },
                          ),

                        ],
                      )
                    ],
                  ),
                ],
              )),
        ));
  }
}
