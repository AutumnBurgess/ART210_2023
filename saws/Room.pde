class Room
{
  SawType[] startSaws;
  SawType[] spawnPattern;
  
  int currentSpawn = 0;  
  int timer = 0;
  int startTime = 0;
  
  Player player;
  ArrayList<Saw> saws = new ArrayList<Saw>();
  ArrayList<SawSpawner> spawners = new ArrayList<SawSpawner>();
  int nextSawTime;
  
  Room(SawType[] start, SawType[] spawn)
  {
    this.startSaws = start;
    this.spawnPattern = spawn;
    
    this.player = new Player(-1);
    for(int i = 0; i < startSaws.length; i++)
    {
      this.saws.add(SAW_BUILDERS.get(this.startSaws[i]).build(i));
    }
  }
  
  void begin()
  {
    setGameState(RUNNING);
    this.nextSawTime = 0;
    this.setNextSaw();
    this.startTime = millis();
  }
  
  void waiting()
  {
    this.player.display();
    for(Saw s : this.saws)
    {
      s.display();
    }
    fill(0);
    textFont(fontLarge);
    textAlign(CENTER);
    text("press space to start", width/2, height/2);
    if(keyHeld(" ") > 0)
    {
      this.begin();
    }
  }
  
  void running()
  {
    this.player.display();
    this.player.update();
    for(Saw s : this.saws)
    {
      s.display();
      s.update();
    }
    
    for(SawSpawner s : this.spawners)
    {
      if(!s.done)
      {
        s.display();
        s.update();
      }
    }
    this.timer = millis() - this.startTime;
    fill(0);
    textFont(fontSmall);
    textAlign(LEFT);
    text(millisAsTimer(timer), 10, 30);
    
    this.newSaws();
  }
  
  void newSaws()
  {
    if(timer >= nextSawTime)
    {
      this.addSpawner(SAW_BUILDERS.get(this.spawnPattern[currentSpawn]).build(this.saws.size()));
      this.currentSpawn = (this.currentSpawn + 1) % this.spawnPattern.length;
      this.setNextSaw();
    }
  }
  
  void setNextSaw()
  {
    this.nextSawTime += 5000;//floor(random(5000, 7000));
  }
    
  void addSpawner(Saw toSpawn)
  {
    SawSpawner spawn = new SawSpawner(spawners.size(), toSpawn);
    this.spawners.add(spawn);
  }
  
  void addSaw(Saw toAdd)
  {
    this.saws.add(toAdd);
  }
}
