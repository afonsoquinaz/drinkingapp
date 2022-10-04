import 'package:flutter/material.dart';
import 'package:drinkingapp/main.dart';
import 'package:drinkingapp/questionsManager/questionsManager.dart';
import 'package:drinkingapp/Game.dart';

class GameFeedView extends StatelessWidget {
  const GameFeedView({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final playersTextController  = TextEditingController();
  int _counter = 0;
  String Players = "";
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
                        MaterialPageRoute(builder: (context) => const MyApp()),
                            (Route<dynamic> route) => false,
                      );
                    },
                  ),
                ],
              ),
              SizedBox(),
              SizedBox(),
              Text("FEED VIEW"),
              SizedBox(),
              SizedBox(),
              SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.play_arrow_outlined),
                        color: Colors.white,
                        onPressed: () {

                       //   Navigator.pushAndRemoveUntil(
                       //     context,
                       //     MaterialPageRoute(builder: (context) => const Game()),
                       //         (Route<dynamic> route) => false,
                       //   );

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

