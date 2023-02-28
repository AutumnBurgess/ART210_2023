final int numBalls = 50;
final float _radius = 8;
PVector gravity = new PVector(0,0.5);
final int _w = 800;
final int _h = 800;
final float _bounceMult = 0.95;
final boolean debug = false;

Ball[] balls = new Ball[numBalls];


final float left = _radius;
final float right = _w - _radius;
final float top = _radius;
final float bottom = _h - _radius;


void setup(){
  size(_w,_h);
  noStroke();
  colorMode(HSB,100,100,100);
  
  PVector location = new PVector(100,100);
  PVector velocity = new PVector(5, 0);
  PVector acceleration = gravity;
  for (int i = 0; i < numBalls; i++){
    balls[i] = new Ball(
      new PVector(random(left, right), random(top, bottom - (bottom-top)/2)),
      new PVector(random(-5,5), random(-5,5)),
      gravity
    );
  }
}
 
void draw(){
  background(20);
  for (int i = 0; i < numBalls; i++){
    balls[i].move();
    balls[i].bounce(left, right, top, bottom);
    balls[i].drawMe();
  }
  resetWhenDone();
}

void resetWhenDone(){
  boolean allOnFloor = true;
  for (int i = 0; i < numBalls; i++){
    if (!balls[i].isOnFloor()){
      allOnFloor = false;
      if (debug){
        println("ball " + i + " is still bouncing with vel of " + balls[i].velocity.y);
      }
      break;
    }
  }
  if (allOnFloor){
    setup();
  }
}
