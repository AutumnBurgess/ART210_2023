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
  float h = (50 + hue(start)) % 100;
  float s = (random(-20,20) + saturation(start)) % 100;
  float b = (random(-20,20) + brightness(start)) % 100;
  return color(h, s, b);
}

color colorBetween(color min, color max, int count, int i){
  float h = splitBetween(hue(min), hue(max), count, i);
  float s = splitBetween(saturation(min), saturation(max), count, i);
  float b = splitBetween(brightness(min), brightness(max), count, i);
  return color(h,s,b);
}

color varyColor(color start){
  float h = (random(-15,15) + hue(start)) % 100;
  float s = (random(-20,20) + saturation(start)) % 100;
  float b = (random(-20,20) + brightness(start)) % 100;
  return color(h, s, b);
}
