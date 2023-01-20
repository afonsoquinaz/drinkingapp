import 'package:flutter/material.dart';

class Question {
  String type;
  Widget widget;
  Function? complete;
  int nbrGlasses;

  Question({
    required this.type,
    required this.widget,
    this.complete,
    required this.nbrGlasses,
  });
}