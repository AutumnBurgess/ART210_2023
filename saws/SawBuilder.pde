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
  ArrayList<SawBehavior> behaviors = new ArrayList<SawBehavior>();
  private static final float boringRange = 15;
  private int displayOrder = 0;
  private float moveSpeed;
  private float rotSpeed;
  private PVector location = new PVector(width/2, height/2);
  private PVector velocity = new PVector(0,0);
  private boolean randLocation = false;
  private boolean randVelocity = false;
  private float behaviorParameter = 0;
  private float collRadius = 1;
  private float size = 1;
  private PShape sawShape;
  private PShape blinkingShape;
  private SawType type;

  SawBuilder(SawType type)
  {
    this.type = type;
    Table table = loadTable("sawdata.csv", "header");
    for (TableRow row : table.rows()){
      if(type.name().equals(row.getString("name"))){
        getFromTable(row);
        break;
      }
    }
  }
  
  void getFromTable(TableRow row){
    this.sawShape = loadShape("shapes/" + this.type.name() + ".svg");
    this.blinkingShape = loadShape("shapes/" + this.type.name() + "_BLINK.svg");
    String behavior1 = row.getString("behavior1");
    this.behaviors.add(SawBehavior.valueOf(behavior1));
    String behavior2 = row.getString("behavior2");
    if(!behavior2.isEmpty()){
      this.behaviors.add(SawBehavior.valueOf(behavior2));
    }
    this.behaviorParameter = row.getFloat("parameter");
    this.moveSpeed = row.getFloat("movespeed");
    this.rotSpeed = row.getFloat("rotspeed");
    this.collRadius = row.getFloat("collradius");
    this.size = row.getFloat("size");
    this.displayOrder = row.getInt("displayorder");
    if(!row.getString("locx").isEmpty()){
      float locX = row.getFloat("locx");
      float locY = row.getFloat("locy");
      this.location = new PVector(locX, locY);
    } else {
      this.randLocation = true;
    }
    if(!row.getString("velx").isEmpty()){
      float velX = row.getFloat("velx");
      float velY = row.getFloat("vely");
      this.velocity = new PVector(velX, velY);
    } else {
      this.randVelocity = true;
    }
  }
 
  Saw build(Room room)
  {
    Saw out = new Saw();
    out.type = this.type;
    out.registerAnimation(new Animation(this.sawShape));
    out.room = room;
    out.moveSpeed = this.moveSpeed;
    out.displayOrder = this.displayOrder;
    out.type = this.type;
    if(this.randVelocity)
    {
      do out.velocity = PVector.random2D().mult(out.moveSpeed);
      while(this.inBoringAngle(out.velocity));
    }
    else
    {
      out.velocity = this.velocity.copy();
    }
    out.rotSpeed = this.rotSpeed;
    out.behaviors = this.behaviors;
    out.parameter = this.behaviorParameter;
    out.collRadius = this.collRadius;
    out.w = this.size;
    out.h = this.size;
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
  
  SawSpawner buildSpawner(Room room){
    SawSpawner out = new SawSpawner();
    out.toSpawn = this.build(room);
    out.room = room;
    out.registerAnimation(new Animation(this.blinkingShape));
    out.location = out.toSpawn.location;
    
    return out;
  }
  
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
