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
  
  ArrayList<Particle> confetti = new ArrayList<Particle>();
  
  Room(SawType[] start, SawType[] spawn, int[] waits)
  {
    this.startSaws = start;
    this.spawnPattern = spawn;
    this.waitPattern = waits;
    
    this.player = new Player(this);
    for(int i = 0; i < startSaws.length; i++)
    {
      Saw newSaw;
      float dist;
      do
      {
        newSaw = SAW_BUILDERS.get(this.startSaws[i]).build(this);
        dist = PVector.sub(newSaw.location, this.player.location).mag();
      }
      while(dist < 50 + newSaw.w);
      
      this.saws.add(newSaw);
    }
    this.saws.sort(Comparator.comparing(Saw::getDisplayOrder));
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
      this.saws.sort(Comparator.comparing(Saw::getDisplayOrder));
    }
    
    this.timer = millis() - this.startTime;
    fill(0);
    textFont(fontSmall);
    textAlign(LEFT);
    text(millisAsTimer(timer), 10, 30);
    
    this.newSaws();
  }
  
  void init_game_over(float deathAngle)
  {
    int directCount = 60;
    int spreadCount = 25;
    float directRange = PI/4;
    float spreadRange = PI/3;
    
    for (int i = 0; i < directCount; i++)
    {
      Particle newConf = new Particle();
      newConf.location.x = this.player.location.x;
      newConf.location.y = this.player.location.y;
      newConf.velocity = new PVector(random(4,20), 0);
      newConf.velocity.rotate(deathAngle);
      newConf.velocity.rotate(random(-directRange,directRange));
      newConf.spinSpeed = random(-5, 5);
      newConf.rotation = random(360);
      this.confetti.add(newConf);
    }
    for (int i = 0; i < spreadCount; i++)
    {
      Particle newConf = new Particle();
      newConf.location.x = this.player.location.x;
      newConf.location.y = this.player.location.y;
      newConf.velocity = new PVector(random(4,20), 0);
      newConf.velocity.rotate(deathAngle);
      newConf.velocity.rotate(random(-spreadRange,spreadRange));
      newConf.spinSpeed = random(-5, 5);
      newConf.rotation = random(360);
      this.confetti.add(newConf);
    }
  }
  
  void game_over()
  {
    for(Particle p : confetti)
    {
      p.update();
      p.display();
    }
    this.player.display();
    this.player.update();
    for(Saw s : this.saws)
    {
      s.display();
      s.update();
    }
    this.saws.addAll(sawsToAdd);
    sawsToAdd.clear();
    
  }
  
  void newSaws()
  {
    if(timer >= nextSawTime)
    {
      this.addSpawner(SAW_BUILDERS.get(this.spawnPattern[currentSpawn]).build(this));
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
    SawSpawner spawn = new SawSpawner(toSpawn, this);
    this.spawners.add(spawn);
  }
  
  void addSaw(Saw toAdd)
  {
    this.sawsToAdd.add(toAdd);
  }
}
