
String getTextForGameType(String gameType){
  if(gameType == "Photo Time")
    return "If you run out of time, drink";
  //return(Color.fromARGB(255, 209, 60, 93));
  else if(gameType == "Normal Challenge")
    return "The chosen ones drink";
  else if(gameType == "Most Likely To")
    return "The most voted one(s) drink";
  else if(gameType == "1 vs 1")//
    return "The looser drinks";
  //return(Color.fromARGB(255, 50, 117, 167));
  else if(gameType == "Fortune Wheel")
    return "The winner drinks";
  else if(gameType == "Draw Challenge")
    return "If no one guesses in time, all drink\nOtherwise, no one drinks";

  return "The winner drinks";
}
