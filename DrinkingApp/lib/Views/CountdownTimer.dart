import 'dart:async';

import 'package:flutter/material.dart';

class CountdownTimer extends StatelessWidget {
  final Duration myDuration;

  const CountdownTimer({super.key, required this.myDuration});

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));
    return Text(
      '$minutes:$seconds',
      style: TextStyle(
          fontWeight: FontWeight.bold,
          color: (myDuration.inMinutes.remainder(60) < 1 &&
              myDuration.inSeconds.remainder(60) <= 30)
              ? Colors.red
              : Colors.white,
          fontSize: 50),
    );
  }
}