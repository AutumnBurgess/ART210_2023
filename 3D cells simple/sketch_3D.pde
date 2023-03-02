import peasy.*;
PeasyCam cam;

final int CELL_SIZE = 5;
final int CELLS_X = 50;
final int CELLS_Y = 50;
final int CELLS_Z = 50;

Cell[][][] allCells;

void setup() {
  size(800,800,P3D);
  cam = new PeasyCam(this,300);
  cam.setMinimumDistance(200);
  cam.setMaximumDistance(1000);
  
  allCells = new Cell[CELLS_X][CELLS_Y][CELLS_Z];
  for(int x = 0; x < CELLS_X; x++){
    for(int y = 0; y < CELLS_Y; y++){
      for(int z = 0; z < CELLS_Z; z++){
        allCells[x][y][z] = new Cell(x, y, z);
      }
    }
  }
  for(Cell[][] xCells : allCells){
    for(Cell[] yCells : xCells){
      for(Cell cell : yCells){
        cell.getNeighbors();
      }
    }
  }
  
  randomize(0.5);
}
void draw() {
  lights();
  background(0);
  translate(-CELL_SIZE*(CELLS_X/2), -CELL_SIZE*(CELLS_Y/2), -CELL_SIZE*(CELLS_Z/2));
  noStroke();
  fill(color(10,200,150));
  
  
  for(Cell[][] xCells : allCells){
    for(Cell[] yCells : xCells){
      for(Cell cell : yCells){
        cell.check();
      }
    }
  }
  for(Cell[][] xCells : allCells){
    for(Cell[] yCells : xCells){
      for(Cell cell : yCells){
        cell.update();
        cell.drawMe();
      }
    }
  }
}

void keyPressed(){
  randomize(0.5);
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
  for(Cell[][] xCells : allCells){
    for(Cell[] yCells : xCells){
      for(Cell cell : yCells){
        cell.isAlive = random(0,1) < threshold;
      }
    }
  }
}
