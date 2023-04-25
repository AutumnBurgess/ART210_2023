class Saw extends Sprite {
  float rotSpeed = 1.5;
  float moveSpeed = 1;
  SawShape myShape;

  Saw(int _id, SawShape shape)
  {
    super(_id);
    this.myShape = shape;
    this.registerAnimation(new Animation(shape.make()));
    this.offset = new PVector(shape.outer, shape.outer);
    this.collRadius = shape.inner-5;
    this.w = shape.outer;
    this.h = shape.outer;
    this.location.x = random(this.w+50, width-this.w);
    this.location.y = random(this.w, width-this.w);
    this.velocity = PVector.random2D().mult(1.5);
  }
  
  void display()
  {
    super.display();
    this.rotation += rotSpeed;
  }
}
