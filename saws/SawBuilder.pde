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
  private static final float boringRange = 30;
  private int displayOrder = 0;
  private float moveSpeed;
  private float rotSpeed;
  private PVector location = new PVector(width/2, height/2);
  private PVector velocity = new PVector(0,0);
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
           .setRotSpeed(1.5)
           .randVelocity()
           .randLocation()
           .setDisplayOrder(2);
        break;
      case FAST:
        this.setShape(SawShape.SMALL)
           .setBehavior(SawBehavior.BOUNCE)
           .setMoveSpeed(5)
           .setRotSpeed(3)
           .randVelocity()
           .randLocation()
           .setDisplayOrder(3);
        break;
      case STICKY:
        this.setShape(SawShape.GREEN)
           .setBehavior(SawBehavior.STICK)
           .setMoveSpeed(15)
           .setRotSpeed(5)
           .randVelocity()
           .setVelocity(new PVector(-5, -5))
           .randLocation()
           .setDisplayOrder(5);
        break;
      case TOPWALL:
        this.setShape(SawShape.WALL)
           .setBehavior(SawBehavior.WALL)
           .setMoveSpeed(8)
           .setRotSpeed(6)
           .setVelocity(new PVector(8, 0))
           .setLoc(new PVector(width/2, 0))
           .setDisplayOrder(1);
        break;
      case BOTTOMWALL:
        this.setShape(SawShape.WALL)
           .setBehavior(SawBehavior.WALL)
           .setMoveSpeed(8)
           .setRotSpeed(6)
           .setVelocity(new PVector(-8, 0))
           .setLoc(new PVector(width/2, height))
           .setDisplayOrder(1);
        break;
      case DROPPED:
        this.setShape(SawShape.DROPPED)
           .setBehavior(SawBehavior.DISAPPEAR)
           .setMoveSpeed(0)
           .setRotSpeed(2)
           .setDisplayOrder(0);
        break;
      case DROPPER:
        this.setShape(SawShape.DROPPER)
           .setBehavior(SawBehavior.DROP)
           .setMoveSpeed(3)
           .setRotSpeed(3)
           .randVelocity()
           .randLocation()
           .setDisplayOrder(4);
        break;
    }
  }
  
  Saw build(int id, Room room)
  {
    Saw out = new Saw(id, this.shape, room);
    out.moveSpeed = this.moveSpeed;
    out.displayOrder = this.displayOrder;
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
      out.velocity = this.velocity.copy();
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
      out.location = this.location.copy();
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
  SawBuilder setDisplayOrder(int order)
  {
    this.displayOrder = order;
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
