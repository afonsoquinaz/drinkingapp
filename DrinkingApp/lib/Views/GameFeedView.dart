import 'package:flutter/material.dart';
import 'package:drinkingapp/main.dart';
import 'package:drinkingapp/questionsManager/questionsManager.dart';
import 'package:drinkingapp/Game.dart';

class GameFeedView extends StatelessWidget {
  const GameFeedView({Key? key, required this.questionsManager, required this.players})
      : super(key: key);
  final QuestionsManager questionsManager;
  final List<String> players;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
          title: 'Flutter Demo Home Page', questionsManager: questionsManager, players: players,),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {Key? key, required this.title, required this.questionsManager, required this.players})
      : super(key: key);

  final QuestionsManager questionsManager;
  final String title;
  final List<String> players;

  @override
  State<MyHomePage> createState() =>
      _MyHomePageState(questionsManager: questionsManager , players: players);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState({Key? key, required this.questionsManager , required this.players});

  final QuestionsManager questionsManager;
  final List<String> players;
  final playersTextController = TextEditingController();
  int _counter = 0;
  String questionText = "The game starts here";
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffb0e3df),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 30,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Opacity(
                  opacity: 0.3,
                  child: IconButton(
                    icon: const Icon(Icons.home),
                    color: Colors.black,
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Game(players: players, questionsManager: questionsManager)),
                            (Route<dynamic> route) => false,
                      );
                    },
                  )),
              Container(
                color: Colors.black45,
                height: 20,
                width: 2,
              ),
              IconButton(
                icon: const Icon(Icons.menu),
                color: Colors.black,
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Expanded(
              child: SingleChildScrollView(
                  child: new Column( children: [
            for (Widget post in questionsManager.getFeed())
              post,
          ]))),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.play_arrow_outlined),
                    color: Colors.white,
                    onPressed: () {},
                  ),
                ],
              )
            ],
          ),
        ],
      )),
    );
  }
}
