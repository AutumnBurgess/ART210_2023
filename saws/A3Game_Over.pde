void game_over()
{
  fill(0);
  textFont(fontLarge);
  textAlign(CENTER);
  text("you survived " + millisAsTimer(timer) + "\npress r to restart", width/2, height/2);
  if(keyHeld("r") > 0)
  {
    setGameState(WAITING);
  }
}

void init_game_over()
{
  
}
