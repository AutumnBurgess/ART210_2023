class Player extends Sprite
{
  float max_speed = 4;
  float button_acc = 1.2;
  float drag = 0.6;
  
  Player(String id)
  {
    super(id);
    PShape[] shapes = new PShape[1];
    PShape playerShape = this.makeShape(200);
    shapes[0] = playerShape;
    this.registerAnimation(new Animation(shapes));
    
    //this.registerAnimation(new Animation("zombie","svg"));
    //this.registerAnimation(new Animation("zombie_reverse","svg"));
    //this.registerAnimation(new Animation("zombie_static","svg"));
    //this.registerAnimation(new Animation("zombie_static_reverse","svg"));
    this.scale = 0.2;
    this.collRadius = 17;
    this.w = 20;
    this.h = 20;
    this.location.x = 30;
  }
  
  void update()
  {
    takeInput();
    super.update();
    super.keepInBounds();
    this.checkSaws();
    //this.chooseAnimation();
  }
  
  void takeInput()
  {
    float v = keyHeld("s") - keyHeld("w");
    float h = keyHeld("d") - keyHeld("a");
    this.acceleration.y = v;
    this.acceleration.x = h;
    this.acceleration.normalize();
    this.acceleration.mult(button_acc);
    if(this.acceleration.mag() == 0)
    {
      this.velocity.mult(drag);
    }
    this.velocity.limit(max_speed);
    
  }
  
  //void takeInputOld()
  //{
  //  float v = keyHeld("s") - keyHeld("w");
  //  float h = keyHeld("d") - keyHeld("a");
  //  this.velocity.y = v;
  //  this.velocity.x = h;
  //  this.velocity.normalize();
  //  this.velocity.mult(max_speed);
  //  super.update();
  //}
  
  void checkSaws()
  {
    Collision coll = new Collision(this,true);
    for(Saw s : saws)
    {
      if(coll.circle2circle(s) == Collision.IN){
        setGameState(GAME_OVER);
        audio.playEffect("win");
      }
    }
  }
  
  void chooseAnimation()
  {
    if (this.acceleration.x == 0 && this.acceleration.y == 0 && this.currentAnim < 2)
    {
      this.currentAnim += 2;
    }
    else if(this.acceleration.x < 0)
    {
      this.currentAnim = 1;
    }
    else if (this.acceleration.x > 0)
    {
      this.currentAnim = 0;
    }
    else if (this.acceleration.y != 0 && this.currentAnim > 1){
      this.currentAnim -= 2;
    }
  }
  
  PShape makeShape(float size)
  {
    PShape out = createShape(ELLIPSE, size/2, size/2, size, size);
    out.setFill(color(25, 200, 25));
    out.setStroke(false);
    return out;
  }
}
