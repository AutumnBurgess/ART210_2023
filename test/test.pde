int _diameter = 50;
float _position = _diameter/2;

void setup(){
  size(600, 600);
  noStroke();
}

void draw(){
  background(255);
  fill(0);
  circle(_position, _position, _diameter);
  //_position = (_position + 2) % (width - (_diameter/2));
  if(_position > width - (_diameter/2)){
    _position = _diameter/2;
  }
  else{
    _position ++;
  }
}
