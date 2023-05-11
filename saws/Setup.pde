void createRooms()
{
  Room toAdd = new Room();
  toAdd.startSaws = new SawType[]   {SawType.SLOW, SawType.SLOW, SawType.FAST, SawType.FAST};
  toAdd.spawnPattern = new SawType[]{SawType.FAST, SawType.SLOW, SawType.FAST};
  toAdd.waitPattern = new int[]    {5000        , 5000        , 10000};
  toAdd.name = "welcome";
  toAdd.devTime = 70000;
  toAdd.init();
  rooms.add(toAdd);
  
  toAdd = new Room();
  toAdd.startSaws = new SawType[]   {SawType.STICKY, SawType.STICKY, SawType.STICKY};
  toAdd.spawnPattern = new SawType[]{SawType.STICKY};
  toAdd.waitPattern = new int[]    {10000};
  toAdd.name = "pay attention";
  toAdd.devTime = 19000;
  toAdd.init();
  rooms.add(toAdd);
  
  toAdd = new Room();
  toAdd.startSaws = new SawType[]   {SawType.CHASER, SawType.TOPWALL, SawType.BOTTOMWALL};
  toAdd.spawnPattern = new SawType[]{SawType.CHASER, SawType.STICKY, SawType.SLOW};
  toAdd.waitPattern = new int[]    {5000,         5000,           8000};
  toAdd.name = "coming to get you";
  toAdd.devTime = 33000;
  toAdd.init();
  rooms.add(toAdd);

  toAdd = new Room();
  toAdd.startSaws = new SawType[]   {SawType.DROPPER, SawType.TOPWALL, SawType.BOTTOMWALL, SawType.LEFTWALL, SawType.RIGHTWALL};
  toAdd.spawnPattern = new SawType[]{SawType.SLOW, SawType.DROPPER};
  toAdd.waitPattern = new int[]    {5000,       5000};
  toAdd.name = "trails";
  toAdd.devTime = 76000;
  toAdd.init();
  rooms.add(toAdd);
  
  toAdd = new Room();
  toAdd.startSaws = new SawType[]   {SawType.SLOW, SawType.DROPPER, SawType.CHASER, SawType.TOPWALL, SawType.BOTTOMWALL};
  toAdd.spawnPattern = new SawType[]{SawType.FAST, SawType.STICKY, SawType.SLOW, SawType.CHASER, SawType.DROPPER};
  toAdd.waitPattern = new int[]    {8000        , 8000        , 8000          , 8000,        8000};
  toAdd.name = "kitchen sink";
  toAdd.devTime = 4500;
  toAdd.init();
  rooms.add(toAdd);
  
  toAdd = new Room();
  toAdd.startSaws = new SawType[]   {SawType.MIDDLE};
  toAdd.spawnPattern = new SawType[]{SawType.MIDDLE};
  toAdd.waitPattern = new int[]    {1000000000};
  toAdd.name = "???";
  toAdd.devTime = 100000000;
  toAdd.init();
  rooms.add(toAdd);
  
  for (Room r : rooms)
  {
    roomsWon.add(false);
  }
}

void createSounds()
{
  //PApplet app_, boolean io_, float at_, float st_, float sl_, float rt_
  SoundEffect hit = new SoundEffect(this, false, 0.01, 0.08, 0.15, 0.2);
  audio.addEffect(hit, "hit");
  SoundEffect win = new SoundEffect(this, true, 0.01, 0.004, 0.3, 0.4);
  audio.addEffect(win, "win");
  //audio.addMusic("song.mp3", "song");
}

void createShapes()
{
  RArrow = createShape();
  RArrow.beginShape();
  RArrow.vertex(0, 0);
  RArrow.vertex(-20, -40);
  RArrow.vertex(10, -40);
  RArrow.vertex(30, 0);
  RArrow.vertex(10, 40);
  RArrow.vertex(-20, 40);
  RArrow.vertex(0, 0);
  RArrow.strokeWeight(2);
  RArrow.endShape();
  RArrow.setFill(color(0, 180, 0));
  
  LArrow = createShape();
  LArrow.beginShape();
  LArrow.vertex(0, 0);
  LArrow.vertex(20, -40);
  LArrow.vertex(-10, -40);
  LArrow.vertex(-30, 0);
  LArrow.vertex(-10, 40);
  LArrow.vertex(20, 40);
  LArrow.vertex(0, 0);
  LArrow.strokeWeight(2);
  LArrow.endShape();
  LArrow.setFill(color(0, 180, 0));
  
  Star = createShape();
  Star.beginShape();
  float outSize = 30;
  float inSize = 15;
  Star.vertex(sin(  TWO_PI/10) * outSize, cos(  TWO_PI/10) * outSize);
  Star.vertex(sin(2*TWO_PI/10) * inSize, cos(2*TWO_PI/10) * inSize);
  Star.vertex(sin(3*TWO_PI/10) * outSize, cos(3*TWO_PI/10) * outSize);
  Star.vertex(sin(4*TWO_PI/10) * inSize, cos(4*TWO_PI/10) * inSize);
  Star.vertex(sin(5*TWO_PI/10) * outSize, cos(5*TWO_PI/10) * outSize);
  Star.vertex(sin(6*TWO_PI/10) * inSize, cos(6*TWO_PI/10) * inSize);
  Star.vertex(sin(7*TWO_PI/10) * outSize, cos(7*TWO_PI/10) * outSize);
  Star.vertex(sin(8*TWO_PI/10) * inSize, cos(8*TWO_PI/10) * inSize);
  Star.vertex(sin(9*TWO_PI/10) * outSize, cos(9*TWO_PI/10) * outSize);
  Star.vertex(sin(10*TWO_PI/10) * inSize, cos(10*TWO_PI/10) * inSize);
  Star.vertex(sin(  TWO_PI/10) * outSize, cos(  TWO_PI/10) * outSize);
  Star.strokeWeight(2);
  Star.endShape();
  Star.setFill(color(245, 239, 56));
  
  UArrow = createShape();
  UArrow.beginShape();
  UArrow.vertex(0, 0);
  UArrow.vertex(-40, 20);
  UArrow.vertex(-40, -10);
  UArrow.vertex(0, -30);
  UArrow.vertex(40, -10);
  UArrow.vertex(40, 20);
  UArrow.vertex(0, 0);
  UArrow.strokeWeight(2);
  UArrow.endShape();
  UArrow.setFill(color(210));
  
  DArrow = createShape();
  DArrow.beginShape();
  DArrow.vertex(0, 0);
  DArrow.vertex(-40, -20);
  DArrow.vertex(-40, 10);
  DArrow.vertex(0, 30);
  DArrow.vertex(40, 10);
  DArrow.vertex(40, -20);
  DArrow.vertex(0, 0);
  DArrow.strokeWeight(2);
  DArrow.endShape();
  DArrow.setFill(color(80, 80, 95));
}
