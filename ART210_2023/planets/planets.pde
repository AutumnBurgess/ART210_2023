int _planetCount = 100;
float[] _angles = new float[_planetCount];
float[] _dists = new float[_planetCount];
float[] _speeds = new float[_planetCount];
float[] _sizes = new float[_planetCount];
color[] _colors = new color[_planetCount];
boolean[] _isMoons = new boolean[_planetCount];
float _minDis = 30;
float _maxDis = 800;
float _minSpeed = 0.1;
float _maxSpeed = 2;
float _minSize = 5;
float _maxSize = 30;
color _startColor;
color _endColor;

void setup(){
  //size(1000,1000);
  fullScreen(P3D);
  
  colorMode(HSB,100,100,100);
  _startColor = randomColor();
  _endColor = contrastColor(_startColor);
  noStroke();
  //fill starting values
  for(int i = 0; i < _planetCount; i++){
    //randomSign is to prevent values with absolute value < minSpeed
    _speeds[i] = random(_minSpeed,_maxSpeed) * randomSign();
    //equally distribute distances between minDis and maxDis
    _dists[i] = splitBetween(_minDis, _maxDis, _planetCount, i);
    _angles[i] = random(0,360);
    _sizes[i] = random(_minSize, _maxSize);
    _colors[i] = colorBetween(_startColor,_endColor,_planetCount,i);
    //_isMoons[i] = random(-1,5) < 0;
  }
}

void draw(){
  fill(0,0,0,60);
  rect(0,0,width,height);  
  //draw planets
  translate(width/2,height/2);
  for(int i = 0; i < _planetCount; i++){
    drawPlanet(_angles[i], _dists[i], _sizes[i], _colors[i], _isMoons[i]);
    _angles[i] = updatePlanetAngle(_angles[i], _speeds[i], _isMoons[i]);
  }
}

float updatePlanetAngle(float angle, float speed, boolean isMoon){
  if(isMoon){
    return angle + (speed/4);
  } else {
    return angle + speed;
  }
}

void drawPlanet(float angle, float distance, float radius, color pColor, boolean isMoon){
  if(isMoon){
    fill(pColor);
    rotate(radians(angle));
    translate(0,distance/4);
    circle(0,0,radius/2);
  } else {
    pushMatrix();
    fill(pColor);
    rotate(radians(angle));
    translate(0,distance);
    circle(0,0,radius*2);
    popMatrix();
  }
}

//+1 or -1 with (about?) equal probablility
int randomSign(){
  if (random(-1,1) <= 0){
    return -1;
  } else {
    return 1;
  }
}

float splitBetween(float min, float max, int count, int i){
  float range = (max - min);
  float split = range / count;
  return (split * i) + min;
  //((_maxDis - _minDis)/_planetCount)*i + _minDis
}

color randomColor(){
  return color(random(0,100),random(50,100),random(50,100));
}

color contrastColor(color start){
  float h = 50 - hue(start);
  return color(h, saturation(start), brightness(start));
}

color colorBetween(color min, color max, int count, int i){
  float h = splitBetween(hue(min), hue(max), count, i);
  float s = splitBetween(saturation(min), saturation(max), count, i);
  float b = splitBetween(brightness(min), brightness(max), count, i);
  return color(h,s,b);
}
