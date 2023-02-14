class Planet {
  float angle = 0.0;
  float dist = 100.0;
  float speed = 1.0;
  float size = 10.0;
  color col = color(255);
  
  //Planet(float angle, float dist, float speed, float size, color col, boolean hasMoon){
  //  this.angle = angle;
  //  this.dist = dist;
  //  this.speed = speed;
  //  this.size = size;
  //  this.col = col;
  //  if (hasMoon){
  //    this.makeMoon();
  //  }
  //}
  Planet(float dist, float size, float speed, color col){
    this.dist = dist/2.5;
    this.size = size;
    this.speed = speed;
    this.col = col;
  }
  
  void drawMe(){
    pushMatrix();
      fill(this.col);
      rotate(radians(this.angle));
      translate(0,this.dist);
      circle(0,0,this.size);
      //if (this.hasMoon){
      //  fill(this.moon.col);
      //  rotate(radians(this.moon.angle));
      //  translate(0,this.moon.dist);
      //  circle(0,0,this.moon.size);
      //}
    popMatrix();
  }
  void update(){
    this.angle += this.speed;
  }
}
