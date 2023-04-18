class Collision
{
  Sprite sprite;
  boolean circle = true;

  static final int IN = 1;
  static final int OUT = -1;
  static final int TOP =    0b0001;
  static final int BOTTOM = 0b0010;
  static final int LEFT =   0b0100;
  static final int RIGHT =  0b1000;

  Collision(Sprite _sprite, boolean isCircle)
  {
    this.sprite = _sprite;
    this.circle = isCircle;
  }

  int box2point(float _x, float _y, float _w, float _h)
  {
    int res = 0;
    if (this.sprite.location.x < _x) res = res + LEFT;
    if (this.sprite.location.y < _y) res = res + TOP;
    if (this.sprite.location.x > _x+_w)  res = res + RIGHT;
    if (this.sprite.location.y > _y+_h) res = res + BOTTOM;
    return(res);
  }

  int box2circle(float _x, float _y, float _w, float _h, boolean in)
  {
    int res = 0;
    if (in)
    {
      if (this.sprite.location.x-this.sprite.collRadius < _x) res = res + LEFT;
      if (this.sprite.location.y-this.sprite.collRadius < _y) res = res + TOP;
      if (this.sprite.location.x+this.sprite.collRadius > _x+_w)  res = res + RIGHT;
      if (this.sprite.location.y+this.sprite.collRadius > _y+_h) res = res + BOTTOM;
    } 
    else
    {
      if (this.sprite.location.x+this.sprite.collRadius < _x) res = res + LEFT;
      if (this.sprite.location.y+this.sprite.collRadius < _y) res = res + TOP;
      if (this.sprite.location.x-this.sprite.collRadius > _x+_w)  res = res + RIGHT;
      if (this.sprite.location.y-this.sprite.collRadius > _y+_h) res = res + BOTTOM;
    }

    return(res);
  }

  int circle2circle(Sprite sprite)
  {
    if (this.sprite.id != sprite.id)
    {
      PVector distance = PVector.sub(this.sprite.location, sprite.location);
      float d = distance.mag();
      float minDistance = (this.sprite.collRadius + sprite.collRadius)/2.0;
      if (d < minDistance) return(IN);
    }
    return(OUT);
  }

  boolean box2box(float _x, float _y, float _w, float _h)
  {
    //this.sprite.location.x, this.sprite.location.y, this.sprite.w, this.sprite.h
    //(StartMe <= EndOther) and (EndMe >= StartOther)
    float myLeft = this.sprite.location.x;
    float myRight = this.sprite.location.x + this.sprite.w;
    float myTop = this.sprite.location.y;
    float myBottom = this.sprite.location.y + this.sprite.h;
    float otherLeft = _x;
    float otherRight = _x + _w;
    float otherTop = _y;
    float otherBottom = _y + _h;

    boolean intersectHorizontal = (myLeft <= otherRight) && (myRight >= otherLeft);
    boolean intersectVertical = (myTop <= otherBottom) && (myBottom >= otherTop);
    return intersectHorizontal && intersectVertical;
  }
}
