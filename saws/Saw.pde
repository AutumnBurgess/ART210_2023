class Saw extends Sprite {
  
  Saw(String _id, int points, float outer, float inner, float hole, boolean middleSpikes)
  {
    super(_id);
    PShape[] shapes = new PShape[1];
    PShape sawShape = makeShape(points, outer, inner, hole, middleSpikes);
    shapes[0] = sawShape;
    this.registerAnimation(new Animation(shapes));
    this.offset = new PVector(outer/2, outer/2);
    this.collRadius = inner;
    this.w = outer;
    this.h = outer;
  }
  
  void display()
  {
    super.display();
    this.rotation += 1.5;
  }
  
  void check()
  {
    super.bounce(this.w, width-this.w, this.w, height-this.w);
  }
  
  private PShape makeShape(int points, float outer, float inner, float hole, boolean middleSpikes) {
    float angle = TWO_PI / points;
    PShape out = createShape();
    float innerOffset = middleSpikes ? angle / 2 : 0;
    out.beginShape();
    out.fill(150, 50, 50);
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
