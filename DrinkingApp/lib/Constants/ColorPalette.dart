int getColorForGameType(String gameType){
  if(gameType == "Photo Time")
    return(123778013);
  else if(gameType == "Normal Challenge")
    return(5491603);
  else if(gameType == "Most Likely To")
    return(15580983);
  else if(gameType == "1 vs 1")
    return(14637100);
  else if(gameType == "Fortune Wheel")
    return(4230011);

  return(0xffb0e3df);
}