class Player extends Sprite
{
  float max_speed = 3;
  float button_acc = 0.2;
  
  Player(String id)
  {
    super(id);
    this.registerAnimation(new Animation("zombie","svg"));
    this.registerAnimation(new Animation("zombie_reverse","svg"));
    this.registerAnimation(new Animation("zombie_static","svg"));
    this.registerAnimation(new Animation("zombie_static_reverse","svg"));
    this.scale = 0.4;
    this.h = 120;
    this.location.x = 60;
  }
  
  void update()
  {
    float v = keyHeld("s") - keyHeld("w");
    float h = keyHeld("d") - keyHeld("a");
    this.acceleration.y = v;
    this.acceleration.x = h;
    this.acceleration.normalize();
    super.update();
    this.velocity.mult(0.8);
    this.velocity.limit(max_speed);
    this.chooseAnimation();
  }
  
  void check()
  {
    this.checkBounds();
    this.checkSnakes();
  }
  
  void checkBounds()
  {
    Collision coll = new Collision(this,true);
    int res = coll.box2circle(100,100,width-200,height-200,false);
    
    if(res == Collision.TOP){
      this.location.y = 100 - this.collRadius;
    }
    
    if(res == Collision.BOTTOM){
      this.location.y = height-100 + this.collRadius;
    }
    
    if(res == Collision.LEFT)
    {
      this.location.x = 100 - this.collRadius;
    }
    
    if(res == Collision.RIGHT)
    {
      game_state = 2;
      audio.playEffect("hit");
    }
  }
  
  void checkSnakes()
  {
    Collision coll = new Collision(this,true);
    for(Enemy s : snakes)
    {
      if(coll.circle2circle(s) == Collision.IN){
        game_state = 1;
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
}
