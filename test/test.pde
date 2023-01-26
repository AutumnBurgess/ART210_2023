int _radius = 25;
float _cx = _radius;
float _cy = _radius;
float _speedx = 5;
float _speedy = 5;

void setup(){
  size(800, 600);
  noStroke();
}

void draw(){
  background(255);
  fill(0);
  circle(_cx, _cy, _radius*2);
  //x movement
  _cx += _speedx;
  if(_cx > width - (_radius) || _cx < (_radius)){
    _speedx *= -1;
  }
  
  //y movement
  _cy += _speedy;
  if(_cy > height - (_radius) || _cy < (_radius)){
    _speedy *= -1;
  }
}
