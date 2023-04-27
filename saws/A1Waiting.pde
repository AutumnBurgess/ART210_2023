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
  for(int i = 0; i < startSaws.length; i++)
  {
    saws.add(SAW_BUILDERS.get(startSaws[i]).build(i));
  }
}
