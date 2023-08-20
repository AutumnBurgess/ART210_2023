import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import processing.sound.*;
import java.util.*;
import java.nio.file.*;

Room room;

Audio audio = new Audio(this);
boolean DEBUG = false;
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
ArrayList<Integer> bestTies = new ArrayList<Integer>();
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
  fontSmall = createFont("BebasNeue-Regular.ttf", 32, true);
  fontLarge = createFont("BebasNeue-Regular.ttf", 50, true);
  frameRate(60);
  //Ani.init(this);
  setupBuilders();
  createSounds();
  createShapes();
  createRooms();
  getSave();
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

void getSave() {
  Table table = loadTable("data/save.csv", "header");
  if (table == null) {
    return;
  }
  //deathcount  roomunlocked  palette1  palette2  palette3  palette4  room0  room1  room2  room3  room4
  TableRow data = table.getRow(0);
  deathCount = data.getInt("deathcount");
  roomUnlocked = data.getInt("roomunlocked");
  if(roomUnlocked > 0){
    moveTip = false;
    dashTip = false;
  }

  if (data.getInt("palette1") > 0) picker.unlock(1);
  if (data.getInt("palette2") > 0) picker.unlock(2);
  if (data.getInt("palette3") > 0) picker.unlock(3);
  if (data.getInt("palette4") > 0) picker.unlock(4);

  rooms.get(0).bestTime = data.getInt("room0");
  rooms.get(1).bestTime = data.getInt("room1");
  rooms.get(2).bestTime = data.getInt("room2");
  rooms.get(3).bestTime = data.getInt("room3");
  rooms.get(4).bestTime = data.getInt("room4");
}

void setSave() {
  //deathcount  roomunlocked  palette1  palette2  palette3  palette4  room0  room1  room2  room3  room4
  Table table = loadTable("defaultsave.csv", "header");
  //deathcount  levelunlocked  palette1  palette2  palette3  palette4  room0  room1  room2  room3  room4
  table.setInt(0, "deathcount", deathCount);
  table.setInt(0, "roomunlocked", roomUnlocked);

  table.setInt(0, "palette1", picker.unlocked[1] ? 1 : 0);
  table.setInt(0, "palette2", picker.unlocked[2] ? 1 : 0);
  table.setInt(0, "palette3", picker.unlocked[3] ? 1 : 0);
  table.setInt(0, "palette4", picker.unlocked[4] ? 1 : 0);

  table.setInt(0, "room0", rooms.get(0).bestTime);
  table.setInt(0, "room1", rooms.get(1).bestTime);
  table.setInt(0, "room2", rooms.get(2).bestTime);
  table.setInt(0, "room3", rooms.get(3).bestTime);
  table.setInt(0, "room4", rooms.get(4).bestTime);

  saveTable(table, "data/save.csv");
}

void resetSave() {
  Table table = loadTable("defaultsave.csv");
  saveTable(table, "data/save.csv");
  deathCount = 0;
  roomUnlocked = 0;
  roomSelected = 0;
  moveTip = true;
  dashTip = true;
  room = rooms.get(0);
  for (Room r : rooms)
  {
    r.bestTime = -1;
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
  String k = str(key).toLowerCase();
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
      } else
      {
        confirm_delete = true;
      }
    }
  } else
  {
    confirm_delete = false;
  }
}

void keyReleased()
{
  String k = str(key).toLowerCase();
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
