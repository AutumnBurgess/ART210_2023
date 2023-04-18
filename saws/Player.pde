class Player extends Sprite
{
  float max_speed = 3;
  float button_acc = 0.2;
  
  Player(String id)
  {
    super(id);
    //this.acceleration = new PVector(0.01,0);
    this.registerAnimation(new Animation("player","svg"));
    this.registerAnimation(new Animation("player_walking","svg"));
    this.location.x = 60;
  }
}
