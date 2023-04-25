int nextSawTime;

void running()
{
  player.display();
  player.update();
  for(Saw s : saws)
  {
    s.display();
    s.update();
  }
  
  for(SawSpawner s : spawners)
  {
    if(!s.done)
    {
      s.display();
      s.update();
    }
  }
  audio.update();
  timer = millis() - startTime;
  fill(0);
  textFont(fontSmall);
  textAlign(LEFT);
  text(millisAsTimer(timer), 10, 30);
  
  newSaws();
}

void newSaws()
{
  if(timer >= nextSawTime)
  {
    if(random(0,1) < 0.5)
    {
      addSpawner(new SawFast(saws.size()));
    }
    else
    {
      addSpawner(new SawSlow(saws.size()));
    }
    setNextSaw();
  }
}

void setNextSaw()
{
  nextSawTime += 5000;//floor(random(5000, 7000));
}

void init_running()
{
  nextSawTime = 0;
  setNextSaw();
  startTime = millis();
}
