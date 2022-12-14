import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'dart:math';
import 'package:flutter/services.dart' as rootBundle;
import 'package:drinkingapp/questionsManager/NamesWheel.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'NamesWheel.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class FeedManager {
  late List<Widget> feed;

  FeedManager() {
    feed = [];
  }

  List<Widget> getFeed() {
    return feed;
  }

  void setFeed(List<Widget> newFeed) {
    feed = newFeed;
  }

  void addPhoto(String photoPath, String player) {
    feed.add(DisplayPictureScreen(imagePath: photoPath, player: player));
  }

  addNamesWheelPost(String winner) {
    feed.add(NamesWheelPost(winner: winner));
  }

  addOneVsOnePost(String challenge, String player1, String player2, String winner) {
    feed.add(OneVsOnePost(challenge: challenge, winner: winner, player1: player1, player2: player2));
  }

  addMostLikelyToPost(String mltLevel, String winner) {
    feed.add(MostLikelyToPost(winner: winner, sentence: mltLevel));
  }
}

class OneVsOnePost extends StatelessWidget {
  final String challenge;
  final String player1;
  final String player2;
  final String winner;

  const OneVsOnePost({super.key, required this.challenge, required this.winner, required this.player1, required this.player2});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                Icon(Icons.account_circle),
                SizedBox(width: 3),
                Text('vs', style: TextStyle(
                  fontWeight: FontWeight.bold,
                )),
                SizedBox(width: 3),
                Icon(Icons.account_circle),
                SizedBox(width: 10),
                Text(
                  player1,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 5),
                Text('and', style: TextStyle(fontStyle: FontStyle.italic)),
                SizedBox(width: 5),
                Text(
                  player2,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ]),
              IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  onPressed: () async {
                    await Share.share(
                        "$player1 and $player2 are playing a drinking game and had to face the following challenge: $challenge\n"
                            "$winner was the best and won.\n"
                            "Discover our drinking game app here: bit.ly/our_link(not-working)\n"
                            "xoxo",
                        subject: "Drinking App Moment");
                  },
                  icon: Icon(Icons.share_outlined))
            ]),
            SizedBox(height: 10),
            Text('Challenge: $challenge\n$winner won this challenge!')
          ],
        ),
      ),
    );
  }
}

class NamesWheelPost extends StatelessWidget {
  final String winner;

  const NamesWheelPost({super.key, required this.winner});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                Icon(Icons.account_circle),
                SizedBox(width: 10),
                Text(
                  winner,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ]),
              IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  onPressed: () async {
                    await Share.share(
                        "${winner} is playing a drinking game and was selected by the names wheel.\n"
                        "Discover our drinking game app here: bit.ly/our_link(not-working)\n"
                        "xoxo",
                        subject: "Drinking App Moment");
                    print("oi");
                  },
                  icon: Icon(Icons.share_outlined))
            ]),
            SizedBox(height: 10),
            Text('Was selected by the names wheel. So lucky!')
          ],
        ),
      ),
    );
  }
}

class MostLikelyToPost extends StatelessWidget {
  final String winner;
  final String sentence;

  const MostLikelyToPost(
      {super.key, required this.winner, required this.sentence});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                Icon(Icons.account_circle),
                SizedBox(width: 10),
                Text(
                  winner,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ]),
              IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  onPressed: () async {
                    await Share.share(
                        "${winner} is playing a drinking game and was voted as the ${sentence.substring(7).replaceAll('?', '.')}\n"
                        "Discover our drinking game app here: bit.ly/our_link(not-working)\n"
                        "xoxo",
                        subject: "Drinking App Moment");
                    print("oi");
                  },
                  icon: Icon(Icons.share_outlined))
            ]),
            SizedBox(height: 10),
            Text('Voted as the ${sentence.substring(7).replaceAll('?', '.')}')
          ],
        ),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final String player;

  const DisplayPictureScreen(
      {super.key, required this.imagePath, required this.player});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
      child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: [
                  Icon(Icons.account_circle),
                  SizedBox(width: 10),
                  Text(
                    player,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ]),
                IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    onPressed: () async {
                      await Share.shareFiles(
                        [imagePath],
                        text:
                            "${player} is playing a drinking game and wanted to share this moment with you!\n"
                            "Discover our drinking game app here: bit.ly/our_link(not-working)\n"
                            "xoxo",
                        subject: "Drinking App Moment",
                      );

                      print("oi");
                    },
                    icon: Icon(Icons.share_outlined))
              ]),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(File(imagePath)),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              SizedBox(height: 10),
              Icon(Icons.favorite_border),
              SizedBox(height: 5),
              Text('x likes'),
              Row(children: [
                Text(
                  player,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Text("caption"),
              ])
            ],
          )),
    );
  }
}
