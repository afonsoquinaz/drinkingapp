import 'package:drinkingapp/questionsManager/UserClass.dart';
import 'package:flutter/material.dart';
import 'Game.dart';
import 'GameModeSelection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  final playersTextController = TextEditingController();
  // int _counter = 0;
  List<UserClass> players = [];

  // String Players = "";

  // void _incrementCounter() {
  //   setState(() {
  //     _counter++;
  //   });
  // }

  addPlayer() {
    UserClass newPlayer = UserClass(playersTextController.text.trim(), '');
    players.add(newPlayer);
    // Players = Players + playersTextController.text + "\n";
    playersTextController.clear();
    // _counter++;
  }

  addQuickPlayers(){
    UserClass newPlayer = UserClass("Afonso", '');
    players.add(newPlayer);
    newPlayer = UserClass("Tiago", '');
    players.add(newPlayer);
    newPlayer = UserClass("Francisca", '');
    players.add(newPlayer);
    newPlayer = UserClass("Mateus", '');
    players.add(newPlayer);
    newPlayer = UserClass("Ana", '');
    players.add(newPlayer);
    newPlayer = UserClass("Cristiano7", '');
    players.add(newPlayer);
    // Players = Players + playersTextController.text + "\n";
    playersTextController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Color(0xffb0e3df),
          body: Center(
            child: Container(
              padding: const EdgeInsets.all(40.0),
              // margin: const EdgeInsets.only(left: 40.0, right: 40.0),
              child: SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(top: 20.0, bottom: 60.0),
                        child: Text(
                          "DRINKING_APP",
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.blueGrey,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w900),
                          textAlign: TextAlign.center,
                        ))
                  ]),
                  Column(children: [
                    Container(
                        // margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Text(
                      "WANNA HAVE A MEMORABLE NIGHT?",
                      style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    )),
                    Container(
                        margin: const EdgeInsets.only(top: 20.0, bottom: 60.0),
                        child: Text(
                          "Add your alcoholic friends",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                        )),
                    Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        // decoration: BoxDecoration(
                        //     border: Border.all(color: Colors.blueAccent)),
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                child: MediaQuery.removePadding(
                                    context: context,
                                    removeTop: true,
                                    child: Scrollbar(
                                      thumbVisibility: true,
                                      child: ListView(
                                          primary: true,
                                          shrinkWrap: true,
                                          reverse: true,
                                          children: <Widget>[
                                            Wrap(
                                              spacing: 8.0,
                                              runSpacing: 8.0,
                                              verticalDirection:
                                                  VerticalDirection.up,
                                              children: [
                                                for (var i = 0;
                                                    i < players.length;
                                                    i++)
                                                  Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.white,
                                                      ),
                                                      child: Container(
                                                          height: 31,
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 5),
                                                          child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Text(players[i].username,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16)),
                                                                SizedBox(
                                                                    width: 10),
                                                                IconButton(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              5),
                                                                  constraints:
                                                                      BoxConstraints(),
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .close,
                                                                      color: Colors
                                                                          .red,
                                                                      size: 20),
                                                                  onPressed:
                                                                      () {
                                                                    setState(() =>
                                                                        players.removeAt(
                                                                            i));
                                                                  },
                                                                  splashRadius:
                                                                      20,
                                                                  iconSize: 20,
                                                                )
                                                              ])))
                                              ],
                                            )
                                          ]),
                                    )))
                          ],
                        )),
                    IntrinsicHeight(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                          Expanded(
                              child: Container(
                                  // height: 44,
                                  child: TextField(
                                    textCapitalization: TextCapitalization.words,
                            controller: playersTextController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: Colors.black)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: Colors.black)),
                              hintText: 'Add a new player',
                            ),
                            onSubmitted: (value) {
                              if (playersTextController.text.trim() != '') {
                                setState(() => addPlayer());
                              }
                            },
                            onEditingComplete: () {},
                          ))),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              if (playersTextController.text.trim() != '') {
                                setState(() => addPlayer());
                              }
                            },
                            child: const Icon(Icons.add),
                            style: ElevatedButton.styleFrom(
                              //backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(10), // <-- Radius
                              ),
                            ),
                          ),
                        ])),
                    Container(
                        margin: const EdgeInsets.only(top: 120.0, bottom: 10.0),
                        child: Text(
                          "Let's get started!",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                        )),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Expanded(
                          child: Container(
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () {

                                  setState(() {
                                    addQuickPlayers();
                                  });
                                },
                                child: const Text("Quick add players",
                                    style: TextStyle(fontSize: 18)),
                                style: ElevatedButton.styleFrom(
                                  //backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(10), // <-- Radius
                                  ),
                                ),
                              )))
                    ]),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Expanded(
                          child: Container(
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (playersTextController.text.trim() != '') {
                                    addPlayer();
                                  }
                                  if (players.length > 1) {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              GameModeSelection(
                                                  players: players)),
                                          (Route<dynamic> route) => false,
                                    );
                                  }
                                },
                                child: const Text("GET READY",
                                    style: TextStyle(fontSize: 18)),
                                style: ElevatedButton.styleFrom(
                                  //backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(10), // <-- Radius
                                  ),
                                ),
                              )))
                    ])
                  ])
                ],
              )),
            ),
          )),
    );
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: _incrementCounter,
    //    tooltip: 'Increment',
    //   child: const Icon(Icons.add),
    //   ), // This trailing comma makes auto-formatting nicer for build methods.
  }
}
