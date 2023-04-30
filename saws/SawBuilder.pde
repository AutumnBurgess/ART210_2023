Hashtable<SawType, SawBuilder> SAW_BUILDERS = new Hashtable<SawType, SawBuilder>();
void setupBuilders()
{
  for(SawType t : SawType.values())
  {
    SAW_BUILDERS.put(t, new SawBuilder(t));
  }
}

class SawBuilder
{
  private SawShape shape;
  private SawBehavior behavior;
  private static final float boringRange = 15;
  private float moveSpeed;
  private float rotSpeed;
  private PVector location;
  private PVector velocity;
  private boolean randLocation = false;
  private boolean randVelocity = false;

  SawBuilder(SawType type)
  {
    switch(type)
    {
      case SLOW:
        this.setShape(SawShape.BIG)
           .setBehavior(SawBehavior.BOUNCE)
           .setMoveSpeed(2)
           .setRotSpeed(3)
           .randVelocity()
           .randLocation();
        break;
      case FAST:
        this.setShape(SawShape.SMALL)
           .setBehavior(SawBehavior.BOUNCE)
           .setMoveSpeed(5)
           .setRotSpeed(1.5)
           .randVelocity()
           .randLocation();
        break;
      case STICKY:
        this.setShape(SawShape.GREEN)
           .setBehavior(SawBehavior.STICK)
           .setMoveSpeed(15)
           .setRotSpeed(5)
           .randVelocity()
           .setVelocity(new PVector(-5, -5))
           .randLocation();
        break;
      case TOPWALL:
        this.setShape(SawShape.WALL)
           .setBehavior(SawBehavior.WALL)
           .setMoveSpeed(8)
           .setRotSpeed(6)
           .setVelocity(new PVector(8, 0))
           .setLoc(new PVector(width/2, 0));
        break;
      case BOTTOMWALL:
        this.setShape(SawShape.WALL)
           .setBehavior(SawBehavior.WALL)
           .setMoveSpeed(8)
           .setRotSpeed(6)
           .setVelocity(new PVector(-8, 0))
           .setLoc(new PVector(width/2, height));
        break;
    }
  }
  
  Saw build(int id)
  {
    Saw out = new Saw(id, this.shape);
    out.moveSpeed = this.moveSpeed;
    if(this.randVelocity) 
    {
      do
      {
        out.velocity = PVector.random2D().mult(out.moveSpeed);
      }
      while(this.inBoringAngle(out.velocity));
    }
    else
    {
      out.velocity.x = this.velocity.x;
      out.velocity.y = this.velocity.y;
    }
    out.rotSpeed = this.rotSpeed;
    out.behavior = this.behavior;
    if(this.randLocation)
    {
      out.location.x = random(out.w+50, width-out.w);
      out.location.y = random(out.w, width-out.w);
    }
    else
    {
      out.location.x = this.location.x;
      out.location.y = this.location.y;
    }
    return out;
  }
  boolean inBoringAngle(PVector v)
  {
    float angle = degrees(v.heading());
    if(angle < boringRange) return false;
    if(angle > 90 - boringRange && angle < 90 + boringRange) return true;
    if(angle > 180 - boringRange && angle < 180 + boringRange) return true;
    if(angle > 270 - boringRange && angle < 270 + boringRange) return true;
    if(angle > 360 - boringRange) return true;
    return false;
  }
  
  SawBuilder setShape(int shapeType)
  {
    this.shape = new SawShape(shapeType);
    return this;
  }
  SawBuilder setBehavior(SawBehavior b)
  {
    this.behavior = b;
    return this;
  }
  SawBuilder setMoveSpeed(float s)
  {
    this.moveSpeed = s;
    return this;
  }
  SawBuilder setRotSpeed(float s)
  {
    this.rotSpeed = s;
    return this;
  }
  SawBuilder setLoc(PVector l)
  {
    this.location = l;
    return this;
  }
  SawBuilder randLocation()
  {
    this.randLocation = true;
    return this;
  }
  SawBuilder setVelocity(PVector v)
  {
    this.velocity = v;
    return this;
  }
  SawBuilder randVelocity()
  {
    this.randVelocity = true;
    return this;
  }
}
