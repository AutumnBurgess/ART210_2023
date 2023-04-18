class Saw extends Sprite {
  float rotSpeed = 1.5;
  
  Saw(String _id, int points, float outer, float inner, float hole, boolean middleSpikes, color col)
  {
    super(_id);
    PShape[] shapes = new PShape[1];
    PShape sawShape = this.makeShape(points, outer, inner, hole, middleSpikes, col);
    shapes[0] = sawShape;
    this.registerAnimation(new Animation(shapes));
    this.offset = new PVector(outer, outer);
    this.collRadius = inner-5;
    this.w = outer;
    this.h = outer;
    this.location.x = random(this.w+50, width-this.w);
    this.location.y = random(this.h, width-this.h);
    this.velocity = PVector.random2D().mult(1.5);
  }
  
  void display()
  {
    super.display();
    this.rotation += rotSpeed;
  }
  
  void check()
  {
    float left = this.w;
    float right = width-this.w;
    float top = this.h;
    float bottom = height-this.h;
    this.location.x = constrain(this.location.x, left, right);
    if(this.location.x <= left || this.location.x >= right){
      this.velocity.x *= -1;
    }
    
    this.location.y = constrain(this.location.y, top, bottom);
    if(this.location.y <= top || this.location.y >= bottom){
      this.velocity.y *= -1;
    }
  }
  
  private PShape makeShape(int points, float outer, float inner, float hole, boolean middleSpikes, color col) {
    float angle = TWO_PI / points;
    float innerOffset = middleSpikes ? angle / 2 : 0;
    
    PShape out = createShape();
    out.beginShape();
    out.fill(col);
    out.noStroke();
    for (float i = 0; i <= TWO_PI; i += angle) {
      out.vertex(outer * sin(i), outer * cos(i));
      out.vertex(inner * sin(i+innerOffset), inner * cos(i+innerOffset));
    }
    if(hole != 0){
      out.beginContour();
      for (float i = TWO_PI; i >= 0; i -= angle) {
        out.vertex(hole * sin(i), hole * cos(i));
      }
      out.vertex(0, hole);
      out.vertex(0, outer);
      out.endContour();
    }
    out.endShape();
    return out;
  }
}
