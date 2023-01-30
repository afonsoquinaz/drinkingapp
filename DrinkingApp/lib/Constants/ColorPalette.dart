import 'dart:ui';

Color getColorForGameType(String gameType){
  if(gameType == "Photo Time")
    return Color(0xFFe66e39);
    //return(Color.fromARGB(255, 209, 60, 93));
  else if(gameType == "Normal Challenge")
    return(Color.fromARGB(255, 244, 201, 100));
  else if(gameType == "Most Likely To")
    return(Color.fromARGB(255, 83, 204, 147));
  else if(gameType == "1 vs 1")//
    return Color(0xFFA2021F);
    //return(Color.fromARGB(255, 50, 117, 167));
  else if(gameType == "Fortune Wheel")
    return(Color.fromARGB(255, 30, 30, 30));
  else if(gameType == "Roulette Wheel")
    return(Color(0xFFF7ECE1));
  else if(gameType == "Draw Challenge")
    return(Color(0xFF7DE2D1));
  else if(gameType == "Challanges Wheel")
    return(Color(0xFF19535F));

  return(Color.fromARGB(255, 83, 204, 147));
}

Color getTextColorForGameType(String gameType){
  if(gameType == "Fortune Wheel" || gameType == "1 vs 1" || gameType == "Challanges Wheel")
    return(Color.fromARGB(255, 255, 255, 255));
  else
    return(Color.fromARGB(255, 0, 0, 0));
}