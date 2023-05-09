class RoomBuilder
{
  String name;
  SawType[] startSaws;
  SawType[] spawnPattern;
  int[] waitPattern;
  
  Room build()
  {
    Room room = new Room();
    room.startSaws = this.startSaws;
    room.spawnPattern = this.spawnPattern;
    room.waitPattern = this.waitPattern;
    room.init();
    return room;
  }
}

class Room
{
  SawType[] startSaws;
  SawType[] spawnPattern;
  int[] waitPattern;
  String name;

  int currentSpawn = 0;
  int timer = 0;
  int startTime = 0;

  Player player;
  ArrayList<Saw> saws = new ArrayList<Saw>();
  ArrayList<Saw> sawsToAdd = new ArrayList<Saw>();
  ArrayList<SawSpawner> spawners = new ArrayList<SawSpawner>();
  int nextSawTime;

  ParticleSpawner confetti;
  
  Room(){}
  
  void init()
  {
    this.player = new Player(this);
    this.saws.clear();
    this.sawsToAdd.clear();
    this.spawners.clear();
    for (int i = 0; i < startSaws.length; i++)
    {
      Saw newSaw;
      float dist;
      do
      {
        newSaw = SAW_BUILDERS.get(this.startSaws[i]).build(this);
        dist = PVector.sub(newSaw.location, this.player.location).mag();
      }
      while (dist < 50 + newSaw.w);

      this.saws.add(newSaw);
    }
    this.saws.sort(Comparator.comparing(Saw::getDisplayOrder));
  }

  void begin()
  {
    this.nextSawTime = 0;
    this.setNextSaw();
    this.startTime = millis();
  }

  void waiting()
  {
    this.player.display();
    for (Saw s : this.saws)
    {
      s.display();
    }
    if (useKey(" "))
    {
      this.begin();
    }
  }

  void running()
  {
    this.player.display();
    this.player.update();
    for (Saw s : this.saws)
    {
      s.display();
      s.update();
    }
    for (SawSpawner s : this.spawners)
    {
      if (!s.done)
      {
        s.display();
        s.update();
      }
    }
    if (sawsToAdd.size() > 0)
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
    this.confetti = new ParticleSpawner(new PVector(this.player.location.x, this.player.location.y), deathAngle);
  }

  void game_over()
  {
    confetti.update();
    confetti.display();
    this.player.display();
    this.player.update();
    for (Saw s : this.saws)
    {
      s.display();
      s.update();
    }
    this.saws.addAll(sawsToAdd);
    sawsToAdd.clear();
  }

  void newSaws()
  {
    if (timer >= nextSawTime)
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
