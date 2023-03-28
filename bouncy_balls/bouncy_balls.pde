final int NUM_BALLS = 100;
final float ra = 8;
final PVector GRAVITY = new PVector(0,0.4);
final float BOUNCE_LOSS = 0.05;
final float MOUSE_STRENGTH = 1;
final boolean debug = false;


Ball[] balls = new Ball[NUM_BALLS];
PVector TOP_LEFT;
PVector BOTTOM_RIGHT;


void setup(){
  size(1000,1000);
  //fullScreen(P3D);
  noStroke();
  colorMode(HSB,100,100,100);
  
  TOP_LEFT = new PVector(0,0);
  BOTTOM_RIGHT = new PVector(width,height);
  
  //random(top, bottom - (bottom-top)/2)
  PVector placeSub = new PVector(0, (BOTTOM_RIGHT.y - TOP_LEFT.y)/2);
  PVector placeBottomRight = PVector.sub(BOTTOM_RIGHT, placeSub);
  for (int i = 0; i < NUM_BALLS; i++){
    balls[i] = new Ball(
      randomOnScreen(TOP_LEFT, placeBottomRight),
      new PVector(random(-5,5), random(-5,5)),
      GRAVITY,
      random(6,20)
      
    );
  }
}

void draw(){
  fill(20,20,20,99);
  rect(0,0,width,height);
  
  for (Ball ball : balls){
    if (mousePressed){
      ball.pullTo(new PVector(mouseX, mouseY), MOUSE_STRENGTH);
    } else {
      ball.noPull();
    }
    ball.move();
    ball.bounce(TOP_LEFT, BOTTOM_RIGHT);
    ball.drawMe();
  }
}

PVector randomOnScreen(PVector topLeft, PVector bottomRight){
  return new PVector(random(topLeft.x, bottomRight.x), random(topLeft.y, bottomRight.y));
}
