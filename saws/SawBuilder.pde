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
  private float parameter = 0;
  private float extraOffset = 2;
  private SawType type;

  SawBuilder(SawType type)
  {
    this.type = type;
    this.shape = new SawShape(type);
    switch(type)
    {
      case SLOW:
        this.behaviors.add(SawBehavior.BOUNCE);
        this.moveSpeed = 2;
        this.rotSpeed = 1.5;
        this.randVelocity = true;
        this.randLocation = true;
        this.displayOrder = 2;
        break;
      case FAST:
        this.behaviors.add(SawBehavior.BOUNCE);
        this.moveSpeed = 5;
        this.rotSpeed = 3;
        this.randVelocity = true;
        this.randLocation = true;
        this.displayOrder = 3;
        break;
      case STICKY:
        this.behaviors.add(SawBehavior.STICK);
        this.parameter = 10; //stick time
        this.moveSpeed = 18;
        this.rotSpeed = 6;
        this.randVelocity = true;
        this.randLocation = true;
        this.displayOrder = 5;
        break;
      case TOPWALL:
        this.makeWall();
        this.velocity = new PVector(8, 0);
        this.location = new PVector(width/2, 0);
        break;
      case BOTTOMWALL:
        this.makeWall();
        this.location = new PVector(width/2, height);
        break;
      case LEFTWALL:
        this.makeWall();
        this.location = new PVector(0, height/2);
        break;
      case RIGHTWALL:
        this.makeWall();
        this.location = new PVector(width, height/2);
        break;
      case DROPPED:
        this.behaviors.add(SawBehavior.DISAPPEAR);
        this.parameter = 120; //dissapear time
        this.moveSpeed = 0;
        this.rotSpeed = 2;
        this.displayOrder = 0;
        break;
      case DROPPER:
        this.behaviors.add(SawBehavior.BOUNCE);
        this.behaviors.add(SawBehavior.TRAIL);
        this.parameter = 15; //spawn delay
        this.moveSpeed = 3;
        this.rotSpeed = 3;
        this.randVelocity = true;
        this.randLocation = true;
        this.displayOrder = 4;
        break;
      case MIDDLE:
        this.behaviors.add(SawBehavior.ENDGAME);
        this.moveSpeed = 0;
        this.rotSpeed = 1;
        this.displayOrder = -1;
        break;
      case CHASER:
        this.behaviors.add(SawBehavior.CHASE);
        this.behaviors.add(SawBehavior.BOUNCE);
        this.moveSpeed = 8;
        this.rotSpeed = 4;
        this.displayOrder = 6;
        this.randLocation = true;
        this.velocity = new PVector(0,0);
        break;
    }
  }
  
  void makeWall()
  {
    this.behaviors.add(SawBehavior.WALL);
    this.moveSpeed = 8;
    this.rotSpeed = 6;
    this.extraOffset = 1;
    this.displayOrder = 1;
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
    out.parameter = this.parameter;
    out.extraOffset = this.extraOffset;
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
  //  Saw saw = this.build(room);
  //  return new SawSpawner(saw, room);
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
