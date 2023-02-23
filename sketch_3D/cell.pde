class Cell {
  int size = 0;
  int x = 0;
  int y = 0;
  int z = 0;
  Cell[][][] cells;
  boolean isAlive = false;
  boolean nextAlive = false;
  ArrayList<Cell> ns = new ArrayList<Cell>();
  
  Cell(int _x, int _y, int _z, int _size, Cell[][][] _cells){
    this.x = _x;
    this.y = _y;
    this.z = _z;
    this.size = _size;
    this.cells = _cells;
  }
  
  void getOrthoNeighbors(){
    int cellsX = this.cells.length;
    int cellsY = this.cells[0].length;
    int cellsZ = this.cells[0][0].length;
    int up = this.y == 0 ? cellsY - 1 : this.y-1;
    int down = this.y == cellsY - 1 ? 0 : this.y+1;
    int left = this.x == 0 ? cellsX - 1 : this.x-1;
    int right = this.x == cellsX - 1 ? 0 : this.x+1;
    int front = this.z == 0 ? cellsZ - 1 : this.z-1;
    int back = this.z == cellsZ - 1 ? 0 : this.z+1;
    
    ns.add(this.cells[left][this.y][this.z]);
    ns.add(this.cells[right][this.y][this.z]);
    ns.add(this.cells[this.x][up][this.z]);
    ns.add(this.cells[this.x][down][this.z]);
    ns.add(this.cells[this.x][this.y][front]);
    ns.add(this.cells[this.x][this.y][back]);
  }
  
  void getNeighbors(){
    int cellsX = this.cells.length;
    int cellsY = this.cells[0].length;
    int cellsZ = this.cells[0][0].length;
    for(int itX = this.x-1; itX <= this.x+1; itX ++){
      for(int itY = this.y-1; itY <= this.y+1; itY ++){
        for(int itZ = this.z-1; itZ <= this.z+1; itZ ++){
          if(itX != 0 && itY != 0 && itZ != 0){
            int curX = loopVal(itX, 0, cellsX-1);
            int curY = loopVal(itY, 0, cellsY-1);
            int curZ = loopVal(itZ, 0, cellsZ-1);
            ns.add(this.cells[curX][curY][curZ]);
          }
        }
      }
    }
  }
  
  void drawAlive(){
    fill(255);
    if (this.isAlive){
    pushMatrix();
      translate(this.size/2, this.size/2, this.size/2);
      translate(this.x*this.size, this.y*this.size, this.z*this.size);
      box(this.size);
    popMatrix();
    }
  }
  
  void check(){
    int aliveCount = 0;
    for(int i = 0; i < ns.size(); i++){
      if(ns.get(i).isAlive){
        aliveCount ++;
      }
    }
    /*
    The second rule set resurrects dead cells if they have from 14 to 19 neighbors 
    and kills live cells if they have less than 13 neighbors. 
    When the grid is initialized with each cell having a 50% chance of being alive, 
    the population shrinks over time and converges to stable 3D structures:
    */
    this.nextAlive = this.isAlive;
    if(this.isAlive){
      if(aliveCount < 13){
        this.nextAlive = false;
      }
    } else {
      if(aliveCount > 14 && aliveCount < 19){
        this.nextAlive = true;
      }
    }
  }
  
  void update(){
    this.isAlive = this.nextAlive;
  }
  
  boolean toggle(){
    this.isAlive = !this.isAlive;
    return this.isAlive;
  }
}
