import 'package:flutter/material.dart';
import 'main.dart';
import 'package:drinkingapp/questionsManager/questionsManager.dart';
import 'Views/EndGameView.dart';
import 'Views/GameFeedView.dart';

class Game extends StatelessWidget {
  final String Players;
  const Game({Key? key , required this.Players}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  MyHomePage(title: 'Flutter Demo Home Page', Players: Players),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.Players}) : super(key: key);
  final String Players;
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState(Players);
}

class _MyHomePageState extends State<MyHomePage> {

  _MyHomePageState(this.Players);
  final String Players;

  final playersTextController  = TextEditingController();
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
      backgroundColor: Colors.teal,

      body: Center(
          child:  Column(
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
                        MaterialPageRoute(builder: (context) => const EndGameView()),
                            (Route<dynamic> route) => false,
                      );
                    },
                  ),
                ],
              ),
              SizedBox(),
              SizedBox(),
              Text(questionText),
              Text(Players.toString()),
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

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const GameFeedView()),
                                (Route<dynamic> route) => false,
                          );

                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.navigate_next_outlined),
                        color: Colors.white,
                        onPressed: () {

                          setState(() {
                            var q = questionsManager();
                            questionText = q.getNewQuestion().toString();
                            print(q.getNewQuestion());
                          });


                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        color: Colors.white,
                        onPressed: () {

                        },
                      ),
                    ],
                  )
                ],
              ),
            ],
          )

      ),
    );
  }
}

