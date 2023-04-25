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
  player = new Player(-1);
  saws.clear();
  for(int i = 0; i < slowSaws; i++)
  {
    saws.add(sawFromType(SawType.SLOW, i));
  }
  for(int i = slowSaws; i < fastSaws + slowSaws; i++)
  {
    saws.add(sawFromType(SawType.FAST, i));
  }
  saws.add(sawFromType(SawType.TOPWALL, fastSaws + slowSaws));
  saws.add(sawFromType(SawType.BOTTOMWALL, fastSaws + slowSaws + 1));
}
