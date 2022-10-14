import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:async';
import 'package:drinkingapp/questionsManager/questionsManager.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'Views/EndGameView.dart';
import 'Views/GameFeedView.dart';

class Game extends StatelessWidget {
  final List<String> players;

  const Game({Key? key, required this.players}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page', players: players),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.players})
      : super(key: key);
  final List<String> players;
  final String title;

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  QuestionsManager q;

  _MyHomePageState() : q = QuestionsManager();

  Widget question = Text("The game starts here");

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
            question = q.getWidgetForQuestion(widget.players);
          });
          // } else if (details.delta.dx < -sensitivity) {
          //   debugPrint("swipe left");
          //   setState(() {
          //     question = q.getWidgetForQuestion(widget.players);
          //   });
          // }
        },
        child: Scaffold(
          backgroundColor: Colors.teal,
          body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EndGameView()),
                                (Route<dynamic> route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(),
                  SizedBox(),
                  // Text(questionText),
                  question,
                  // Expanded(
                  //   child:
                  //       Container(
                  //         margin: const EdgeInsets.all(20.0),
                  //     child: GestureDetector(
                  //       onTap: () {
                  //         setState(() {
                  //           selected.add(
                  //             Fortune.randomInt(0, players.length),
                  //           );
                  //         });
                  //       },
                  //       child: Column(
                  //           children: [
                  //             Expanded(
                  //               child: FortuneWheel(
                  //                 selected: selected.stream,
                  //                 items: [
                  //                   for (var playerName in players) FortuneItem(child: Text(playerName)),
                  //                 ],
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  // ),
                  // ),
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: <Widget>[
                  //     for(var playerName in players ) Text(playerName)
                  //   ],
                  // ),
                  // Text(players.toString()),
                  SizedBox(),
                  SizedBox(),
                  SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.dynamic_feed),
                            color: Colors.white,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>  GameFeedView(questionsManager: q))
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.navigate_next_outlined),
                            color: Colors.white,
                            onPressed: () {
                              setState(() {
                                question = q.getWidgetForQuestion(widget.players);
                                // questionText = q.getNewQuestion().toString();
                                // print(q.getNewQuestion());
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            color: Colors.white,
                            onPressed: () {},
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
