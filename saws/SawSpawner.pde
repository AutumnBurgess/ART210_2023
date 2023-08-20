class SawSpawner extends Sprite
{
  Saw toSpawn;
  Room room;
  int frame = 0;
  boolean done = false;
  
  void display()
  {
    if(!this.done && floor(this.frame/20) % 2 == 0)
    {
      super.display();
    }
  }
  
  void update()
  {
    this.frame++;
    if(this.frame == 100)
    {
      this.done = true;
      room.addSaw(this.toSpawn);
      this.done = true;
    }
  }
}
