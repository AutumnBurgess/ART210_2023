import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import processing.sound.*;

int nSnakes = 20;

Audio audio = new Audio(this);
boolean DEBUG = false;
IntDict buttons = new IntDict();
int game_state;
Player bob;
Enemy[] snakes = new Enemy[nSnakes];
void setup()
{
  size(1800,800, P2D);
  //fullScreen(P2D);
  textSize(128);
  Ani.init(this);
  createSounds();
  startGame();
}

void createSounds()
{
  SoundEffect hit = new SoundEffect(this, false, 0.001, 0.004, 0.3, 0.2);
  audio.addEffect(hit, "hit");
  SoundEffect win = new SoundEffect(this, true, 0.01, 0.004, 0.3, 0.4);
  audio.addEffect(win, "win");
  //audio.addMusic("song.mp3", "song");
}

void startGame()
{
  //size(1800,800);
  bob = new Player("test");
  for(int i = 0; i < nSnakes; i++)
  {
    snakes[i] = new Enemy("snake" + str(i));
  }
  game_state = 0;
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
    for(Enemy s : snakes)
    {
      s.display();
      s.update();
      s.check();
    }
    audio.update();
  }
  else if (game_state == 1)
  {
    fill(0);
    text("you lost :(", width/2, height/2);
  }
  else if (game_state == 2)
  {
    fill(0);
    text("you win! :)", width/2, height/2);
  }
}

void keyPressed()
{
  buttons.set(str(key), 1);
  if(key == '[') DEBUG = false;
  if(key == ']') DEBUG = true;
  if(key == 'r') startGame();
}

void keyReleased()
{
  buttons.set(str(key), 0);
  //bob.takeInput(key, false);
}

int keyHeld(String k)
{
  try
  {
    return buttons.get(k);
  }
  catch (Exception e)
  {
    //before a button is pressed, it will not be in the dict, set it to 0 for later
    buttons.set(k,0);
    return 0;
  }
}
