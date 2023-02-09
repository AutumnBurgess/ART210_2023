int _xCount = 100;
int _yCount = 100;
int _xSize;
int _ySize;

void setup(){
  size(800,800);
  _xSize = width/_xCount;
  _ySize = height/_yCount;
  noStroke();
}

void draw(){
  for (int x = 0; x < _xCount; x++){
    for (int y = 0; y < _yCount; y++){
      float distance = dist(_xSize*x,_ySize*y,mouseX,mouseY);
      boolean condition = distance < random(0,width);
      fill(condition ? 0 : 255);
      rect(_xSize*x,_ySize*y,_xSize,_ySize);
    }
  }
}
