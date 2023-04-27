enum SawBehavior 
{
  BOUNCE, WALL
}
class Saw extends Sprite {
  float rotSpeed = 1.5;
  float moveSpeed = 1;
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
    this.rotation += rotSpeed;
  }
  
  void update()
  {
    super.update();
    switch(this.behavior)
    {
      case BOUNCE:
        this.bounce();
        break;
      case WALL:
        this.wall();
        break;
    }
  }
  
  void bounce()
  {
    float left = this.w;
    float right = width-this.w;
    float top = this.h;
    float bottom = height-this.h;
    this.location.x = constrain(this.location.x, left, right);
    if(this.location.x <= left || this.location.x >= right){
      this.velocity.x *= -1;
    }
    
    this.location.y = constrain(this.location.y, top, bottom);
    if(this.location.y <= top || this.location.y >= bottom){
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
