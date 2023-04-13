class Enemy extends Sprite
{ 
  Enemy(String id)
  {
    super(id);
    this.acceleration = new PVector(0,0.1);
    this.registerAnimation(new Animation("snake","png"));
    this.w = 30;
    this.h = 320;
    this.location.y = random(0,height);
    this.location.x = random(200,width-200);
    this.reg.x = this.w/2;
    this.reg.y = this.h;
    this.collRadius = 20;
    this.rotation = 90;
    this.offset.y = -h/2;
  }
  
  void check(){
    Collision coll = new Collision(this,true);
    int res = coll.box2circle(this.collRadius,this.collRadius,width-this.collRadius,height-this.collRadius,false);
    
    if(res == Collision.BOTTOM)
    {
      this.location.y = 0;
      this.location.x = constrain(this.location.x + random(-100,100), 0, width);
      this.velocity.x = 0;
      this.velocity.y = 0;
      this.acceleration.y = random(0.05,0.15);
    }
  }
}
