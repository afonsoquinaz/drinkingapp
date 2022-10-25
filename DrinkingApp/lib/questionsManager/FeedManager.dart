import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' as rootBundle;
import 'package:drinkingapp/questionsManager/NamesWheel.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:flutter/material.dart';
import 'NamesWheel.dart';

class FeedManager {

  late List<Widget> feed;

  FeedManager(){
     feed = [];
  }

  List<Widget> getFeed(){
    return feed;
  }

  void setFeed(List<Widget> newFeed){
    feed = newFeed;
  }

  addNamesWheelPost(String winner){
    feed.add(Card(
      child: Container(
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text("Spinning Weel winner: " + winner)
        ),
      ),
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
    ));
  }


  addOneVsOnePost(String player1 , String player2, String winner){
    feed.add(Card(
      child: Container(

        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(player1 + " VS " + player2),
                Text("Winner :" + player2),
              ],
            )
        ),
      ),
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
    ));
  }

  addMostLikelyToPost(String mltLevel , String winner){
    feed.add(Card(
      child: Container(
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(mltLevel + " : " + winner)
        ),
      ),
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
    ));
  }


}