class Player extends Sprite
{
  float max_speed = 5;
  float dashSpeed = 6;
  float button_acc = 1.25;
  float drag = 0.6;
  boolean dead = false;
  boolean dashing = false;
  boolean slowInput = false;
  boolean invincible = false;
  boolean canDash = true;
  
  float dashTimer = 0;
  float dashLength = 20;
  float dashGrace = 30;
  float dashReady = 45;
  Room room;
  
  Player(Room r)
  {
    this.registerAnimation(new Animation(this.livingShape(200)));
    this.registerAnimation(new Animation(this.dashingShape(200)));
    this.registerAnimation(new Animation(this.deadShape(200)));
    this.scale = 0.2;
    this.collRadius = 17;
    this.offset = new PVector(2,2);
    this.location.x = width/2;
    this.location.y = 3*height/4;
    this.w = 20;
    this.h = 20;
    this.room = r;
  }
  
  void update()
  {
    if (this.dead) this.velocity.mult(0.8);
    if(this.dashing)
    {
      this.dashTimer ++;
      if (this.dashTimer < dashLength)
      {
        this.canDash = false;
        this.invincible = true;
        this.slowInput = true;
        this.velocity.normalize();
        this.velocity.mult(this.dashSpeed);
        this.acceleration.mult(0);
        this.currentAnim = 1;
      }
      else if (this.dashTimer < dashGrace)
      {
        this.slowInput = false;
        this.invincible = true;
        this.currentAnim = 0;
      }
      else if (this.dashTimer < dashReady)
      {
        this.invincible = false;
      }
      else if (this.dashTimer >= dashReady)
      {
        this.canDash = true;
        this.dashing = false;
        this.dashTimer = 0;
      }
    }
    
    if (!this.dead) 
    {
      takeInput();
      if (!this.invincible) this.checkSaws();
    }
    
    super.update();
    this.velocity.limit(max_speed);
    this.keepInBounds();
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
    float addAcceleration = button_acc;
    if (this.slowInput) addAcceleration /= 2; 
    
    float v = keyHeld("s") - keyHeld("w");
    float h = keyHeld("d") - keyHeld("a");
    this.acceleration.y = v;
    this.acceleration.x = h;
    this.acceleration.normalize();
    this.acceleration.mult(addAcceleration);
    if(this.acceleration.mag() == 0)
    {
      this.velocity.mult(drag);
    }
    
    if (useKey(" ") && this.canDash) 
    {
      this.dashing = true;
      this.currentAnim = 1;
    }
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
    this.currentAnim = 2;
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
    
    PVector diff = PVector.sub(this.location, killedBy.location);
    this.room.init_game_over(diff.heading());
    setGameState(GAME_OVER);
  }
  
  PShape livingShape(float size)
  {
    PShape out = createShape(ELLIPSE, size/2, size/2, size, size);
    out.setFill(color(25, 200, 25));
    out.setStrokeWeight(6);
    return out;
  }
  PShape dashingShape(float size)
  {
    PShape out = createShape(ELLIPSE, size/2, size/2, size, size);
    out.setFill(color(25, 200, 25, 75));
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
