class SawSpawner extends Sprite
{
  Saw toSpawn;
  SawShape myShape;
  Room room;
  int frame = 0;
  boolean done = false;
  
  SawSpawner(int id, Saw toSpawn_, Room r)
  {
    super(id);
    this.toSpawn = toSpawn_;
    this.myShape = this.toSpawn.myShape.clone();
    this.myShape.transparent = true;
    this.room = r;
    float offset = this.toSpawn.w;
    this.offset = new PVector(offset, offset);
    this.registerAnimation(new Animation(this.myShape.make()));
    this.location = toSpawn.location;
  }
  
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
