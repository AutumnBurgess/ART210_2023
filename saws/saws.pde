import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import processing.sound.*;
import java.util.*;
import java.nio.file.*;

Room room;

Audio audio = new Audio(this);
boolean DEBUG = false;
int tipCount = 2;
boolean moveTip = true;
boolean dashTip = true;
boolean confirm_delete = false;
IntDict keysHeld = new IntDict();
IntDict keysUsed = new IntDict();

final int MENU = 0;
final int RUNNING = 1;
final int GAME_OVER = 2;
final int UNLOCK = 3;
int game_state = -1;

boolean DARK_ENABLED = false;
boolean DARK_MODE = false;
ArrayList<Room> rooms = new ArrayList<Room>();
ArrayList<Boolean> roomsWon = new ArrayList<Boolean>();
int deathCount = 0;
int roomSelected = 0;
int roomUnlocked = 0;

ColorPicker picker = new ColorPicker();
int paletteSelected = 0;

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
  //Ani.init(this);
  setupBuilders();
  createSounds();
  createShapes();
  createRooms();
  getSaveState();
  setGameState(MENU);
}

void draw()
{
  picker.drawCurrent();
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
  case UNLOCK:
    unlock();
    break;
  }
}

void getSaveState()
{
  String[] lines = loadStrings("save.txt");
  if (lines != null)
  {
    deathCount = int(lines[0]);
    roomUnlocked = int(lines[1]);
    roomsWon.set(0, boolean(lines[2]));
    roomsWon.set(1, boolean(lines[3]));
    roomsWon.set(2, boolean(lines[4]));
    roomsWon.set(3, boolean(lines[5]));
    roomsWon.set(4, boolean(lines[6]));
    roomsWon.set(5, boolean(lines[7]));
    if(boolean(lines[8])) picker.unlock(1);
    if(boolean(lines[9])) picker.unlock(2);
    if(boolean(lines[10])) picker.unlock(3);
    if(boolean(lines[11])) picker.unlock(4);
  }
}

void setSaveState()
{
  String[] saveState = new String[12];
  saveState[0] = str(deathCount);
  saveState[1] = str(roomUnlocked);
  saveState[2] = str(roomsWon.get(0));
  saveState[3] = str(roomsWon.get(1));
  saveState[4] = str(roomsWon.get(2));
  saveState[5] = str(roomsWon.get(3));
  saveState[6] = str(roomsWon.get(4));
  saveState[7] = str(roomsWon.get(5));
  saveState[8] = str(picker.unlocked[1]);
  saveState[9] = str(picker.unlocked[2]);
  saveState[10] = str(picker.unlocked[3]);
  saveState[11] = str(picker.unlocked[4]);
  saveStrings("data/save.txt", saveState);
}

void resetSave()
{
  String[] defaultSave = loadStrings("defaultSave.txt");
  saveStrings("data/save.txt", defaultSave);
  deathCount = 0;
  roomUnlocked = 0;
  roomSelected = 0;
  room = rooms.get(0);
  roomsWon.clear();
  for (Room r : rooms)
  {
    roomsWon.add(false);
  }
  picker.reset();
  confirm_delete = false;
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
  case GAME_OVER:
    init_game_over();
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
  if (key == BACKSPACE)
  {
    if (game_state == MENU)
    {
      if (confirm_delete)
      {
        resetSave();
      }
      else
      {
        confirm_delete = true;
      }
    }
  }
  else
  {
    confirm_delete = false;
  }
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
