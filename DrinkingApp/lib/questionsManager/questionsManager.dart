import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:flutter/material.dart';
class questionsManager {


  questionsManager(){

  }

  Widget getWidgetForQuestion(){
    return getNewQuestion();
  }

  Text getNewQuestion(){
    return Text(lorem(paragraphs: 1, words: 10));
  }



}