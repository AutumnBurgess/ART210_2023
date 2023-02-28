//hold a button to run
import peasy.*;
PeasyCam cam;

final int _cellSize = 5;

int _cellsX;
int _cellsY;
int _cellsZ;
int _curX = 0;
int _curY = 0;
int _curZ = 0;
boolean _running = false;
boolean _dragPlacing = false;
boolean _showOutline = true;
Cell[][][] cells;

void setup() {
  size(800,800,P3D);
  cam = new PeasyCam(this,300);
  cam.setMinimumDistance(200);
  cam.setMaximumDistance(1000);
  
  _cellsX = 40;
  _cellsY = 40;
  _cellsZ = 40;
  
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
  
  randomize(0.5);
  _running = true;
  _showOutline = false;
}
void draw() {
  lights();
  background(0);
  if(_showOutline){drawOutline();}
  
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
    if(keyPressed && key != '\n'){
      update();
    }
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
  popMatrix();
}

void keyPressed(){
  if(key == '\n'){ //Enter
    _running = !_running;
  } else if(key == 'o'){
    _showOutline = !_showOutline;
  }
  else if(_running){
    //update();
  } else {
    switch (key) {
      case 's':
        _curY = loopVal(_curY + 1, 0, _cellsY - 1);
        break;
      case 'w':
        _curY = loopVal(_curY - 1, 0, _cellsY - 1);
        break;
      case 'd':
        _curX = loopVal(_curX + 1, 0, _cellsX - 1);
        break;
      case 'a':
        _curX = loopVal(_curX - 1, 0, _cellsX - 1);
        break;
      case 'e':
        _curZ = loopVal(_curZ + 1, 0, _cellsZ - 1);
        break;
      case 'q':
        _curZ = loopVal(_curZ - 1, 0, _cellsZ - 1);
        break;
      case ' ':
        _dragPlacing = cells[_curX][_curY][_curZ].toggle();
        break;
      case 'r':
        randomize(0.5);
        break;
      case 't':
        randomize(0.05);
        break;
    }
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

void randomize(float threshold){
  for(int x = 0; x < _cellsX; x++){
    for(int y = 0; y < _cellsY; y++){
      for(int z = 0; z < _cellsZ; z++){
        cells[x][y][z].isAlive = random(0,1) < threshold;
      }
    }
  }
}
