class Player extends Sprite
{
  float max_speed = 4;
  float button_acc = 1.2;
  float drag = 0.6;
  
  Player(int id)
  {
    super(id);
    this.registerAnimation(new Animation(this.makeShape(200)));
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
    this.keepInBounds();
    this.checkSaws();
    //this.chooseAnimation();
  }
  
  void keepInBounds()
  {
    float left = this.w;
    float right = width-this.w;
    float top = this.h;
    float bottom = height-this.h;
    this.location.x = constrain(this.location.x, left, right);
    this.location.y = constrain(this.location.y, top, bottom);
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
    out.setStrokeWeight(6);
    return out;
  }
}
