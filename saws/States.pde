////////////////////MENU////////////////////
void menu()
{
  boolean left = useKey("a");
  boolean right = useKey("d");
  boolean space = useKey(" ");
  boolean up = useKey("w");
  boolean down = useKey("s");

  int prevSelected = roomSelected;

  if (DARK_ENABLED && (up || down)) DARK_MODE = !DARK_MODE;
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
  
  if (DARK_ENABLED)
  {
    if (DARK_MODE) DArrow.setFill(color(210));
    else DArrow.setFill(color(80, 80, 95));
    shape(DArrow, width/2, height-40);
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
    else tipText = "Press space to dash";
    fill(0);
    textFont(fontSmall);
    textAlign(CENTER);
    text(tipText, width/2, height/2);
    if (!moveTip && room.player.dashing)
    {
      dashTip = false;
    }
    if ((keyHeld("s") + keyHeld("w") + keyHeld("d") + keyHeld("a")) > 0){
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
  
  boolean nextRoom = roomSelected == roomUnlocked && roomSelected != rooms.size() && room.timer > 10000;
  if (nextRoom)
  {
    textFont(fontSmall);
    textAlign(RIGHT);
    fill(0, 180, 0);
    text("level\nunlocked!", width-5, height/2 - 16);
  }
  
  if (useKey("r"))
  {
    if (nextRoom) roomUnlocked ++;
    if (room.timer > 20000) roomsWon.set(roomSelected, true);
    setGameState(MENU);
  }
}

void init_game_over() 
{
  
}

////////////////////CREDITS////////////////////
int creditsTimer = 0;
void credits()
{
  room.game_over();
  fill(0, 0, 0, creditsTimer);
  rect(0, 0, width, height);
  creditsTimer += 2;
  if (creditsTimer >= 280)
  {
    fill(255);
    textFont(fontLarge);
    textAlign(CENTER);
    text("dark mode unlocked", width/2, height/2);
  }
  if (creditsTimer >= 600)
  {
    DARK_ENABLED = true;
    DARK_MODE = true;
    roomSelected = 0;
    setGameState(MENU);
  }
}
