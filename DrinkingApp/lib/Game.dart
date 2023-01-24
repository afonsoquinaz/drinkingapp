import 'package:drinkingapp/Constants/ColorPalette.dart';
import 'package:drinkingapp/Question.dart';
import 'package:drinkingapp/questionsManager/UserClass.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:drinkingapp/questionsManager/questionsManager.dart';
import 'Views/EndGameView.dart';
import 'Views/GameFeedView.dart';
import 'package:swipe_cards/swipe_cards.dart';

class Game extends StatelessWidget {
  final List<UserClass> players;
  final QuestionsManager questionsManager;
  const Game({Key? key, required this.players, required this.questionsManager})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameScreen(
        title: 'Flutter Demo Home Page',
        players: players,
        questionsManager: questionsManager);
  }
}

class GameScreen extends StatefulWidget {
  final List<UserClass> players;
  final String title;
  final QuestionsManager questionsManager;

  const GameScreen(
      {super.key,
      required this.players,
      required this.title,
      required this.questionsManager});

  @override
  State<StatefulWidget> createState() =>
      _GameScreenState(questionsManager: questionsManager, players: players);
}

class _GameScreenState extends State<GameScreen> {
  final QuestionsManager questionsManager;
  final List<UserClass> players;
  List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;

  _GameScreenState({required this.questionsManager, required this.players});

  void addQuestions(){
    for (int i = 0; i < 20; i++) {
      var question = questionsManager.getWidgetForQuestion(players, context, () => _matchEngine);
      _swipeItems.add(SwipeItem(
          content: [
            Content(
                question: question,
                questionsManager: questionsManager,
                players: players),
            question.type
          ],
          nopeAction: () {
            if (question.complete != null) {
              question.complete!();
            }
          },
          onSlideUpdate: (SlideRegion? region) async {
            //print("Region $region");
          }));
    }
  }

  @override
  void initState() {
    addQuestions();
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SwipeCards(
      matchEngine: _matchEngine!,
      itemBuilder: (BuildContext context, int index) {
        return Scaffold(
            backgroundColor: getColorForGameType(_swipeItems[index].content[1]),
            body: WillPopScope( onWillPop: () async {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Finish game"),
                  content:
                  const Text("Are you sure you want to finish the game? We'll miss you :("),
                  actions: <Widget>[
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            ctx,
                            MaterialPageRoute(
                                builder: (context) => const EndGameView()),
                                (Route<dynamic> route) => false,
                          );
                        },
                        child: const Text("YES",
                            style: TextStyle(color: Colors.red)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: const Text("NO",
                            style: TextStyle(color: Colors.green)),
                      ),
                    ])
                  ],
                ),
              );
              return false;
            },
            child: Column(children: [
              TopBar(
                  players: players,
                  questionsManager: questionsManager,
                  questionType: _swipeItems[index].content[1]),
              _swipeItems[index].content[0],
              BottomBar(
                  matchEngine: _matchEngine!,
                  questionType: _swipeItems[index].content[1])
            ])));
      },
      onStackFinished: () {
        // setState(() {
        //   addQuestions();
        // });
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text("Stack Finished"),
        //   duration: Duration(milliseconds: 500),
        // ));
      },
      itemChanged: (SwipeItem item, int index) {
        if (index % 18 == 0){
          setState(() {
            addQuestions();
          });
        }
        //print("item: ${item.content.text}, index: $index");
      },
      leftSwipeAllowed: true,
      rightSwipeAllowed: false,
      upSwipeAllowed: false,
      fillSpace: true,
    );
  }
}

class TopBar extends StatelessWidget {
  final List<UserClass> players;
  final QuestionsManager questionsManager;
  final String questionType;

  const TopBar(
      {super.key,
      required this.players,
      required this.questionsManager,
      required this.questionType});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 35),
      Stack(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {},
              child: Text(
                'GAME',
                style: TextStyle(color: getTextColorForGameType(questionType)),
              ),
            ),
            Container(
              color: getTextColorForGameType(questionType).withOpacity(0.8),
              height: 20,
              width: 2,
            ),
            Opacity(
              opacity: 0.3,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GameFeedView(
                              questionsManager: questionsManager,
                              players: players,
                            )),
                  );
                },
                child: Text(
                  'FEED',
                  style:
                      TextStyle(color: getTextColorForGameType(questionType)),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.close),
              color: getTextColorForGameType(questionType),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Finish game"),
                    content:
                        const Text("Are you sure you want to finish the game? We'll miss you :("),
                    actions: <Widget>[
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              ctx,
                              MaterialPageRoute(
                                  builder: (context) => const EndGameView()),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: const Text("YES",
                              style: TextStyle(color: Colors.red)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: const Text("NO",
                              style: TextStyle(color: Colors.green)),
                        ),
                      ])
                    ],
                  ),
                );
              },
            ),
          ],
        )
      ]),
    ]);
  }
}

class Content extends StatelessWidget {
  final Question question;
  final QuestionsManager questionsManager;
  final List<UserClass> players;

  const Content(
      {super.key,
      required this.question,
      required this.questionsManager,
      required this.players});

  // advanceQuestion(){
  //   if (question.complete != null) {
  //     question.complete!();
  //   }
  //   setState(() {
  //     question =
  //         questionsManager.getWidgetForQuestion(
  //             widget.players, context);
  //     // questionText = q.getNewQuestion().toString();
  //     // print(q.getNewQuestion());
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
        Container(margin: EdgeInsets.all(20), child: question.widget),
        SizedBox(),
        SizedBox(),
        Column(
          children: [
            Text(
              "The winner drinks " + question.nbrGlasses.toString() + " sips",
              style: TextStyle(
                  color:
                      getTextColorForGameType(question.type).withOpacity(0.7)),
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
                    child: Image.asset("images/cocktail.png"),
                  )
              ],
            ),
            SizedBox(
              height: 40,
            ),
          ],
        )
      ],
    )));
  }
}

class BottomBar extends StatelessWidget {
  final MatchEngine matchEngine;
  final String questionType;

  const BottomBar(
      {super.key, required this.matchEngine, required this.questionType});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: getTextColorForGameType(questionType),
                  ),
                  onPressed: () {
                    matchEngine.currentItem?.nope();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: 5),
                      Text('NEXT',
                          style: TextStyle(
                              color: (getTextColorForGameType(questionType) ==
                                      Color.fromARGB(255, 255, 255, 255))
                                  ? Color.fromARGB(255, 0, 0, 0)
                                  : Color.fromARGB(
                                      255, 255, 255, 255))), // <-- Text
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        // <-- Icon
                        Icons.navigate_next_outlined,
                        size: 24.0,
                        color: (getTextColorForGameType(questionType) ==
                                Color.fromARGB(255, 255, 255, 255))
                            ? Color.fromARGB(255, 0, 0, 0)
                            : Color.fromARGB(255, 255, 255, 255),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
