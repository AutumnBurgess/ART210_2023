class Bob extends Sprite
{
  float max_speed = 3;
  float button_acc = 0.2;
  
  Bob(String id)
  {
    super(id);
    //this.acceleration = new PVector(0.01,0);
    this.registerAnimation(new Animation("zombie","svg"));
    this.registerAnimation(new Animation("zombie_reverse","svg"));
    this.scale = 0.4;
    this.h = 120;
    this.location.x = 60;
  }
  
  void check()
  {
    Collision coll = new Collision(this,true);
    int res = coll.box2circle(100,100,width-200,height-200,false);
    
    if(res == Collision.TOP || res == Collision.BOTTOM)
    {
      this.acceleration.y = this.acceleration.y * (-1.0);
      this.velocity.y = this.velocity.y * (-1.0);
    }
    
    if(res == Collision.LEFT)
    {
      this.acceleration.x = this.acceleration.x * (-1.0);
      this.velocity.x = this.velocity.x * (-1.0);
    }
    
    if(res == Collision.RIGHT)
    {
      game_state = 2;
    }
    
    if(this.velocity.x < 0)
    {
      this.currentAnim = 1;
    }
    else if (this.velocity.x > 0)
    {
      this.currentAnim = 0;
    }
    this.velocity.limit(max_speed);
    for(Snake s : snakes)
    {
      if(coll.circle2circle(s) == Collision.IN){
        game_state = 1;
      }
    }
  }
  
  void takeInput(char k){
    if(k == 'w' || k == 's' || k == 'a' || k == 'd') bob.velocity = new PVector(0,0);
    if(k == 'w') 
    {
      this.acceleration = new PVector(0,-button_acc);
    }
    if(k == 's')
    {
      this.acceleration = new PVector(0,button_acc);
    }
    if(k == 'a')
    {
      this.acceleration = new PVector(-button_acc,0);
    }
    if(k == 'd')
    {
      this.acceleration = new PVector(button_acc,0);
    }
  }
}
