import 'package:flutter_lorem/flutter_lorem.dart';

class questionsManager {


  questionsManager(){

  }

  String getNewQuestion(){
    return lorem(paragraphs: 1, words: 10);
  }


}