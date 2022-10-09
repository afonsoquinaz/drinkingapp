import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:flutter/material.dart';
class questionsManager {


  questionsManager(){

  }

  String getNewQuestion(){
    return lorem(paragraphs: 1, words: 10);
  }

  Widget getWidgetForQuestion(){
  return Text("data");
  }


}