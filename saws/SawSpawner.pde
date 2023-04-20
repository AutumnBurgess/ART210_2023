class SawSpawner extends Sprite
{
  Saw toSpawn;
  PShape sawShape;
  int frame = 0;
  
  SawSpawner(String id, Saw toSpawn_, PShape sawShape)
  {
    super(id);
    this.toSpawn = toSpawn_;
    Animation anim = new Animation(makeAnimation(sawShape));
    this.registerAnimation(anim);
  }
  
  void display()
  {
    if(this.frame < 60)
    {
      tint(255,128);
      super.display();
      noTint();
    }
  }
  
  void update()
  {
    this.frame++;
    if(this.frame == 60)
    {
      
    }
  }
  
  private PShape[] makeAnimation(PShape sawShape)
  {
    PShape[] anim = new PShape[60];
    for(int i = 0; i < 10; i++)
    {
      anim[i] = sawShape;
    }
    for(int i = 20; i < 30; i++)
    {
      anim[i] = sawShape;
    }
    for(int i = 40; i < 50; i++)
    {
      anim[i] = sawShape;
    }
    return anim;
  }
}
