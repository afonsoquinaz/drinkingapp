import 'package:flutter/material.dart';
import 'Game.dart';
import 'GameModeSelection.dart';
void main() {
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
  final playersTextController  = TextEditingController();
  int _counter = 0;
  String Players = "";
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              "Picolo",
              style: TextStyle(fontSize: 50),
            ),

            Column(
              children: [
                Text(
                  Players,
                  style: TextStyle(fontSize: 23),
                ),
                TextField(
                  controller: playersTextController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Add a new player',
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_circle),
                    color: Colors.white,
                    onPressed: () {
                      setState(() {
                        Players = Players + playersTextController.text + "\n";
                        playersTextController.text = "";
                        _counter++;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.next_plan),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) =>  GameModeSelection(Players: Players)),
                            (Route<dynamic> route) => false,
                      );
                    },
                  ),
                  ],
                ),
              //  const Text(
    //     'You have pushed the button this many timessss:',
    //    ),
             //   Text(
    //     '$_counter',
    //     style: Theme.of(context).textTheme.headline4,
                //    ),
            ],
            ),

          ],
        ),
      ),
      //   floatingActionButton: FloatingActionButton(
      //     onPressed: _incrementCounter,
      //    tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      //   ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}
