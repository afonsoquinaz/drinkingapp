import 'package:flutter/material.dart';

class Question {
  String type;
  Widget widget;
  int nbrGlasses;

  Question({
    required this.type,
    required this.widget,
    required this.nbrGlasses,
  });
}