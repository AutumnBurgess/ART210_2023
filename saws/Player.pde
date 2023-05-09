class Player extends Sprite
{
  float max_speed = 5;
  float button_acc = 1.25;
  float drag = 0.6;
  boolean dead = false;
  Room room;
  
  Player(Room r)
  {
    this.registerAnimation(new Animation(this.livingShape(200)));
    this.registerAnimation(new Animation(this.deadShape(200)));
    this.scale = 0.2;
    this.collRadius = 17;
    this.w = 20;
    this.h = 20;
    this.room = r;
  }
  
  void update()
  {
    if (!this.dead) takeInput();
    if (this.dead) {
      this.velocity.mult(0.8);
    }
    super.update();
    this.keepInBounds();
    if (!this.dead) this.checkSaws();
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
    for(Saw s : this.room.saws)
    {
      if(!s.gone && coll.circle2circle(s) == Collision.IN){
        this.die(s);
      }
    }
  }
  
  void die(Saw killedBy)
  {
    this.currentAnim = 1;
    this.dead = true;
    this.acceleration = new PVector(0,0);
    this.velocity.x = killedBy.velocity.x;
    this.velocity.y = killedBy.velocity.y;
    if(this.velocity.mag() < 5)
    {
      this.velocity.normalize();
      this.velocity.mult(5);
    }
    audio.playEffect("hit");
    delay(150);
    
    //PVector diff = PVector.sub(this.location, killedBy.location);
    //this.room.init_game_over(killedBy.velocity.heading());
    PVector diff = PVector.sub(this.location, killedBy.location);
    this.room.init_game_over(diff.heading());
    setGameState(GAME_OVER);
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
  
  PShape livingShape(float size)
  {
    PShape out = createShape(ELLIPSE, size/2, size/2, size, size);
    out.setFill(color(25, 200, 25));
    out.setStrokeWeight(6);
    return out;
  }
  PShape deadShape(float size)
  {
    PShape out = createShape(ELLIPSE, size/2, size/2, size, size);
    out.setFill(color(200, 20, 10));
    out.setStrokeWeight(6);
    return out;
  }
}
