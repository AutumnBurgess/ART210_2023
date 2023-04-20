class Saw extends Sprite {
  float rotSpeed = 1.5;
  float moveSpeed = 1;
  
  Saw(String _id, int points, float outer, float inner, float hole, boolean middleSpikes, color col)
  {
    super(_id);
    PShape[] shapes = new PShape[1];
    PShape sawShape = makeShape(points, outer, inner, hole, middleSpikes, col);
    shapes[0] = sawShape;
    this.registerAnimation(new Animation(shapes));
    this.offset = new PVector(outer, outer);
    this.collRadius = inner-5;
    this.w = outer;
    this.h = inner;
    this.location.x = random(this.collRadius+50, width-this.collRadius);
    this.location.y = random(this.collRadius, width-this.collRadius);
    this.velocity = PVector.random2D().mult(1.5);
  }
  
  void display()
  {
    super.display();
    this.rotation += rotSpeed;
  }
  
  void update()
  {
    super.update();
    super.bounceOnBounds();
  }
}
