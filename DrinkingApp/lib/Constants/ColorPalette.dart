import 'dart:ui';

Color getColorForGameType(String gameType){
  if(gameType == "Photo Time")
    return(Color.fromARGB(255, 209, 60, 93));
  else if(gameType == "Normal Challenge")
    return(Color.fromARGB(255, 244, 201, 100));
  else if(gameType == "Most Likely To")
    return(Color.fromARGB(255, 83, 204, 147));
  else if(gameType == "1 vs 1")
    return(Color.fromARGB(255, 50, 117, 167));
  else if(gameType == "Fortune Wheel")
    return(Color.fromARGB(255, 223, 88, 45));

  return(Color.fromARGB(255, 83, 204, 147));
}