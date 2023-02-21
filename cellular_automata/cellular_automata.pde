final int _cellSize = 10;

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
  for(int x = 0; x < _cellsX; x++){
    for(int y = 0; y < _cellsY; y++){
      cells[x][y].drawMe();
    }
  }
  if(_running){update();}
}

void update(){
  for(int x = 0; x < _cellsX; x++){
    for(int y = 0; y < _cellsY; y++){
      cells[x][y].check();
    }
  }
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
  _running = !_running;
}
