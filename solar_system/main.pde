ArrayList<Planet> planets = new ArrayList<Planet>();

void setup(){
  size(1000,1000);
  noStroke();
  //float dist, float size, float speed, color col
  Planet sun = new Planet(0, 40, 0, color(255,255,0));
  planets.add(sun);
  
  Planet mercury = new Planet(57.9, 5, 4.74, color(200));
  planets.add(mercury);
  
  Planet venus = new Planet(108.2, 15, 3.5, color(200,70,70));
  planets.add(venus);
  
  Planet earth = new Planet(149.6, 15, 2.9, color(50,200,50));
  planets.add(earth);
  
  Planet mars = new Planet(228, 7.5, 2.4, color(190,140,140));
  planets.add(mars);
  
  Planet jupiter = new Planet(778.5, 30, 13, color(255,255,255));
  planets.add(jupiter);
  
  Planet saturn = new Planet(1432.0, 18.0, 9.7, color(255,255,255));
  planets.add(saturn);
  
  Planet uranus = new Planet(2867, 20, 6.8, color(255,255,255));
  planets.add(uranus);
  
  Planet neptune = new Planet(4515, 19, 5.4, color(255,255,255));
  planets.add(neptune);
  
  Planet pluto = new Planet(5906.4, 2, 4.7, color(255,255,255));
  planets.add(pluto);
  
}

void draw(){
  fill(0,0,0,50);
  rect(0,0,width,height);
  translate(width/2,height/2);
  for (int i = 0; i < planets.size(); i++){
    Planet cur = planets.get(i);
    cur.drawMe();
    cur.update();
  }
}
