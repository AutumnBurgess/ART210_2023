enum SawType
{
  SLOW, FAST, TOPWALL, BOTTOMWALL, LEFTWALL, RIGHTWALL, STICKY, DROPPED, DROPPER, MIDDLE, CHASER
}
enum SawBehavior
{
  BOUNCE, WALL, STICK, DISAPPEAR, TRAIL, CHASE, ENDGAME
}
class Saw extends Sprite {
  float rotSpeed = 1.5;
  float moveSpeed = 1;
  boolean stopRotation = false;
  boolean onWall = false;
  boolean gone = false;
  float count = 0;
  int displayOrder = 0;
  PVector nextVelocity = new PVector(0, 0);
  Room room;
  SawShape myShape;
  SawType type;
  ArrayList<SawBehavior> behaviors;
  float parameter;
  float extraOffset = 2;

  Saw(SawShape shape, Room r)
  {
    this.myShape = shape;
    this.registerAnimation(new Animation(this.myShape.make()));
    float offsetAmount = this.myShape.outer + extraOffset;
    this.offset = new PVector(offsetAmount, offsetAmount);
    this.collRadius = max(this.myShape.outer-20, this.myShape.inner - 5);
    this.w = this.myShape.outer;
    this.h = this.myShape.outer;
    this.room = r;
  }

  int getDisplayOrder()
  {
    return this.displayOrder;
  }

  void display()
  {
    if (!this.gone)
    {
      super.display();
      if (!stopRotation) this.rotation += rotSpeed;
    }
  }

  void update()
  {
    super.update();
    for(SawBehavior b : this.behaviors)
    {
      switch(b)
      {
        case BOUNCE:
          this.bounce();
          break;
        case WALL:
          this.wall();
          break;
        case STICK:
          this.stickyBounce();
          break;
        case DISAPPEAR:
          this.disappear();
          break;
        case TRAIL:
          this.drop();
          break;
        case CHASE:
          this.chase();
          break;
        case ENDGAME:
          this.endGame();
      }
    }
  }
  
  void endGame()
  {
    this.room.hideTimer = true;
    if (game_state == GAME_OVER && !picker.unlocked[picker.DARK]) 
    {
      nowUnlocking = picker.DARK;
      setGameState(UNLOCK);
    }
    if (game_state == UNLOCK)
    {
      ParticleSpawner ps = this.room.confetti;
      for (Particle p : ps.particles)
      {
        PVector dir = PVector.sub(this.location, p.location);
        p.velocity.add(dir.normalize().mult(0.2));
      }
      Player p = this.room.player;
      PVector dir = PVector.sub(this.location, p.location);
      p.velocity.add(dir.normalize().mult(0.1));
    }
  }
  
  void chase()
  {
    PVector playerPull = PVector.sub(this.room.player.location, this.location);
    float playerDist = playerPull.mag();
    playerPull.normalize();
    playerPull.mult(0.5);
    PVector rand = PVector.random2D();
    rand.mult(random(1));
    acceleration = PVector.lerp(playerPull, rand, min(playerDist / 500,1));
    velocity.limit(this.moveSpeed);
  }

  void disappear()
  {
    this.count++;
    if (this.count >= this.parameter)
    {
      this.gone = true;
    }
  }

  void drop()
  {
    this.count--;
    if (this.count <= 0)
    {
      Saw newSaw = SAW_BUILDERS.get(SawType.DROPPED).build(this.room);
      newSaw.rotation = random(0,TWO_PI);
      newSaw.location = this.location.copy();
      room.addSaw(newSaw);
      this.count = parameter;
    }
  }

  void stickyBounce()
  {
    if (!this.onWall)
    {
      float left = this.collRadius;
      float right = width-this.collRadius;
      float top = this.collRadius;
      float bottom = height-this.collRadius;

      if (this.location.x <= left || this.location.x >= right || this.location.y <= top || this.location.y >= bottom)
      {
        this.nextVelocity.x = this.velocity.x;
        this.nextVelocity.y = this.velocity.y;
        if (this.location.x <= left || this.location.x >= right)
        {
          this.location.x = constrain(this.location.x, left, right);
          this.nextVelocity.x = - this.nextVelocity.x;
        }
        if (this.location.y <= top || this.location.y >= bottom)
        {
          this.location.y = constrain(this.location.y, top, bottom);
          this.nextVelocity.y = - this.nextVelocity.y;
        }
        this.velocity.x = 0;
        this.velocity.y = 0;
        this.onWall = true;
        this.stopRotation = true;
        this.count = parameter;
      }
    } else
    {
      this.count --;
      if (this.count == 0)
      {
        this.onWall = false;
        this.stopRotation = false;
        this.velocity.x = this.nextVelocity.x;
        this.velocity.y = this.nextVelocity.y;
      }
    }
  }

  void bounce()
  {
    float left = this.w;
    float right = width-this.w;
    float top = this.h;
    float bottom = height-this.h;
    if (this.location.x <= left || this.location.x >= right) {
      this.location.x = constrain(this.location.x, left, right);
      this.velocity.x *= -1;
    }

    if (this.location.y <= top || this.location.y >= bottom) {
      this.location.y = constrain(this.location.y, top, bottom);
      this.velocity.y *= -1;
    }
  }

  void wall()
  {
    this.location.x = constrain(this.location.x, 0, width);
    this.location.y = constrain(this.location.y, 0, height);
    boolean onLeft = this.location.x == 0;
    boolean onRight = this.location.x == width;
    boolean onTop = this.location.y == 0;
    boolean onBottom = this.location.y == height;

    if (onLeft && !onTop)
    {
      this.velocity.x = 0;
      this.velocity.y = -this.moveSpeed;
    }
    if (onTop && !onRight)
    {
      this.velocity.x = this.moveSpeed;
      this.velocity.y = 0;
    }
    if (onRight && !onBottom)
    {
      this.velocity.x = 0;
      this.velocity.y = this.moveSpeed;
    }
    if (onBottom && !onLeft)
    {
      this.velocity.x = -this.moveSpeed;
      this.velocity.y = 0;
    }
  }
}
