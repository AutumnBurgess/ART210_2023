import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import processing.sound.*;
import java.util.*;

Room room;

Audio audio = new Audio(this);
boolean DEBUG = false;
int tipCount = 2;
boolean moveTip = true;
boolean dashTip = true;
IntDict keysHeld = new IntDict();
IntDict keysUsed = new IntDict();

final int MENU = 0;
final int RUNNING = 1;
final int GAME_OVER = 2;
final int CREDITS = 3;
int game_state = -1;

boolean DARK_ENABLED = true;
boolean DARK_MODE = false;
ArrayList<Room> rooms = new ArrayList<Room>();
ArrayList<Boolean> roomsWon = new ArrayList<Boolean>();
int roomSelected = 0;
int roomUnlocked = 0;

PShape LArrow;
PShape RArrow;
PShape UArrow;
PShape DArrow;
PShape Star;


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
  createShapes();
  createRooms();
  setGameState(MENU);
}

void draw()
{
  drawBackground();
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
    case CREDITS:
      credits();
      break;
  }
}

void drawBackground()
{
  stroke(1);
  
  //background(118, 144, 207);
  //fill(237, 149, 231);
  //rect(100, 100, width-200, height-200);
  
  if (!DARK_MODE)
  {
    background(240);
    fill(210);
    rect(100, 100, width-200, height-200);
  }
  else
  {
    background(80, 80, 82);
    fill(80, 80, 95);
    rect(100, 100, width-200, height-200);
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
