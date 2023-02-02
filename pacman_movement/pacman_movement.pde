int _radius = 20;
float _cx = width/2;
float _cy = _radius;
float _speed = 5;
char _lastWASD = ' ';

void setup(){
  size(800, 600);
  noStroke();
  _cx = width/2;
  _cy = height/2;
}

void draw(){
  fill(255,255,255,50);
  rect(0,0,width,height);
  fill(0);
  circle(_cx, _cy, _radius*2);
  
  //only use key if it is in WASD, so pressing a different key does nothing
  if(key == 'a' || key=='d' || key=='w' || key=='s'){
    _lastWASD = key;
  }
  
  //move
  if(_lastWASD == 'a'){
    _cx = max(_cx - _speed, _radius);
  }
  if(_lastWASD == 'd'){
    _cx = min(_cx + _speed, width - _radius);
  }
  if(_lastWASD == 'w'){
    _cy = max(_cy - _speed, _radius);
  }
  if(_lastWASD == 's'){
    _cy = min(_cy + _speed, height - _radius);
  }
}


boolean inBounds(){
  boolean inX = _cx < width - (_radius) && _cx > (_radius);
  boolean inY = _cy < height - (_radius) && _cy > (_radius);
  return inX && inY;
}
