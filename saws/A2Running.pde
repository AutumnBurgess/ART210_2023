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
    addSpawner(SAW_BUILDERS.get(spawnPattern[currentSpawn]).build(saws.size()));
    currentSpawn = (currentSpawn + 1) % spawnPattern.length;
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
