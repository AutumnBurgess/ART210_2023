int _planetCount = 30;
float _minDis = 30;
float _maxDis;
float _minSpeed = 0.2;
float _maxSpeed = 2;
float _minSize = 10;
float _maxSize = 60;
color _startColor;
color _endColor;

ArrayList<Planet> planets = new ArrayList<Planet>();

void setup(){
  size(1000,1000);
  noStroke();
  
  colorMode(HSB,100,100,100);
  _startColor = randomColor();
  _endColor = contrastColor(_startColor);
  _maxDis = width/2;
  
  for (int i = 0; i < _planetCount; i++){
    Planet cur = new Planet();
    cur.speed = random(_minSpeed,_maxSpeed) * randomSign();
    cur.dist = splitBetween(_minDis, _maxDis, _planetCount, i);
    cur.angle = random(0,360);
    cur.size = random(_minSize, _maxSize);
    cur.col = colorBetween(_startColor,_endColor,_planetCount,i);
    if (random(-1,5) < 0){
      Planet curMoon = new Planet();
      curMoon.speed = random(_minSpeed,_maxSpeed) * randomSign();
      curMoon.size = random(_minSize/2,_maxSize/2);
      curMoon.dist = random(cur.size+curMoon.size+5, cur.size+curMoon.size+20);
      curMoon.angle = random(0,360);
      curMoon.col = color(255,0,0);
      cur.moon = curMoon;
      cur.hasMoon = true;
    }
    planets.add(cur);
  }
}

void draw(){
  fill(0,0,0,50);
  rect(0,0,width,height);
  translate(width/2,height/2);
  for (int i = 0; i < _planetCount; i++){
    Planet cur = planets.get(i);
    cur.drawMe();
    cur.update();
  }
}
