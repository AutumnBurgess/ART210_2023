////////////////////MENU////////////////////
int roomSelected = 0;
void menu()
{
  boolean left = useKey("a");
  boolean right = useKey("d");
  boolean space = useKey(" ");
  
  int prevSelected = roomSelected;
  
  if(left) roomSelected --;
  if(right) roomSelected ++;
  roomSelected = constrain(roomSelected, 0, rooms.size()-1);
  
  if(space)
  {
    setGameState(RUNNING);
  }
  
  if (prevSelected != roomSelected)
  {
    room = rooms.get(roomSelected);
  }
  
  room.waiting();
  
  fill(0);
  textFont(fontLarge);
  textAlign(CENTER);
  text(rooms.get(roomSelected).name + "\nPress space to start", width/2, height/2);
}

void init_menu()
{
  for(Room r : rooms)
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
  text("you survived " + millisAsTimer(room.timer) + "\npress r to restart", width/2, height/2);
  if(useKey("r"))
  {
    setGameState(MENU);
  }
  if(useKey(str(BACKSPACE)))
  {
    setGameState(MENU);
  }
}

void init_game_over(){}
