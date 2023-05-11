////////////////////MENU////////////////////
void menu()
{
  boolean left = useKey("a");
  boolean right = useKey("d");
  boolean space = useKey(" ");
  boolean up = useKey("w");
  boolean down = useKey("s");

  int prevSelected = roomSelected;

  if (left) roomSelected --;
  if (right) roomSelected ++;
  //roomSelected = constrain(roomSelected, 0, rooms.size()-1);
  roomSelected = constrain(roomSelected, 0, roomUnlocked);

  if (space) setGameState(RUNNING);
  if (prevSelected != roomSelected) room = rooms.get(roomSelected);

  room.waiting();

  shapeMode(CORNER);
  if (rooms.get(roomSelected).name != "???")
  {
    fill(0);
    textFont(fontLarge);
    textAlign(CENTER);
    String screenText = rooms.get(roomSelected).name;
    screenText += "\nPress space to start";

    text(screenText, width/2, height/2 - 25);

    if (roomsWon.get(roomSelected)) shape(Star, width/2, height/2 - 100);
  }

  if (picker.multipleAvailable)
  {
    DArrow.setFill(picker.getNextColor());
    UArrow.setFill(picker.getPreviousColor());
    shape(DArrow, width/2, height-40);
    shape(UArrow, width/2, 40);
    if (down) picker.setNext();
    if (up) picker.setPrevious();
  }
  
  if (deathCount > 0)
  {
    fill(0);
    textFont(fontSmall);
    textAlign(LEFT);
    text("deaths: " + deathCount, 10, 42); 
  }
  
  if (confirm_delete)
  {
    fill(0);
    textFont(fontLarge);
    textAlign(CENTER);
    text("delete save?", width/2, 50);
  }

  if (roomSelected < roomUnlocked) shape(RArrow, width - 40, height/2);
  if (roomSelected > 0) shape(LArrow, 40, height/2);
}

void init_menu()
{
  for (Room r : rooms)
  {
    r.init();
  }
  room = rooms.get(roomSelected);
}

////////////////////RUNNING////////////////////
void running()
{
  room.running();
  audio.update();
  if (dashTip || moveTip)
  {
    String tipText = "";
    if (moveTip) tipText = "WASD or arrow keys to move";
    else tipText = "Press space to dash through saws";
    fill(0);
    textFont(fontSmall);
    textAlign(CENTER);
    text(tipText, width/2, height/2);
    if (!moveTip && keyHeld(" ") > 0)
    {
      dashTip = false;
    }
    if ((keyHeld("s") + keyHeld("w") + keyHeld("d") + keyHeld("a")) > 0) {
      moveTip = false;
    }
  }
}

void init_running()
{
  room.begin();
}

////////////////////GAME OVER////////////////////
void game_over()
{
  room.game_over();
  fill(0);
  textFont(fontLarge);
  textAlign(CENTER);
  String text = "you survived " + millisAsTimer(room.timer);
  int textHeight = height/2 - 25;
  if (room.timer > room.devTime)
  {
    text += "\n(better than me!)";
    textHeight -= 25;
  }
  text += "\npress r to restart";
  text(text, width/2, textHeight);

  boolean nextRoom = roomSelected == roomUnlocked - 1 && roomSelected != rooms.size() && room.timer > 10000;
  if (nextRoom)
  {
    textFont(fontSmall);
    textAlign(RIGHT);
    fill(0, 180, 0);
    text("level\nunlocked!", width-5, height/2 - 16);
  }

  if (useKey("r")) setGameState(MENU);
  
}

void init_game_over()
{
  deathCount ++;
  if (room.timer > 10000)
  {
    roomUnlocked = max(roomUnlocked, roomSelected + 1);
  }
  if (room.timer > 20000)
  {
    roomsWon.set(roomSelected, true);
    if (!picker.unlocked[picker.WINNER])
    {
      boolean allWon = true;
      for (int i = 0; i < roomsWon.size() - 1; i ++)
      {
        if (!roomsWon.get(i))
        {
          allWon = false;
          break;
        }
      }
      if (allWon)
      {
        nowUnlocking = picker.WINNER;
        setGameState(UNLOCK);
      }
    }
  }
  if (room.name == "coming to get you" && !picker.unlocked[picker.CANDY] && room.timer > 10000)
  {
    nowUnlocking = picker.CANDY;
    setGameState(UNLOCK);
  }
  if (deathCount >= 20 && !picker.unlocked[picker.BLUE])
  {
    nowUnlocking = picker.BLUE;
    setGameState(UNLOCK);
  }
  setSaveState();
}

////////////////////UNLOCK////////////////////
int nowUnlocking = 0;
int unlockTimer = 0;
void unlock()
{
  room.game_over();
  color toFill = picker.outs[nowUnlocking];
  fill(red(toFill), green(toFill), blue(toFill), unlockTimer);
  rect(0, 0, width, height);
  unlockTimer += 2;
  if (unlockTimer >= 280)
  {
    fill(255);
    textFont(fontLarge);
    textAlign(CENTER);
    text(picker.names[nowUnlocking] + " palette unlocked", width/2, height/2);
  }
  if (unlockTimer >= 500)
  {
    unlockTimer = 0;
    picker.unlock(nowUnlocking);
    picker.selected = nowUnlocking;
    DARK_ENABLED = true;
    DARK_MODE = true;
    setSaveState();
    setGameState(MENU);
  }
}
