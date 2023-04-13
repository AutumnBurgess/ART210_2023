class Sprite
{
  String id = "";
  PVector location = new PVector(width/2,height/2);
  PVector velocity = new PVector(0,0);
  PVector acceleration = new PVector(0,0);
  
  float w = 100;
  float h = 100;
  PVector reg = new PVector(w/2.0,h/2.0);
  
  int maxAnim = 10;
  int currentAnim = 0;
  int nAnim = 0;
  Animation[] anim = new Animation[maxAnim];
  float scale = 1.0;
  float rotation = 0;
  PVector offset = new PVector(0,0);
  
  float collRadius = w/2.0;
  PVector collBox = new PVector(w,h);
  
  Sprite(String _id)
  {
    this.id = _id;
  }
  
  void registerAnimation(Animation _anim)
  {
    if(this.nAnim < this.maxAnim)
    {
      this.anim[this.nAnim]=_anim;
      this.nAnim = this.nAnim + 1;
    }
    else
    {
      println("Animation number overflow");
    }
  }
  
  void update()
  {
    this.velocity.add(this.acceleration);
    this.location.add(this.velocity);
  }
  
  void display()
  {
    pushMatrix();
      translate(this.location.x,this.location.y);
      pushMatrix();
        scale(this.scale);
        translate(this.offset.x,this.offset.y);
        rotate(radians(this.rotation));
        this.anim[this.currentAnim].display();
      popMatrix(); 
      if (DEBUG) testDisplay();   
    popMatrix();
  }
  
  void testDisplay()
  {
    noStroke();
    fill(color(255,100,100));
    circle(0,0,10);
    noFill();
    stroke(color(100,100,255));
    rect(-reg.x,-reg.y,this.w,this.h);
    noStroke();
    fill(color(0,0,255,100));
    circle(0,0,this.collRadius*2);
  }
  
  void check(){}
  
}
