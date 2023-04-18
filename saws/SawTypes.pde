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

class SawBuilder
{
  String _id;
  int points;
  float outer;
  float inner;
  float hole;
  float collRadius;
  boolean middleSpikes = false;
  color col = color(200);
}
