import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'dart:math';
import 'package:flutter/services.dart' as rootBundle;
import 'package:drinkingapp/questionsManager/NamesWheel.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:flutter/material.dart';
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

  void addPhoto(String photoPath) {
    feed.add(DisplayPictureScreen(imagePath: photoPath));
    // feed.add(Row(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     Container(
    //       height: 300,
    //       width: 500,
    //       child: FittedBox(
    //         fit: BoxFit.fitWidth,
    //         child: Image.file(File(photoPath)),
    //       )
    //
    //     )
    //   ],
    // )
    // );
  }

  addNamesWheelPost(String winner) {
    feed.add(Card(
      child: Container(
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text("Spinning Weel winner: " + winner)),
      ),
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
    ));
  }

  addOneVsOnePost(String player1, String player2, String winner) {
    feed.add(Card(
      child: Container(
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(player1 + " VS " + player2),
                Text("Winner :" + winner),
              ],
            )),
      ),
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
    ));
  }

  addMostLikelyToPost(String mltLevel, String winner) {
    feed.add(Card(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [Text(mltLevel), Text("Winner : " + winner)],
          ),
        ),
      ),
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
    ));
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Card(
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
              Row(children: [
                Icon(Icons.account_circle),
                SizedBox(width: 10),
                Container(
                    child: Text(
                  "username",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )),
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
              Row(
                children: [
                  Icon(Icons.favorite_border),
                  SizedBox(width: 5),
                  Icon(Icons.share_outlined),

                ],
              ),
              SizedBox(height: 5),
              Text('x likes'),
              Row(children: [
                Text(
                  "username",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 5,),
                Text("caption"),
              ])
            ],
          )),
    ));
  }
}
