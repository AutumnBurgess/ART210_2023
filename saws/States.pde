////////////////////MENU////////////////////
void menu()
{
  
}

void init_menu()
{
  
}

////////////////////WAITING////////////////////
void waiting()
{
  room.waiting();
  fill(0);
  textFont(fontLarge);
  textAlign(CENTER);
  text("press space to start", width/2, height/2);
}

void init_waiting()
{
  SawType[] startSaws = {SawType.SLOW, SawType.DROPPER, SawType.TOPWALL, SawType.BOTTOMWALL};
  SawType[] spawnPattern = {SawType.FAST, SawType.FAST, SawType.STICKY, SawType.SLOW};
  int[] waitPattern =    {5000        , 5000        , 5000          , 5000};
  
  //SawType[] startSaws = {SawType.STICKY, SawType.STICKY, SawType.STICKY, SawType.STICKY};
  //SawType[] spawnPattern = {SawType.STICKY};
  //int[] waitPattern = {5000};
  room = new Room(startSaws, spawnPattern, waitPattern);
}

////////////////////RUNNING////////////////////
void running()
{
  room.running();
  audio.update();
}

void init_running(){}

////////////////////GAME OVER////////////////////
void game_over()
{
  room.over();
  fill(0);
  textFont(fontLarge);
  textAlign(CENTER);
  text("you survived " + millisAsTimer(room.timer) + "\npress r to restart", width/2, height/2);
  if(keyHeld("r") > 0)
  {
    setGameState(WAITING);
  }
}

void init_game_over(){}
