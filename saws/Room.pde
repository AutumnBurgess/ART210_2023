class Room
{
  SawType[] startSaws;
  SawType[] spawnPattern;
  int[] waitPattern;
  
  int currentSpawn = 0;  
  int timer = 0;
  int startTime = 0;
  
  Player player;
  ArrayList<Saw> saws = new ArrayList<Saw>();
  ArrayList<Saw> sawsToAdd = new ArrayList<Saw>();
  ArrayList<SawSpawner> spawners = new ArrayList<SawSpawner>();
  int nextSawTime;
  
  Room(SawType[] start, SawType[] spawn, int[] waits)
  {
    this.startSaws = start;
    this.spawnPattern = spawn;
    this.waitPattern = waits;
    
    this.player = new Player(-1, this);
    for(int i = 0; i < startSaws.length; i++)
    {
      Saw newSaw;
      float dist;
      do
      {
        newSaw = SAW_BUILDERS.get(this.startSaws[i]).build(i, this);
        dist = PVector.sub(newSaw.location, this.player.location).mag();
      }
      while(dist < 50 + newSaw.w);
      
      this.saws.add(newSaw);
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
    if(sawsToAdd.size() > 0)
    {
      this.saws.addAll(sawsToAdd);
      sawsToAdd.clear();
      this.saws.sort(Comparator.comparing(Saw::getRotSpeed));
    }
    
    
    this.timer = millis() - this.startTime;
    fill(0);
    textFont(fontSmall);
    textAlign(LEFT);
    text(millisAsTimer(timer), 10, 30);
    
    this.newSaws();
  }
  
  void over()
  {
    this.player.display();
    Collections.reverse(this.saws);
    for(Saw s : this.saws)
    {
      s.display();
      s.update();
    }
    Collections.reverse(this.saws);
    this.saws.addAll(sawsToAdd);
    sawsToAdd.clear();
    
  }
  
  void newSaws()
  {
    if(timer >= nextSawTime)
    {
      this.addSpawner(SAW_BUILDERS.get(this.spawnPattern[currentSpawn]).build(this.saws.size(), this));
      this.currentSpawn = (this.currentSpawn + 1) % this.spawnPattern.length;
      this.setNextSaw();
    }
  }
  
  void setNextSaw()
  {
    this.nextSawTime += waitPattern[this.currentSpawn];
  }
    
  void addSpawner(Saw toSpawn)
  {
    SawSpawner spawn = new SawSpawner(spawners.size(), toSpawn, this);
    this.spawners.add(spawn);
  }
  
  void addSaw(Saw toAdd)
  {
    this.sawsToAdd.add(toAdd);
  }
}
