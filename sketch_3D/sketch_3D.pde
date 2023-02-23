import peasy.*;
PeasyCam cam;

final int _cellSize = 10;

int _cellsX;
int _cellsY;
int _cellsZ;
int _curX = 0;
int _curY = 0;
int _curZ = 0;
boolean _running = false;
boolean _dragPlacing = false;
Cell[][][] cells;

void setup() {
  size(800,800,P3D);
  cam = new PeasyCam(this,100);
  cam.setMinimumDistance(200);
  cam.setMaximumDistance(500);
  
  _cellsX = 20;
  _cellsY = 20;
  _cellsZ = 20;
  
  cells = new Cell[_cellsX][_cellsY][_cellsZ];
  for(int x = 0; x < _cellsX; x++){
    for(int y = 0; y < _cellsY; y++){
      for(int z = 0; z < _cellsZ; z++){
        cells[x][y][z] = new Cell(x, y, z, _cellSize, cells);
      }
    }
  }
  
  for(int x = 0; x < _cellsX; x++){
    for(int y = 0; y < _cellsY; y++){
      for(int z = 0; z < _cellsZ; z++){
        cells[x][y][z].getNeighbors();
      }
    }
  }
}
void draw() {
  lights();
  background(0);
  
  drawOutline();
  
  translate(-_cellSize*(_cellsX/2), -_cellSize*(_cellsY/2), -_cellSize*(_cellsZ/2));
  
  for(int x = 0; x < _cellsX; x++){
    for(int y = 0; y < _cellsY; y++){
      for(int z = 0; z < _cellsZ; z++){
        cells[x][y][z].drawAlive();
      }
    }
  }
  if(_running){
    //update();
  }else{
    drawCursor();
  }
}

void update(){
  for(int x = 0; x < _cellsX; x++){
    for(int y = 0; y < _cellsY; y++){
      for(int z = 0; z < _cellsZ; z++){
        cells[x][y][z].check();
      }
    }
  }
  for(int x = 0; x < _cellsX; x++){
    for(int y = 0; y < _cellsY; y++){
      for(int z = 0; z < _cellsZ; z++){
        cells[x][y][z].update();
      }
    }
  }
}

void drawOutline(){
  noFill();
  stroke(0,255,0);
  box(-_cellSize*(_cellsX));
  stroke(0);
  fill(0);
}

void drawCursor(){
  pushMatrix();
  noFill();
  stroke(255,0,0);
  translate(_cellSize/2, _cellSize/2, _cellSize/2);
  translate(_curX*_cellSize, _curY*_cellSize, _curZ*_cellSize);
  box(_cellSize);
  fill(0);
  stroke(0);
  popMatrix();
}

void keyPressed(){
  if(key == '\n'){
    _running = !_running;
  }
  else if(!_running){
    if(key == 's'){
      _curY = loopVal(_curY + 1, 0, _cellsY - 1);
    }
    if(key == 'w'){
      _curY = loopVal(_curY - 1, 0, _cellsY - 1);
    }
    if(key == 'd'){
      _curX = loopVal(_curX + 1, 0, _cellsX - 1);
    }
    if(key == 'a'){
      _curX = loopVal(_curX - 1, 0, _cellsX - 1);
    }
    if(key == 'e'){
      _curZ = loopVal(_curZ + 1, 0, _cellsZ - 1);
    }
    if(key == 'q'){
      _curZ = loopVal(_curZ - 1, 0, _cellsZ - 1);
    }
    if(key == ' '){
      _dragPlacing = cells[_curX][_curY][_curZ].toggle();
    }
    if(key == 'p'){
      randomize();
    }
  } else {
    update();
  }
}

int clamp(int newVal, int min, int max){
  return max(min, min(max, newVal));
}

int loopVal(int newVal, int min, int max){
  int out = 0;
  if(newVal < min){
    out = max + 1 + (newVal + min);
  } else if (newVal > max){
    out = min + 1 + (max - newVal);
  } else {
    out = newVal;
  }
  return out;
}

void randomize(){
  for(int x = 0; x < _cellsX; x++){
    for(int y = 0; y < _cellsY; y++){
      for(int z = 0; z < _cellsZ; z++){
        cells[x][y][z].isAlive = random(-5,1) > 0;
      }
    }
  }
}
