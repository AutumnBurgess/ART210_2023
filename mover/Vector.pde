class Ball {
  PVector location;
  PVector velocity;
  PVector acceleration;
  color col;

  Ball(PVector l_, PVector v_, PVector a_) {
    location = l_;
    velocity = v_;
    acceleration = a_;
    col = color(random(0,100), random(50,100), random(50,100));
  }

  void drawMe() {
    fill(col);
    circle(location.x, location.y, _radius*2);
  }

  void move() {
    velocity.add(acceleration);
    location.add(velocity);
  }

  void bounce(float left, float right, float top, float bottom) {
    boolean bounceX = clampX(left, right);
    boolean bounceY = clampY(top, bottom);
    if (bounceX) {
      velocity.x *= -_bounceMult;
    }
    if (bounceY) {
      velocity.y *= -_bounceMult;
    }
  }

  boolean clampX(float min, float max) {
    float last = location.x;
    location.x = max(location.x, min);
    location.x = min(location.x, max);
    return last != location.x;
  }

  boolean clampY(float min, float max) {
    float last = location.y;
    location.y = max(location.y, min);
    location.y = min(location.y, max);
    return last != location.y;
  }
  
  boolean isOnFloor(){
    return abs(velocity.y) < 0.25;
  }
}
