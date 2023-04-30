import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import processing.sound.*;
import java.util.*;

Room room;

Audio audio = new Audio(this);
boolean DEBUG = false;
IntDict buttons = new IntDict();

final int MENU = 0;
final int WAITING = 1;
final int RUNNING = 2;
final int GAME_OVER = 3;
int game_state = -1;

PFont fontSmall;
PFont fontLarge;
void setup()
{
  size(800, 800, P2D);
  //pixelDensity(2);
  fontSmall = createFont("BebasNeue-Regular.ttf", 32, true);
  fontLarge = createFont("BebasNeue-Regular.ttf", 50, true);
  Ani.init(this);
  setupBuilders();
  createSounds();
  setGameState(WAITING);
}

void createSounds()
{
  //PApplet app_, boolean io_, float at_, float st_, float sl_, float rt_
  SoundEffect hit = new SoundEffect(this, false, 0.01, 0.08, 0.15, 0.2);
  audio.addEffect(hit, "hit");
  SoundEffect win = new SoundEffect(this, true, 0.01, 0.004, 0.3, 0.4);
  audio.addEffect(win, "win");
  //audio.addMusic("song.mp3", "song");
}

void draw()
{
  background(255);
  stroke(1);
  fill(230);
  rect(100, 100, width-200, height-200);
  switch (game_state)
  {
    case MENU:
      menu();
      break;
    case WAITING:
      waiting();
      break;
    case RUNNING:
      running();
      break;
    case GAME_OVER:
      game_over();
      break;
  }
}

void setGameState(int newState)
{
  game_state = newState;
  switch (newState)
  {
  case RUNNING:
    init_running();
    break;
  case WAITING:
    init_waiting();
    break;
  }
}

void keyPressed()
{
  buttons.set(str(key), 1);
  if (key == '[') DEBUG = false;
  if (key == ']') DEBUG = true;
}

void keyReleased()
{
  buttons.set(str(key), 0);
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
    buttons.set(k, 0);
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
