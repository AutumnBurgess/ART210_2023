import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import processing.sound.*;
import java.util.*;

public enum SawType {
  SLOW, FAST, TOPWALL, BOTTOMWALL
}

int fastSaws = 2;
int slowSaws = 2;
SawType[] startSaws = {SawType.SLOW, SawType.SLOW, SawType.FAST, SawType.FAST};

int timer = 0;
int startTime = 0;
Audio audio = new Audio(this);
boolean DEBUG = false;
IntDict buttons = new IntDict();

final int SPLASH = 0;
final int WAITING = 1;
final int RUNNING = 2;
final int GAME_OVER = 3;
int game_state = -1;

Player player;
PFont fontSmall;
PFont fontLarge;
ArrayList<Saw> saws = new ArrayList<Saw>();
ArrayList<SawSpawner> spawners = new ArrayList<SawSpawner>();

void setup()
{ 
  size(600, 600, P2D);
  fontSmall = createFont("BebasNeue-Regular.ttf", 32, true);
  fontLarge = createFont("BebasNeue-Regular.ttf", 50, true);
  Ani.init(this);
  createSounds();
  setGameState(WAITING);
}

void createSounds()
{
  SoundEffect hit = new SoundEffect(this, false, 0.001, 0.004, 0.3, 0.2);
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
    case SPLASH:
      splash();
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

void addSpawner(Saw toSpawn)
{
  SawSpawner spawn = new SawSpawner(spawners.size(), toSpawn);
  spawners.add(spawn);
}

void addSaw(Saw toAdd)
{
  saws.add(toAdd);
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
