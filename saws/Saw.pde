enum SawBehavior 
{
  BOUNCE, WALL, STICK
}
class Saw extends Sprite {
  float rotSpeed = 1.5;
  float moveSpeed = 1;
  boolean stopRotation = false;
  boolean onWall = false;
  float countDown = 0;
  PVector nextVelocity = new PVector(0,0);
  SawShape myShape;
  SawType type;
  SawBehavior behavior;

  Saw(int _id, SawShape shape)
  {
    super(_id);
    this.myShape = shape;
    this.registerAnimation(new Animation(this.myShape.make()));
    this.offset = new PVector(this.myShape.outer, this.myShape.outer);
    this.collRadius = this.myShape.inner-5;
    this.w = this.myShape.outer;
    this.h = this.myShape.outer;
  }
  
  void display()
  {
    super.display();
    if(!stopRotation) this.rotation += rotSpeed;
  }
  
  void update()
  {
    super.update();
    switch(this.behavior)
    {
      default:
      case BOUNCE:
        this.bounce();
        break;
      case WALL:
        this.wall();
        break;
      case STICK:
        this.stickyBounce();
        break;
    }
  }
  
  void stickyBounce()
  {
    if(!this.onWall)
    {
      float left = this.collRadius;
      float right = width-this.collRadius;
      float top = this.collRadius;
      float bottom = height-this.collRadius;
      
      if(this.location.x <= left || this.location.x >= right || this.location.y <= top || this.location.y >= bottom)
      {
        this.nextVelocity.x = this.velocity.x;
        this.nextVelocity.y = this.velocity.y;
        if(this.location.x <= left || this.location.x >= right)
        {
          this.location.x = constrain(this.location.x, left, right);
          this.nextVelocity.x = - this.nextVelocity.x;
        }
        if(this.location.y <= top || this.location.y >= bottom)
        {
          this.location.y = constrain(this.location.y, top, bottom);
          this.nextVelocity.y = - this.nextVelocity.y;
        }
        this.velocity.x = 0;
        this.velocity.y = 0;
        this.onWall = true;
        this.stopRotation = true;
        this.countDown = 10;
      }
    }
    else
    {
      this.countDown --;
      if(this.countDown == 0)
      {
        this.onWall = false;
        this.stopRotation = false;
        this.velocity.x = this.nextVelocity.x;
        this.velocity.y = this.nextVelocity.y;
      }
    }
  }
  
  void bounce()
  {
    float left = this.w;
    float right = width-this.w;
    float top = this.h;
    float bottom = height-this.h;
    if(this.location.x <= left || this.location.x >= right){
      this.location.x = constrain(this.location.x, left, right);
      this.velocity.x *= -1;
    }
    
    if(this.location.y <= top || this.location.y >= bottom){
      this.location.y = constrain(this.location.y, top, bottom);
      this.velocity.y *= -1;
    }
  }
  
  void wall()
  {
    this.location.x = constrain(this.location.x, 0, width);
    this.location.y = constrain(this.location.y, 0, height);
    boolean onLeft = this.location.x == 0;
    boolean onRight = this.location.x == width;
    boolean onTop = this.location.y == 0;
    boolean onBottom = this.location.y == height;
    
    if(onLeft && !onTop)
    {
      this.velocity.x = 0;
      this.velocity.y = -this.moveSpeed;
    }
    if(onTop && !onRight)
    {
      this.velocity.x = this.moveSpeed;
      this.velocity.y = 0;
    }
    if(onRight && !onBottom)
    {
      this.velocity.x = 0;
      this.velocity.y = this.moveSpeed;
    }
    if(onBottom && !onLeft)
    {
      this.velocity.x = -this.moveSpeed;
      this.velocity.y = 0;
    }
  }
}
