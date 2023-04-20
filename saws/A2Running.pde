void running()
{
  player.display();
  player.update();
  for(Saw s : saws)
  {
    s.display();
    s.update();
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
