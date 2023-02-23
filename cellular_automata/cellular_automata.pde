final int _cellSize = 2;

int _cellsX;
int _cellsY;
boolean _running = false;
boolean _dragPlacing = false;
Cell[][] cells;

void setup(){
  //size(800, 800);
  fullScreen(P3D);
  stroke(200);
  _cellsX = width/_cellSize;
  _cellsY = height/_cellSize;
  noStroke();
  
  cells = new Cell[_cellsX][_cellsY];
  for(int x = 0; x < _cellsX; x++){
    for(int y = 0; y < _cellsY; y++){
      cells[x][y] = new Cell(x, y, _cellSize, cells);
    }
  }
  for(int x = 0; x < _cellsX; x++){
    for(int y = 0; y < _cellsY; y++){
      cells[x][y].getNeighbors();
    }
  }
}

void draw(){
  background(255);
  for(int x = 0; x < _cellsX; x++){
    for(int y = 0; y < _cellsY; y++){
      cells[x][y].drawMe();
      cells[x][y].check();
    }
  }
  if(_running){update();}
}

void update(){
  for(int x = 0; x < _cellsX; x++){
    for(int y = 0; y < _cellsY; y++){
      cells[x][y].update();
    }
  }
}
void mousePressed(){
  if (!_running){
    int clickX = min(floor(mouseX) / _cellSize, _cellsX - 1);
    int clickY = min(floor(mouseY) / _cellSize, _cellsY - 1);
    _dragPlacing = cells[clickX][clickY].toggle();
  }
}

void mouseDragged(){
  if (!_running){
    int clickX = min(floor(mouseX) / _cellSize, _cellsX - 1);
    int clickY = min(floor(mouseY) / _cellSize, _cellsY - 1);
    cells[clickX][clickY].isAlive = _dragPlacing;
  }
}

void keyPressed(){
  if (key == ' '){ 
    _running = !_running;
  }
  if (!_running){
    if (key == 'r'){
      randomize();
    }
    if (key == 'q'){
      clearCells();
    }
  }
}

void clearCells(){
  for(int x = 0; x < _cellsX; x++){
    for(int y = 0; y < _cellsY; y++){
      cells[x][y].isAlive = false;
    }
  }
}

void randomize(){
  for(int x = 0; x < _cellsX; x++){
    for(int y = 0; y < _cellsY; y++){
      cells[x][y].isAlive = random(-5,1) > 0;
    }
  }
}
