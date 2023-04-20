void running()
{
  player.display();
  player.update();
  player.check();
  for(Saw s : saws)
  {
    s.display();
    s.update();
    s.check();
  }
  audio.update();
  timer = millis() - startTime;
  fill(0);
  textFont(fontSmall);
  textAlign(LEFT);
  text(millisAsTimer(timer), 10, 30);
}

void init_running()
{
  startTime = millis();
}
