class SawShape
{
  int points;
  float outer;
  float inner;
  float holeSize = 0;
  boolean middleSpikes = false;
  color col = color(0);
  boolean transparent = false;
  static final int SMALL = 0;
  static final int BIG = 1;
  static final int WALL = 2;
  
  SawShape(int type)
  {
    switch(type)
    {
      case SMALL:
        this.points = 12;
        this.outer = 43;
        this.inner = 32;
        this.holeSize = 10;
        this.col = color(200, 50, 175);
        this.middleSpikes = true;
        break;
      case BIG:
        this.points = 21;
        this.outer = 80;
        this.inner = 65;
        this.holeSize = 18;
        this.col = color(150, 50, 50);
        break;
      case WALL:
        this.points = 15;
        this.outer = 55;
        this.inner = 43;
        this.col = color(180);
        break;
    }
  }

  SawShape(int points, float outer, float inner)
  {
    this.points = points;
    this.outer = outer;
    this.inner = inner;
  }

  SawShape clone()
  {
    SawShape c = new SawShape(this.points, this.outer, this.inner);
    c.holeSize = this.holeSize;
    c.col = this.col;
    c.middleSpikes = this.middleSpikes;
    c.transparent = this.transparent;
    return c;
  }
  
  PShape make() {
    float angle = TWO_PI / points;
    float innerOffset = middleSpikes ? angle / 2 : 0;
    
    PShape out = createShape(GROUP);
    PShape borderOutside = createShape();
    PShape borderInside = createShape();
    PShape fill = createShape();
    borderOutside.beginShape();
    borderInside.beginShape();
    fill.beginShape();
    if(this.transparent)
    {
      borderOutside.stroke(0,0,0,100);
      borderInside.stroke(0,0,0,100);
      color transparentColor = color(red(this.col), green(this.col), blue(this.col), 100);
      fill.fill(transparentColor);
    }
    else
    {
      fill.fill(col);
    }
    fill.noStroke();
    borderOutside.noFill();
    borderOutside.strokeWeight(1.5);
    borderInside.noFill();
    for (float i = 0; i <= TWO_PI; i += angle) {
      fill.vertex(outer * sin(i), outer * cos(i));
      fill.vertex(inner * sin(i+innerOffset), inner * cos(i+innerOffset));
      borderOutside.vertex(outer * sin(i), outer * cos(i));
      borderOutside.vertex(inner * sin(i+innerOffset), inner * cos(i+innerOffset));
    }
    if(holeSize != 0){
      fill.beginContour();
      for (float i = TWO_PI; i >= 0; i -= angle) {
        fill.vertex(holeSize * sin(i), holeSize * cos(i));
        borderInside.vertex(holeSize * sin(i), holeSize * cos(i));
      }
      fill.vertex(0, holeSize);
      fill.vertex(0, outer);
      borderInside.vertex(0, holeSize);
      fill.endContour();
    }
    fill.endShape();
    borderOutside.endShape();
    borderInside.endShape();
    out.addChild(fill);
    out.addChild(borderOutside);
    out.addChild(borderInside);
    return out;
  }
}
