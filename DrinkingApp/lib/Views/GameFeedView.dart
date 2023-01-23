import 'package:drinkingapp/questionsManager/UserClass.dart';
import 'package:flutter/material.dart';
import 'package:drinkingapp/main.dart';
import 'package:drinkingapp/questionsManager/questionsManager.dart';
import 'package:drinkingapp/Game.dart';

class GameFeedView extends StatelessWidget {
  const GameFeedView({Key? key, required this.questionsManager, required this.players})
      : super(key: key);
  final QuestionsManager questionsManager;
  final List<UserClass> players;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MyHomePage(
          title: 'Flutter Demo Home Page', questionsManager: questionsManager, players: players);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {Key? key, required this.title, required this.questionsManager, required this.players})
      : super(key: key);

  final QuestionsManager questionsManager;
  final String title;
  final List<UserClass> players;

  @override
  State<MyHomePage> createState() =>
      _MyHomePageState(questionsManager: questionsManager , players: players);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState({Key? key, required this.questionsManager , required this.players});

  final QuestionsManager questionsManager;
  final List<UserClass> players;


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
                height: 35,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Opacity(
                  opacity: 0.3,
                  child: TextButton(onPressed: () {
                      Navigator.pop(context);
                    }, child: Text('GAME', style: TextStyle(color: Colors.black),),
                  )),
              Container(
                color: Colors.black45,
                height: 20,
                width: 2,
              ),
              TextButton(onPressed: () {}, child: Text('FEED', style: TextStyle(color: Colors.black)),),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Expanded(
              child: SingleChildScrollView(
                  child: new Column( children: [
            for (Widget post in questionsManager.getFeed().reversed)
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
