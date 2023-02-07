float _radius = 5;
float _posX = 0;
float _posY = 0;
float _speedX = 5;
float _speedY = 5;

void setup(){
  size(800, 600);
  _posX = width/2;
  _posY = width/2;
  noStroke();
}

void draw(){
  //drawCircle(random(width),random(height),_radius);
  drawCircle(_posX, _posY, _radius);
  
  //update x values
  _posX = newPosition(_posX, _speedX);
  _speedX = newSpeed(_posX, _speedX, _radius, width - _radius); //Modifying bounds with radius of the circle so circle doesn't clip
  //update y values
  _posY = newPosition(_posY, _speedY);
  _speedY = newSpeed(_posY, _speedY, _radius, height - _radius); //Modifying bounds with radius of the circle so circle doesn't clip
}

void drawCircle(float x, float y, float radius){
  fill(255,255,255,50);
  rect(0,0,width,height);
  fill(34, 152, 153);
  circle(x, y, radius*2);
}

//Change position by speed
float newPosition(float position, float speed){
  return position + speed;
}

//Bounce by inverting speed when circle is out of bounds
float newSpeed(float position, float speed, float lowerBound, float upperBound){
  if(inRange(position, lowerBound, upperBound)){
    return speed;
  }else{
    return speed * -1;
  }
}

//Is num above lowerBound and below upperBound?
boolean inRange(float num, float lowerBound, float upperBound){
   return num > lowerBound && num < upperBound;
}
