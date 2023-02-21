class Cell {
  int size = 10;
  int x = 0;
  int y = 0;
  Cell[][] cells;
  boolean isAlive = false;
  boolean nextAlive = false;
  int aliveCount = 0;
  Cell[] ns = new Cell[8];
  
  Cell(int _x, int _y, int _size, Cell[][] _cells){
    this.x = _x;
    this.y = _y;
    this.size = _size;
    this.cells = _cells;
  }
  
  void getNeighbors(){
    int cellsX = this.cells.length;
    int cellsY = this.cells[0].length;
    int up = this.y == 0 ? cellsY - 1 : this.y-1;
    int down = this.y == cellsY - 1 ? 0 : this.y+1;
    int left = this.x == 0 ? cellsX - 1 : this.x-1;
    int right = this.x == cellsX - 1 ? 0 : this.x+1;
    
    this.ns[0] = this.cells[this.x][up];
    this.ns[1] = this.cells[this.x][down];
    this.ns[2] = this.cells[left][this.y];
    this.ns[3] = this.cells[right][this.y];
    this.ns[4] = this.cells[right][up];
    this.ns[5] = this.cells[right][down];
    this.ns[6] = this.cells[left][up];
    this.ns[7] = this.cells[left][down];
  }
  
  void drawMe(){
    fill(isAlive ? 50 : 255);
    rect(this.x*this.size, this.y*this.size, this.size, this.size);
    fill(255,0,0);
  }
  
  void check(){
    aliveCount = 0;
    for(int i = 0; i < ns.length; i++){
      if(ns[i].isAlive){
        aliveCount ++;
      }
    }
    this.nextAlive = this.isAlive;
    if(this.isAlive){
      if(this.aliveCount < 2 || this.aliveCount > 3){
        this.nextAlive = false;
      }
    } else {
      if(this.aliveCount == 3){
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
