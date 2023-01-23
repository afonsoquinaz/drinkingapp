import 'package:flutter/material.dart';
import 'package:drinkingapp/main.dart';
import 'package:drinkingapp/questionsManager/questionsManager.dart';


class EndGameView extends StatelessWidget {
  const EndGameView({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MyHomePage(title: 'Flutter Demo Home Page');
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {





    return Scaffold(
      backgroundColor: Color(0xffb0e3df),

      body: Center(
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(),
              SizedBox(),
              SizedBox(),
              Text(
                "Game\nOver",
                style: TextStyle(
                    fontSize: 90,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Font3'),
                textAlign: TextAlign.center,
              ),
              Text("Hope to see you soon!",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Font5')),
              SizedBox(),
              SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const MyApp()),
                                (Route<dynamic> route) => false,
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(width: 5),
                            Text('HOMEPAGE',
                                style: TextStyle(
                                    color: Colors.white)), // <-- Text
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              // <-- Icon
                              Icons.navigate_next_outlined,
                              size: 24.0,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(),
            ],
          )

      ),
    );
  }
}

