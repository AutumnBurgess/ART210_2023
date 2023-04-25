Saw sawFromType(SawType type, int id)
{
  switch(type)
  {
    default:
    case FAST:
      return new SawFast(id);
    case SLOW:
      return new SawSlow(id);
    case TOPWALL:
      return new SawTop(id);
    case BOTTOMWALL:
      return new SawBottom(id);
  }
}

class SawFast extends Saw
{
  SawFast(int _id)
  {
    super(_id, new SawShape(SawType.FAST));
    this.velocity = PVector.random2D().mult(5);
    this.rotSpeed = 3;
  }
  
  void update()
  {
    super.update();
    super.bounceOnBounds();
  }
}

class SawSlow extends Saw
{
  SawSlow(int _id)
  {
    super(_id, new SawShape(SawType.SLOW));
    this.velocity = PVector.random2D().mult(2);
  }
  
  void update()
  {
    super.update();
    super.bounceOnBounds();
  }
}

class SawTop extends SawWall
{
  SawTop(int id)
  {
    super(id);
    this.location.x = width/2;
    this.location.y = 0;
  }
}

class SawBottom extends SawWall
{
  SawBottom(int id)
  {
    super(id);
    this.location.x = width/2;
    this.location.y = height;
  }
}

class SawWall extends Saw
{
  SawWall(int _id)
  {
    super(_id, new SawShape(SawType.TOPWALL));
    this.rotSpeed = 5;
  }
  
  void update()
  {
    int speed = 8;
    this.location.x = constrain(this.location.x, 0, width);
    this.location.y = constrain(this.location.y, 0, height);
    boolean onLeft = this.location.x == 0;
    boolean onRight = this.location.x == width;
    boolean onTop = this.location.y == 0;
    boolean onBottom = this.location.y == height;
    
    if(onLeft && !onTop)
    {
      this.velocity.x = 0;
      this.velocity.y = -speed;
    }
    if(onTop && !onRight)
    {
      this.velocity.x = speed;
      this.velocity.y = 0;
    }
    if(onRight && !onBottom)
    {
      this.velocity.x = 0;
      this.velocity.y = speed;
    }
    if(onBottom && !onLeft)
    {
      this.velocity.x = -speed;
      this.velocity.y = 0;
    }
    
    super.update();
    
  }
}
