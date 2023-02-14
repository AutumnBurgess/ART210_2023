class Planet {
  float angle = 0.0;
  float dist = 100.0;
  float speed = 1.0;
  float size = 10.0;
  color col = color(255);
  boolean hasMoon = false;
  Planet moon;

  void drawMe(){
    pushMatrix();
      fill(this.col);
      rotate(radians(this.angle));
      translate(0,this.dist);
      circle(0,0,this.size);
      if (this.hasMoon){
        fill(this.moon.col);
        rotate(radians(this.moon.angle));
        translate(0,this.moon.dist);
        circle(0,0,this.moon.size);
      }
    popMatrix();
  }
  void update(){
    this.angle += this.speed / (this.size/2);
    if (this.hasMoon){
      this.moon.angle += this.moon.speed / (this.moon.size/2);
    }
  }
}
