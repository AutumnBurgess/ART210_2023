int _xCount = 250;
int _yCount = 250;
float _startH = 0;
float _mult = 1.0;
float _diffM = 0.05;
float _maxM = 6;

int _xSize;
int _ySize;

void setup(){
  size(1000,1000);
  colorMode(HSB,400,1,1);
  _xSize = width/_xCount;
  _ySize = height/_yCount;
  noStroke();
}

void draw(){
  for (int x = 0; x < _xCount; x++){
    for (int y = 0; y < _yCount; y++){
      float distance = dist(_xSize*x,_ySize*y,mouseX,mouseY);
      float test = distance*_mult / width;
      float h = random(_startH, _startH + 60);
      float s = test;
      float b = random(0,1-test);
      fill(h,s,b);
      rect(_xSize*x,_ySize*y,_xSize,_ySize);
    }
  }
  if (mousePressed){
    _mult = min(_mult + _diffM, _maxM);
  } else {
    _mult = max(_mult - _diffM * 5, 1);
  }
  _startH = (_startH + 0.5) % 400;
}
