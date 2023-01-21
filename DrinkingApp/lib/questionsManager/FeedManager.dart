import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'dart:math';
import 'package:drinkingapp/questionsManager/UserClass.dart';
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

  void addPhoto(String photoPath, List<UserClass> playersInPhoto , String photoQuestionText) {
    feed.add(DisplayPictureScreen(imagePath: photoPath, playersInPhoto: playersInPhoto, photoQuestionText: photoQuestionText));
  }

  addNamesWheelPost(UserClass winner) {
    feed.add(NamesWheelPost(winner: winner));
  }

  addOneVsOnePost(
      String challenge, UserClass player1, UserClass player2, String winner) {
    feed.add(OneVsOnePost(
        challenge: challenge,
        winner: winner,
        player1: player1,
        player2: player2));
  }

  addMostLikelyToPost(String mltLevel, UserClass winner) {
    feed.add(MostLikelyToPost(winner: winner, sentence: mltLevel));
  }
}

class OneVsOnePost extends StatelessWidget {
  final String challenge;
  final UserClass player1;
  final UserClass player2;
  final String winner;

  const OneVsOnePost(
      {super.key,
      required this.challenge,
      required this.winner,
      required this.player1,
      required this.player2});

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
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(player1.photoPath),
                      fit: BoxFit.fill,
                    ),
                    shape: BoxShape.circle,
                    //border: Border.all(color: Colors.yellow.shade700, width: 3),
                    color: Colors.yellow.shade700,
                  ),
                ),
                SizedBox(width: 3),
                Text('vs',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(width: 3),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(player2.photoPath),
                      fit: BoxFit.fill,
                    ),
                    shape: BoxShape.circle,
                    //border: Border.all(color: Colors.yellow.shade700, width: 3),
                    color: Colors.yellow.shade700,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  player1.username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 5),
                Text('and', style: TextStyle(fontStyle: FontStyle.italic)),
                SizedBox(width: 5),
                Text(
                  player2.username,
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
                        "${player1.username} and ${player2.username} are playing a drinking game and had to face the following challenge: $challenge\n"
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
  final UserClass winner;

  const NamesWheelPost({super.key, required this.winner});

  @override
  Widget build(BuildContext context) {
    return GenericCard(
        player: winner,
        sharedText:
            "${winner.username} is playing a drinking game and was selected by the names wheel.\n"
            "Discover our drinking game app here: bit.ly/our_link(not-working)\n"
            "xoxo",
        widget: Text('Was selected by the names wheel. So lucky!'));
  }
}

class MostLikelyToPost extends StatelessWidget {
  final UserClass winner;
  final String sentence;

  const MostLikelyToPost(
      {super.key, required this.winner, required this.sentence});

  @override
  Widget build(BuildContext context) {
    return GenericCard(player: winner, sharedText: "${winner.username} is playing a drinking game and was voted as the ${sentence.substring(7).replaceAll('?', '.')}\n"
        "Discover our drinking game app here: bit.ly/our_link(not-working)\n"
        "xoxo", widget: Text('Voted as the ${sentence.substring(7).replaceAll('?', '.')}'));

  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final List<UserClass> playersInPhoto;
  final String photoQuestionText;

  const DisplayPictureScreen(
      {super.key, required this.imagePath, required this.playersInPhoto, required this.photoQuestionText});

  @override
  Widget build(BuildContext context) {
    var widget = Column(children: [
      Text(photoQuestionText),
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
        for(int i = 0 ; i < playersInPhoto.length ; i++)
          Text(playersInPhoto[i].username + ", "),
        SizedBox(
          width: 5,
        ),
        Text("caption"),
      ])
    ]);
    return GenericCard(
        player: playersInPhoto.first,
        sharedText:
            "${playersInPhoto.first.username} is playing a drinking game and wanted to share this moment with you!\n"
            "Discover our drinking game app here: bit.ly/our_link(not-working)\n"
            "xoxo",
        widget: widget, photoPath: imagePath);
  }
}

class GenericCard extends StatelessWidget {
  final UserClass player;
  final String sharedText;
  final Widget widget;
  final String? photoPath;

  const GenericCard(
      {super.key,
      required this.player,
      required this.sharedText,
      required this.widget,
      this.photoPath});

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
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: player.photoPath.contains('avatar') ? AssetImage(player.photoPath) : Image.file(File(player.photoPath)).image,
                      fit: BoxFit.fill,
                    ),
                    shape: BoxShape.circle,
                    //border: Border.all(color: Colors.yellow.shade700, width: 3),
                    color: Colors.yellow.shade700,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  player.username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ]),
              IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  onPressed: () async {
                    if (photoPath != null) {
                      await Share.shareFiles([photoPath!],
                          text: sharedText, subject: "Drinking App Moment");
                    } else {
                      await Share.share(sharedText,
                          subject: "Drinking App Moment");
                    }
                  },
                  icon: Icon(Icons.share_outlined))
            ]),
            SizedBox(height: 10),
            widget
          ],
        ),
      ),
    );
  }
}
