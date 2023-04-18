import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import processing.sound.*;

int fastSaws = 5;
int slowSaws = 7;
int timer = 0;
int startTime = 0;
Audio audio = new Audio(this);
boolean DEBUG = false;
IntDict buttons = new IntDict();
int game_state = 0;
IntDict states = new IntDict();
Player player;
Saw[] saws = new Saw[fastSaws + slowSaws];
void setup()
{
  size(600,600,P2D);
  //fullScreen(P2D);
  textSize(32);
  Ani.init(this);
  createSounds();
  createStates();
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

void createStates()
{
  states.add("menu", 0);
  states.add("running", 1);
  states.add("over", 2);
}

void startGame()
{
  //size(1800,800);
  player = new Player("player");
  for(int i = 0; i < slowSaws; i++)
  {
    saws[i] = new SawSlow("saw" + str(i));
  }
  for(int i = slowSaws; i < fastSaws + slowSaws; i++)
  {
    saws[i] = new SawFast("saw" + str(i));
  }
  game_state = states.get("menu");
}

void draw()
{
  background(255);
  stroke(1);
  fill(230);
  rect(100,100,width-200,height-200);
  if(game_state == states.get("menu"))
  {
    player.display();
    for(Saw s : saws)
    {
      s.display();
    }
    fill(0);
    text("press space to start", width/2 - 120, height/2);
    if(keyHeld(" ") > 0)
    {
      game_state = states.get("running");
      startTime = millis();
    }
  }
  if(game_state == states.get("running"))
  {
    run();
  }
  else if (game_state == states.get("over"))
  {
    fill(0);
    text("you survived " + millisAsTimer(timer) + "\npress r to restart", width/2 - 120, height/2);
  }
}

void run()
{
  player.display();
  player.update();
  player.check();
  for(Saw s : saws)
  {
    s.display();
    s.update();
    s.check();
  }
  audio.update();
  timer = millis() - startTime;
  fill(0);
  text(millisAsTimer(timer), 10, 30);
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

String millisAsTimer(int millis)
{
  int seconds = floor(millis / 1000);
  int minutes = floor(seconds / 60);
  int remainSeconds = seconds % 60;
  String paddedSeconds = remainSeconds < 10 ? "0" + str(remainSeconds) : str(remainSeconds);
  return str(minutes) + ":" + paddedSeconds;
}
