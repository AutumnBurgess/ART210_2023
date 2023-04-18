boolean DEBUG = false;
Saw s;
int game_state = 0;

void setup()
{
  size(1800,800);
  frameRate(60);
  textSize(128);
  s = new Saw("saw", 30, 80, 68, 18, false);
  s.velocity.x = 5;
  s.velocity.y = -10;
}

void draw()
{
  background(255);
  fill(230);
  rect(100,100,width-200,height-200);
  s.display();
  s.update();
  s.check();
  //if(game_state == 0)
  //{
    
  //}
  //else if (game_state == 1){
  //  fill(0);
  //  text("you lost :(", width/2, height/2);
  //}
  //else if (game_state == 2){
  //  fill(0);
  //  text("you win! :)", width/2, height/2);
  //}
}

void keyPressed(){
  if(key == '[') DEBUG = false;
  if(key == ']') DEBUG = true;
  if(key == 'r') setup();
}

void mouseClicked()
{
  
}
