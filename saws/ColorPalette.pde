class ColorPicker
{
  final int DEFAULT = 0;
  final int DARK = 1;
  final int CANDY = 2;
  final int WINNER = 3;
  final int BLUE = 4;
  color[] outs = 
    new color[]{color(240), color(80, 80, 80), color(237, 149, 231), color(245, 239, 56), color(61, 64, 242)};
  color[] ins =  
    new color[]{color(210), color(40, 40, 40), color(118, 144, 207), color(217, 219, 147), color(43, 58, 84)};
  String[] names = new String[]{"default", "dark", "candy", "winner", "feeling blue"};
  boolean[] unlocked = new boolean[]{true, false, false, false, false};
  boolean multipleAvailable = false;
  int selected = 0;

  void drawCurrent()
  {
    background(outs[selected]);
    fill(ins[selected]);
    rect(100, 100, width-200, height-200);
  }

  boolean unlock(int type)
  {
    multipleAvailable = true;
    boolean out = unlocked[type];
    unlocked[type] = true;
    return out;
  }
  
  void reset()
  {
    selected = 0;
    unlocked = new boolean[]{true, false, false, false, false};
    multipleAvailable = false;
  }

  void setNext()
  {
    if (multipleAvailable)
    {
      int check = (selected + 1) % unlocked.length;
      while (check != selected)
      {
        if (unlocked[check])
        {
          selected = check;
          return;
        }
        check = (check + 1) % unlocked.length;
      }
    }
  }

  void setPrevious()
  {
    if (multipleAvailable)
    {
      int check = selected - 1;
      if (check < 0) check += unlocked.length;
      while (check != selected)
      {
        if (unlocked[check])
        {
          selected = check;
          return;
        }
        check --;
        if (check < 0) check += unlocked.length;
      }
    }
  }

  color getNextColor()
  {
    if (multipleAvailable)
    {
      int check = (selected + 1) % unlocked.length;
      while (check != selected)
      {
        if (unlocked[check])
        {
          return outs[check];
        }
        check = (check + 1) % unlocked.length;
      }
    }
    return color(0);
  }

  color getPreviousColor()
  {
    if (multipleAvailable)
    {
      int check = selected - 1;
      if (check < 0) check += unlocked.length;
      while (check != selected)
      {
        if (unlocked[check])
        {
          return outs[check];
        }
        check --;
        if (check < 0) check += unlocked.length;
      }
    }
    return color(0);
  }
}
