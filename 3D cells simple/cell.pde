class Cell {
  int x = 0;
  int y = 0;
  int z = 0;
  boolean isAlive = false;
  boolean nextAlive = false;
  ArrayList<Cell> ns = new ArrayList<Cell>();
  
  Cell(int _x, int _y, int _z){
    this.x = _x;
    this.y = _y;
    this.z = _z;
  }
  
  void getNeighbors(){
    int xMinus = x == 0 ? CELLS_X - 1 : x - 1;
    int xPlus = x == CELLS_X - 1 ? 0 : x + 1;
    int yMinus = y == 0 ? CELLS_Y - 1 : y - 1;
    int yPlus = y == CELLS_Y - 1 ? 0 : y + 1;
    int zMinus = z == 0 ? CELLS_Z - 1 : z - 1;
    int zPlus = z == CELLS_Z - 1 ? 0 : z + 1;
    int[] xVals = {xMinus, x, xPlus};
    int[] yVals = {yMinus, y, yPlus};
    int[] zVals = {zMinus, z, zPlus};
    for(int itX : xVals){
      for(int itY : yVals){
        for(int itZ : zVals){
          if(itX != x || itY != y || itZ != z){
            //println("neighbor at " + itX + ", " + itY + ", " + itZ); 
            ns.add(allCells[itX][itY][itZ]);
          }
        }
      }
    }
  }
  
  void drawMe(){
    if (this.isAlive){
    pushMatrix();
      translate(CELL_SIZE/2, CELL_SIZE/2, CELL_SIZE/2);
      translate(this.x*CELL_SIZE, this.y*CELL_SIZE, this.z*CELL_SIZE);
      box(CELL_SIZE);
    popMatrix();
    }
  }
  
  void check(){
    int aliveCount = 0;
    for(Cell cell : ns){
      if(cell.isAlive) aliveCount++; 
    }
    
    /*
    The second rule set resurrects dead cells if they have from 14 to 19 neighbors 
    and kills live cells if they have less than 13 neighbors. 
    When the grid is initialized with each cell having a 50% chance of being alive, 
    the population shrinks over time and converges to stable 3D structures:
    */
    this.nextAlive = this.isAlive ? aliveCount >= 13 : aliveCount > 14 && aliveCount < 19;

  }
  
  void update(){
    this.isAlive = this.nextAlive;
  }
}
