void waiting()
{
  player.display();
  for(Saw s : saws)
  {
    s.display();
  }
  fill(0);
  textFont(fontLarge);
  textAlign(CENTER);
  text("press space to start", width/2, height/2);
  if(keyHeld(" ") > 0)
  {
    setGameState(RUNNING);
  }
}

void init_waiting()
{
  player = new Player("player");
  for(int i = 0; i < slowSaws; i++)
  {
    saws[i] = new SawSlow("saw" + str(i));
  }
  for(int i = slowSaws; i < fastSaws + slowSaws; i++)
  {
    saws[i] = new SawFast("saw" + str(i));
  }
}
