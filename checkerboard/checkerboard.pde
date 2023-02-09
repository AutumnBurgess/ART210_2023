int _xCount = 100;
int _yCount = 100;
int _xSize;
int _ySize;

// ternary operator used throughout is
// condition ? valueIfTrue : valueIfFalse

void setup(){
  //size(_xCount*_xSize,_yCount*_ySize);
  size(800,800);
  _xSize = width/_xCount;
  _ySize = height/_yCount;
  noStroke();
}

void draw(){
  oneLoop();
  //twoLoop();
  //booleanOneLoop();
  //booleanTwoLoop();
}

void oneLoop(){
  for (int i = 0; i < _xCount*_yCount; i++){
    fill((_xCount%2==0 ? (i+floor(i/_xCount))%2==0 : i%2==0) ? 0 : 255);
    rect(_xSize*(i%_xCount),_ySize*floor(i/_xCount), _xSize, _ySize); 
  }
}

void twoLoop(){
  for (int x = 0; x < _xCount; x++){
    for (int y = 0; y < _yCount; y++){
      fill((x+y)%2 == 0 ? 0 : 255);
      rect(_xSize*x,_ySize*y,_xSize,_ySize);
    }
  }
}

void booleanOneLoop(){
  boolean black = true;
  for (int i = 0; i < _xCount*_yCount; i++){
    black = (i%_xCount==0) && (_xCount%2) == 0 ? black : !black;
    fill(black ? 0 : 255);
    rect(_xSize*(i%_xCount),_ySize*floor(i/_xCount), _xSize, _ySize); 
  }
}

void booleanTwoLoop(){
  boolean black = true;
  for (float x = 0; x < width; x += _xSize){
    for (float y = 0; y < height; y += _ySize){
      fill(black ? 0 : 255);
      black = !black;
      rect(x,y,_xSize,_ySize);
    }
  }
}
