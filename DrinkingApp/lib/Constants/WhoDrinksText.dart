
String getTextForGameType(String gameType){
  if(gameType == "Photo Time")
    return "Who drinks text photo time";
  //return(Color.fromARGB(255, 209, 60, 93));
  else if(gameType == "Normal Challenge")
    return "Who drinks text Normal Challange";
  else if(gameType == "Most Likely To")
    return "Who drinks text most likely to";
  else if(gameType == "1 vs 1")//
    return "Who drinks text most 1 vs 1";
  //return(Color.fromARGB(255, 50, 117, 167));
  else if(gameType == "Fortune Wheel")
    return "The chosen one drinks";

  return "The winner drinks";
}
