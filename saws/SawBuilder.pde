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
  ArrayList<SawBehavior> behaviors = new ArrayList<SawBehavior>();
  private static final float boringRange = 15;
  private int displayOrder = 0;
  private float moveSpeed;
  private float rotSpeed;
  private PVector location = new PVector(width/2, height/2);
  private PVector velocity = new PVector(0,0);
  private boolean randLocation = false;
  private boolean randVelocity = false;
  private SawType type;

  SawBuilder(SawType type)
  {
    this.type = type;
    switch(type)
    {
      case SLOW:
        this.shape = new SawShape(SawShape.BIG);
        this.behaviors.add(SawBehavior.BOUNCE);
        this.moveSpeed = 2;
        this.rotSpeed = 1.5;
        this.randVelocity = true;
        this.randLocation = true;
        this.displayOrder = 2;
        break;
      case FAST:
        this.shape = new SawShape(SawShape.SMALL);
        this.behaviors.add(SawBehavior.BOUNCE);
        this.moveSpeed = 5;
        this.rotSpeed = 3;
        this.randVelocity = true;
        this.randLocation = true;
        this.displayOrder = 3;
        break;
      case STICKY:
        this.shape = new SawShape(SawShape.GREEN);
        this.behaviors.add(SawBehavior.STICK);
        this.moveSpeed = 15;
        this.rotSpeed = 5;
        this.randVelocity = true;
        this.randLocation = true;
        this.displayOrder = 5;
        break;
      case TOPWALL:
        this.shape = new SawShape(SawShape.WALL);
        this.behaviors.add(SawBehavior.WALL);
        this.moveSpeed = 8;
        this.rotSpeed = 6;
        this.velocity = new PVector(8, 0);
        this.location = new PVector(width/2, 0);
        this.displayOrder = 1;
        break;
      case BOTTOMWALL:
        this.shape = new SawShape(SawShape.WALL);
        this.behaviors.add(SawBehavior.WALL);
        this.moveSpeed = 8;
        this.rotSpeed = 6;
        this.velocity = new PVector(8, 0);
        this.location = new PVector(width/2, height);
        this.displayOrder = 1;
        break;
      case DROPPED:
        this.shape = new SawShape(SawShape.DROPPED);
        this.behaviors.add(SawBehavior.DISAPPEAR);
        this.moveSpeed = 0;
        this.rotSpeed = 2;
        this.displayOrder = 0;
        break;
      case DROPPER:
        this.shape = new SawShape(SawShape.DROPPER);
        this.behaviors.add(SawBehavior.BOUNCE);
        this.behaviors.add(SawBehavior.TRAIL);
        this.moveSpeed = 3;
        this.rotSpeed = 3;
        this.randVelocity = true;
        this.randLocation = true;
        this.displayOrder = 4;
        break;
    }
  }
  
  Saw build(Room room)
  {
    Saw out = new Saw(this.shape, room);
    out.moveSpeed = this.moveSpeed;
    out.displayOrder = this.displayOrder;
    out.type = this.type;
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
    out.behaviors = this.behaviors;
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
  
  //SawSpawner buildSpawner(Room room)
  //{
  //  Saw saw = this.build(id, room);
  //  return new SawSpawner(id, saw, room);
  //}
  
  boolean inBoringAngle(PVector v)
  {
    float angle = degrees(v.heading()) + 180;
    
    if(angle < boringRange) return true;
    if(angle > 90 - boringRange && angle < 90 + boringRange) return true;
    if(angle > 180 - boringRange && angle < 180 + boringRange) return true;
    if(angle > 270 - boringRange && angle < 270 + boringRange) return true;
    if(angle > 360 - boringRange) return true;
    return false;
  }
}
