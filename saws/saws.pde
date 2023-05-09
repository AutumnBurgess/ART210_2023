import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import processing.sound.*;
import java.util.*;

Room room;

Audio audio = new Audio(this);
boolean DEBUG = false;
boolean dashTip = true;
IntDict keysHeld = new IntDict();
IntDict keysUsed = new IntDict();

final int MENU = 0;
final int RUNNING = 1;
final int GAME_OVER = 2;
int game_state = -1;

ArrayList<Room> rooms = new ArrayList<Room>();

PFont fontSmall;
PFont fontLarge;
void setup()
{
  size(800, 800, P2D);
  pixelDensity(displayDensity());
  fontSmall = createFont("BebasNeue-Regular.ttf", 32, true);
  fontLarge = createFont("BebasNeue-Regular.ttf", 50, true);
  frameRate(60);
  Ani.init(this);
  setupBuilders();
  createSounds();
  createRooms();
  setGameState(MENU);
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

void createRooms()
{
  Room toAdd = new Room();
  toAdd.startSaws = new SawType[]   {SawType.SLOW, SawType.SLOW, SawType.FAST, SawType.FAST};
  toAdd.spawnPattern = new SawType[]{SawType.FAST, SawType.SLOW, SawType.FAST};
  toAdd.waitPattern = new int[]    {5000        , 5000        , 10000};
  toAdd.name = "welcome";
  toAdd.devTime = 4700;
  toAdd.init();
  rooms.add(toAdd);
  
  toAdd = new Room();
  toAdd.startSaws = new SawType[]   {SawType.STICKY, SawType.STICKY, SawType.STICKY};
  toAdd.spawnPattern = new SawType[]{SawType.STICKY};
  toAdd.waitPattern = new int[]    {10000};
  toAdd.name = "pay attention";
  toAdd.devTime = 100000000;
  toAdd.init();
  rooms.add(toAdd);
  
  toAdd = new Room();
  toAdd.startSaws = new SawType[]   {SawType.CHASER, SawType.TOPWALL, SawType.BOTTOMWALL};
  toAdd.spawnPattern = new SawType[]{SawType.CHASER, SawType.STICKY, SawType.SLOW};
  toAdd.waitPattern = new int[]    {5000,         5000,           8000};
  toAdd.name = "coming to get you";
  toAdd.devTime = 100000000;
  toAdd.init();
  rooms.add(toAdd);

  toAdd = new Room();
  toAdd.startSaws = new SawType[]   {SawType.DROPPER, SawType.TOPWALL, SawType.BOTTOMWALL, SawType.LEFTWALL, SawType.RIGHTWALL};
  toAdd.spawnPattern = new SawType[]{SawType.SLOW, SawType.DROPPER};
  toAdd.waitPattern = new int[]    {5000,       5000};
  toAdd.name = "trails";
  toAdd.devTime = 100000000;
  toAdd.init();
  rooms.add(toAdd);
  
  toAdd = new Room();
  toAdd.startSaws = new SawType[]   {SawType.SLOW, SawType.DROPPER, SawType.CHASER, SawType.TOPWALL, SawType.BOTTOMWALL};
  toAdd.spawnPattern = new SawType[]{SawType.FAST, SawType.STICKY, SawType.SLOW, SawType.CHASER, SawType.DROPPER};
  toAdd.waitPattern = new int[]    {8000        , 8000        , 8000          , 8000,        8000};
  toAdd.name = "kitchen sink";
  toAdd.devTime = 100000000;
  toAdd.init();
  rooms.add(toAdd);
  
  toAdd = new Room();
  toAdd.startSaws = new SawType[]   {SawType.MIDDLE};
  toAdd.spawnPattern = new SawType[]{SawType.MIDDLE};
  toAdd.waitPattern = new int[]    {1000000000};
  toAdd.name = "???";
  toAdd.devTime = 100000000;
  toAdd.init();
  rooms.add(toAdd);
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
  case MENU:
    init_menu();
    break;
  }
}

void keyPressed()
{
  String k = str(key);
  if (key == CODED)
  {
    if (keyCode == LEFT) k = "a";
    if (keyCode == RIGHT) k = "d";
    if (keyCode == UP) k = "w";
    if (keyCode == DOWN) k = "s";
  }
  keysHeld.set(k, 1);
  keysUsed.set(k, 0);
  if (key == '[') DEBUG = false;
  if (key == ']') DEBUG = true;
}

void keyReleased()
{
  String k = str(key);
  if (key == CODED)
  {
    if (keyCode == LEFT) k = "a";
    if (keyCode == RIGHT) k = "d";
    if (keyCode == UP) k = "w";
    if (keyCode == DOWN) k = "s";
  }
  keysHeld.set(k, 0);
  keysUsed.set(k, 0);
}

int keyHeld(String k)
{
  try
  {
    return keysHeld.get(k);
  }
  catch (Exception e)
  {
    //before a button is pressed, it will not be in the dict, set it to 0 for later
    keysHeld.set(k, 0);
    keysUsed.set(k, 0);
    return 0;
  }
}

boolean useKey(String k)
{
  int held = keyHeld(k);
  if (held == 0) return false;
  int used = keysUsed.get(k);
  if (used == 1) return false;
  keysUsed.set(k, 1);
  return true;
}

String millisAsTimer(int millis)
{
  int seconds = floor(millis / 1000);
  int minutes = floor(seconds / 60);
  int remainSeconds = seconds % 60;
  String paddedSeconds = remainSeconds < 10 ? "0" + str(remainSeconds) : str(remainSeconds);
  return str(minutes) + ":" + paddedSeconds;
}
