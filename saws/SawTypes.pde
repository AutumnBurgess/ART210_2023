PShape makeShape(int points, float outer, float inner, float hole, boolean middleSpikes, color col) {
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

//Saw(String _id, int points, float outer, float inner, float hole, boolean middleSpikes, color col)
PShape[] sawShapeArr = new PShape[2];
IntDict sawShapes = new IntDict();

void createSaws()
{
  PShape small = makeShape(12, 43, 32, 10, true, color(200, 50, 175));
  sawShapeArr[0] = small;
  sawShapes.set("small", 0);
  
  PShape large = makeShape(20, 80, 65, 18, false, color(150, 50, 50));
  sawShapeArr[1] = large;
  sawShapes.set("large", 1);
}

class SawFast extends Saw
{
  SawFast(String _id)
  {
    super(_id, 12, 43, 32, 10, true, color(200, 50, 175));
    this.velocity = PVector.random2D().mult(5);
    this.rotSpeed = 3;
  }
}

class SawSlow extends Saw
{
  SawSlow(String _id)
  {
    super(_id, 20, 80, 65, 18, false, color(150, 50, 50));
    this.velocity = PVector.random2D().mult(2);
  }
}
