int _planetCount = 30;
int _screenSize = 1000;
float _minDis = 80;
float _maxDis = _screenSize/2;
float _minSpeed = 0.2;
float _maxSpeed = 2.5;
float _minSize = 10;
float _maxSize = 30;
color _startColor;
color _centerColor;
color _endColor;

ArrayList<Planet> planets = new ArrayList<Planet>();

void setup(){
  size(_screenSize,_screenSize);
  noStroke();
  colorMode(HSB,100,100,100);
  
  _startColor = randomColor();
  _centerColor = varyColor(_startColor);
  _endColor = contrastColor(_startColor);
  
  for (int i = 0; i < _planetCount; i++){
    planets.add(generatePlanet(i));
  }
}

void draw(){
  fill(0,0,0,40);
  rect(0,0,width,height);
  translate(width/2,height/2);
  fill(_centerColor);
  circle(0,0,_minDis-5);
  for (int i = 0; i < _planetCount; i++){
    Planet cur = planets.get(i);
    cur.drawMe();
    cur.update();
  }
}

Planet generatePlanet(int i){
  Planet myPlanet = new Planet();
  myPlanet.speed = random(_minSpeed,_maxSpeed) * randomSign();
  myPlanet.dist = splitBetween(_minDis, _maxDis, _planetCount, i);
  myPlanet.angle = random(0,360);
  myPlanet.size = random(_minSize, _maxSize);
  myPlanet.col = colorBetween(_startColor,_endColor,_planetCount,i);
  if (random(-1,3) < 0){
    Planet myMoon = new Planet();
    myMoon.speed = random(_minSpeed,_maxSpeed) * randomSign();
    myMoon.size = random(myPlanet.size/3, myPlanet.size/2);
    myMoon.dist = random(myPlanet.size+myMoon.size+1, myPlanet.size+myMoon.size+5);
    myMoon.angle = random(0,360);
    myMoon.col = varyColor(myPlanet.col);
    myPlanet.moon = myMoon;
    myPlanet.hasMoon = true;
  }
  return myPlanet;
}
