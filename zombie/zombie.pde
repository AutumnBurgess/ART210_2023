boolean DEBUG = false;

int game_state = 0;
Bob bob;
int nSnakes = 8;
Snake[] snakes = new Snake[nSnakes];
void setup()
{
  size(1800,800);
  textSize(128);
  bob = new Bob("test");
  for(int i = 0; i < nSnakes; i++)
  {
    snakes[i] = new Snake("snake" + str(i));
  }
}

void draw()
{
  background(255);
  fill(230);
  rect(100,100,width-200,height-200);
  if(game_state == 0)
  {
    bob.display();
    bob.update();
    bob.check();
    for(Snake s : snakes)
    {
      s.display();
      s.update();
      s.check();
    }
  }
  else if (game_state == 1){
    fill(0);
    text("you lost :(", width/2, height/2);
  }
  else if (game_state == 2){
    fill(0);
    text("you win! :)", width/2, height/2);
  }
}

void keyPressed(){
  if(key == '[') DEBUG = false;
  if(key == ']') DEBUG = true;
  if(key == 'r') setup();
  bob.takeInput(key);
}

void mouseClicked()
{
  bob.acceleration.x = bob.acceleration.x * (-1.0);
  bob.velocity.x = bob.acceleration.x * (-1.0);
  println(bob.acceleration);
}
