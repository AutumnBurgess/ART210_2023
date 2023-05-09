class SawShape
{
  int points;
  float outer;
  float inner;
  float holeSize = 0;
  float angle;
  float innerOffset;
  boolean middleSpikes = false;
  color col = color(0);
  
  float ringSize = 0;
  color ringCol = color(0);
  
  boolean transparent = false;
  SawShape(SawType type)
  {
    switch(type)
    {
      case FAST:
        this.points = 12;
        this.outer = 43;
        this.inner = 32;
        this.holeSize = 10;
        this.col = color(200, 50, 175);
        this.ringSize = 20;
        this.ringCol = color(175, 75, 158);
        break;
      case SLOW:
        this.points = 21;
        this.outer = 80;
        this.inner = 65;
        this.holeSize = 18;
        this.col = color(150, 50, 50);
        this.ringSize = 45;
        this.ringCol = color(200, 100, 100);
        break;
      case TOPWALL:
      case BOTTOMWALL:
      case LEFTWALL:
      case RIGHTWALL:
        this.points = 15;
        this.outer = 75;
        this.inner = 63;
        this.ringSize = 35;
        this.ringCol = color(100);
        this.holeSize = 20;
        this.col = color(180);
        break;
      case STICKY:
        this.points = 23;
        this.outer = 30;
        this.inner = 24;
        this.holeSize = 10;
        this.col = color(50,200,45);
        break;
      case DROPPER:
        this.points = 35;
        this.outer = 40;
        this.inner = 32;
        this.middleSpikes = true;
        this.col = color(130,22,245);
        break;
      case DROPPED:
        this.points = 8;
        this.outer = 20;
        this.inner = 15;
        this.middleSpikes = true;
        this.col = color(202, 103, 235);
        break;
      case MIDDLE:
        this.points = 70;
        this.outer = 150;
        this.inner = 110;
        this.holeSize = 100;
        this.middleSpikes = true;
        this.col = color(5);
        break;
      case CHASER:
        this.points = 15;
        this.outer = 40;
        this.inner = 32;
        this.col = color(230, 28, 54);
        break;
    }
    this.angle = TWO_PI / points;
    this.innerOffset = middleSpikes ? angle / 2 : 0;
  }

  private SawShape()
  {
  }

  SawShape clone()
  {
    SawShape c = new SawShape();
    c.points = this.points;
    c.outer = this.outer;
    c.inner = this.inner;
    c.holeSize = this.holeSize;
    c.angle = this.angle;
    c.innerOffset = this.innerOffset;
    c.col = this.col;
    c.ringSize = this.ringSize;
    c.ringCol = this.ringCol;
    c.middleSpikes = this.middleSpikes;
    c.transparent = this.transparent;
    return c;
  }
  
  PShape make() {
    PShape out = createShape(GROUP);
    out.addChild(this.makeFill());
    out.addChild(this.makeOutsideBorder());
    if(ringSize != 0) 
    {
      out.addChild(this.makeRing());
      out.addChild(this.makeRingBorder());
    }
    if(holeSize != 0) out.addChild(this.makeInsideBorder());
    
    
    return out;
  }
  
  private PShape makeFill()
  {
    PShape fill = createShape();
    fill.beginShape();
    fill.noStroke();
    color transparentCol = color(red(this.col), green(this.col), blue(this.col), 100);
    fill.fill(this.transparent ? transparentCol : col);
    for (float i = 0; i <= TWO_PI; i += angle) {
      fill.vertex(outer * sin(i), outer * cos(i));
      fill.vertex(inner * sin(i+innerOffset), inner * cos(i+innerOffset));
    }
    
    if(holeSize != 0){
      fill.beginContour();
      for (float i = TWO_PI; i >= 0; i -= angle) {
        fill.vertex(holeSize * sin(i), holeSize * cos(i));
      }
      fill.vertex(0, holeSize);
      fill.vertex(0, outer);
      fill.endContour();
    }
    
    fill.endShape();
    return fill;
  }
  
  private PShape makeOutsideBorder()
  {
    PShape borderOutside = createShape();
    borderOutside.beginShape();
    
    borderOutside.noFill();
    borderOutside.strokeWeight(1.5);
    if(this.transparent)
    {
      borderOutside.stroke(0,0,0,100);
    }
    for (float i = 0; i <= TWO_PI; i += angle) {
      borderOutside.vertex(outer * sin(i), outer * cos(i));
      borderOutside.vertex(inner * sin(i+innerOffset), inner * cos(i+innerOffset));
    }
    
    borderOutside.vertex(0, outer);
    
    borderOutside.endShape();
    
    return borderOutside;
  }
  
  private PShape makeInsideBorder()
  {
    PShape insideBorder = createShape();
    insideBorder.beginShape();
    insideBorder.noFill();
    if(this.transparent) insideBorder.stroke(0,0,0,100);
    
    for (float i = TWO_PI; i >= 0; i -= angle) {
      insideBorder.vertex(holeSize * sin(i), holeSize * cos(i));
    }
    insideBorder.vertex(0, holeSize);
    insideBorder.endShape();

    return insideBorder;
  }
  
  private PShape makeRing()
  {
    PShape ring = createShape();
    
    ring.beginShape();
    ring.noStroke();
    color ringTransparent = color(red(this.ringCol), green(this.ringCol), blue(this.ringCol), 100);
    ring.fill(this.transparent ? ringTransparent: ringCol);
    
    for (float i = 0; i <= TWO_PI; i += angle) {
      ring.vertex(ringSize * sin(i), ringSize * cos(i));
    }
    if(holeSize != 0){
      ring.beginContour();
      for (float i = TWO_PI; i >= 0; i -= angle) {
        ring.vertex((holeSize + 1) * sin(i), (holeSize + 1) * cos(i));
      }
      ring.endContour();
    }
    ring.endShape();
    return ring;
  }
  
  private PShape makeRingBorder()
  {
    PShape ringBorder = createShape();
    ringBorder.beginShape();
    ringBorder.noFill();
    if(this.transparent) ringBorder.stroke(0,0,0,100);
    for (float i = 0; i <= TWO_PI; i += angle) {
      ringBorder.vertex(ringSize * sin(i), ringSize * cos(i));
    }
    ringBorder.endShape();
    return ringBorder;
  }
}
