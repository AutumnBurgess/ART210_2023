///////////////////////////////////////SPRITE///////////////////////////////////////
class Sprite
{
  PVector location = new PVector(width/2,height/2);
  PVector velocity = new PVector(0,0);
  PVector acceleration = new PVector(0,0);
  
  int maxAnim = 10;
  int currentAnim = 0;
  int nAnim = 0;
  Animation[] anim = new Animation[maxAnim];
  float scale = 1.0;
  float rotation = 0;
  PVector offset = new PVector(0,0);
  
  float w;
  float h;
  
  float collRadius;
  
  void registerAnimation(Animation _anim)
  {
    if(this.nAnim < this.maxAnim)
    {
      this.anim[this.nAnim]=_anim;
      this.nAnim = this.nAnim + 1;
    }
    else
    {
      println("Animation number overflow");
    }
  }
  
  void update()
  {
    this.velocity.add(this.acceleration);
    this.location.add(this.velocity);
  }
  
  void display()
  {
    pushMatrix();
      translate(this.location.x,this.location.y);
      pushMatrix();
        scale(this.scale);
        rotate(radians(this.rotation));
        translate(this.offset.x,this.offset.y);
        this.anim[this.currentAnim].display();
      popMatrix(); 
      if (DEBUG) testDisplay();   
    popMatrix();
  }
  
  void testDisplay()
  {
    noStroke();
    fill(color(255,100,100));
    circle(0,0,10);
    noFill();
    noStroke();
    fill(color(0,0,255,100));
    circle(0,0,this.collRadius*2);
    fill(0);
    textAlign(CENTER);
    textFont(fontLarge);
  }
}
///////////////////////////////////////Particle///////////////////////////////////////
class Particle extends Sprite
{
  float spinSpeed;
  Particle()
  {
    this.registerAnimation(new Animation(this.confetti()));
  }
  
  void update()
  {
    super.update();
    this.rotation += this.spinSpeed * min(this.velocity.mag(), 1);
    this.velocity.mult(0.9);
  }
  
  private PShape confetti()
  {
    //color[] selection = {color(255,0,0), color(0,255,0), color(0,0,255)};
    //color c = selection[floor(random(3))];
    colorMode(HSB, 100);
    color c = color(random(100), 90, random(90, 100));
    colorMode(RGB, 255);
    PShape out = createShape(RECT, 0, 0, 3, random(7, 17));
    out.setFill(c);
    out.setStroke(c);
    return out;
  }
}

class ParticleSpawner extends Sprite
{
  ArrayList<Particle> particles = new ArrayList<Particle>();
  float angle;
  
  ParticleSpawner(PVector location, float angle)
  {
    this.location = location;
    this.angle = angle;
    int directCount = 60;
    int spreadCount = 25;
    float directRange = PI/4;
    float spreadRange = PI/3;

    for (int i = 0; i < directCount; i++)
    {
      Particle newConf = new Particle();
      newConf.location.x = this.location.x;
      newConf.location.y = this.location.y;
      newConf.velocity = new PVector(random(4, 20), 0);
      newConf.velocity.rotate(angle);
      newConf.velocity.rotate(random(-directRange, directRange));
      newConf.spinSpeed = random(-5, 5);
      newConf.rotation = random(360);
      this.particles.add(newConf);
    }
    for (int i = 0; i < spreadCount; i++)
    {
      Particle newConf = new Particle();
      newConf.location.x = this.location.x;
      newConf.location.y = this.location.y;
      newConf.velocity = new PVector(random(4, 20), 0);
      newConf.velocity.rotate(angle);
      newConf.velocity.rotate(random(-spreadRange, spreadRange));
      newConf.spinSpeed = random(-5, 5);
      newConf.rotation = random(360);
      this.particles.add(newConf);
    }
  }
  
  void update()
  {
    for(Particle p : this.particles){
      p.update();
    }
  }
  
  void display()
  {
    for(Particle p : this.particles){
      p.display();
    }
  }
}


///////////////////////////////////////ANIMATION///////////////////////////////////////
class Animation
{
  PShape[] framesS;
  PImage[] framesI;
  int nFrames = 0;
  int currentFrame = 0;
  float speed = 0.1;
  float counter = 0;
  boolean isSvg = true;
  
  Animation(String foldername, String ext)
  {
    File dir= new File(dataPath(foldername));
    File[] files= dir.listFiles();
    //println(files);
    Arrays.sort(files);
    if(ext == "svg")
    {
      this.isSvg=true;
      this.framesS = new PShape[files.length];
      for(int i = 0; i <= files.length - 1; i++)
      {
        String path = files[i].getAbsolutePath();
        if(path.toLowerCase().endsWith(".svg"))
        {
          //println(path);
          this.framesS[this.nFrames]=loadShape(path);
          this.nFrames = this.nFrames + 1;
        }
      }  
    }
    else
    {
      this.isSvg=false;
      this.framesI = new PImage[files.length];
      for(int i = 0; i <= files.length - 1; i++)
      {
        String path = files[i].getAbsolutePath();
        if(path.toLowerCase().endsWith(".jpg") || path.toLowerCase().endsWith(".png"))
        {
          this.framesI[this.nFrames]=loadImage(path);
          this.nFrames = this.nFrames + 1;
        }
      }   
    }  
  }
  
  Animation(PShape[] _shapes)
  {
    this.isSvg = true;
    this.framesS = _shapes;
  }
  
  Animation(PShape _shape)
  {
    this.isSvg = true;
    this.framesS = new PShape[1];
    this.framesS[0] = _shape;
  }
  
  Animation(PImage[] _images)
  {
    this.isSvg = false;
    this.framesI = _images;
  }
  
  Animation(PImage _image)
  {
    this.isSvg = true;
    this.framesI = new PImage[1];
    this.framesI[0] = _image;
  }
  
  void display()
  {
    if(isSvg)
    {
      shapeMode(CENTER);
      shape(this.framesS[this.currentFrame],0,0);
    }
    else
    {
      imageMode(CENTER);
      image(this.framesI[this.currentFrame],0,0);
    }
    
    this.counter = this.counter + this.speed;
    this.currentFrame = floor(this.counter);
    if(this.currentFrame > this.nFrames-1)
    {
      this.counter=0;
      this.currentFrame=0;
    }
  }
}

///////////////////////////////////////COLLISION///////////////////////////////////////
class Collision
{
  Sprite sprite;
  boolean circle = true;
  
  static final int IN = 0;
  static final int OUT = -1;
  static final int TOP = 1;
  static final int BOTTOM = 10;
  static final int LEFT = 100;
  static final int RIGHT = 1000;
  static final int TOP_LEFT = 101;
  static final int BOTTOM_LEFT = 110;
  static final int TOP_RIGHT = 1001;
  static final int BOTTOM_RIGHT = 1010;

  Collision(Sprite _sprite, boolean isCircle)
  {
    this.sprite = _sprite;
    this.circle = isCircle;
  }
  
  int box2point(float _x, float _y, float _w,float _h)
  {
    int res = 0;
    if(this.sprite.location.x < _x) res = res + LEFT;
    if(this.sprite.location.y < _y) res = res + TOP;
    if(this.sprite.location.x > _x+_w)  res = res + RIGHT;
    if(this.sprite.location.y > _y+_h) res = res + BOTTOM;
    return(res);
  }
  
  int box2circle(float _x, float _y, float _w,float _h, boolean in)
  {
    int res = 0;
    if(in)
    {
      if(this.sprite.location.x-this.sprite.collRadius < _x) res = res + LEFT;
      if(this.sprite.location.y-this.sprite.collRadius < _y) res = res + TOP;
      if(this.sprite.location.x+this.sprite.collRadius > _x+_w)  res = res + RIGHT;
      if(this.sprite.location.y+this.sprite.collRadius > _y+_h) res = res + BOTTOM;
    }
    else
    {
      if(this.sprite.location.x+this.sprite.collRadius < _x) res = res + LEFT;
      if(this.sprite.location.y+this.sprite.collRadius < _y) res = res + TOP;
      if(this.sprite.location.x-this.sprite.collRadius > _x+_w)  res = res + RIGHT;
      if(this.sprite.location.y-this.sprite.collRadius > _y+_h) res = res + BOTTOM;
    }
    return(res);
  }
  
  int circle2circle(Sprite sprite)
  {
    PVector distance = PVector.sub(this.sprite.location,sprite.location);
    float d = distance.mag();
    float minDistance = (this.sprite.collRadius + sprite.collRadius);
    if(d < minDistance) return(IN);
    return(OUT);
  }
  
  //boolean box2box(float _x, float _y, float _w, float _h)
  //{
  //  float myLeft = this.sprite.location.x;
  //  float myRight = this.sprite.location.x + this.sprite.w;
  //  float myTop = this.sprite.location.y;
  //  float myBottom = this.sprite.location.y + this.sprite.h;
  //  float otherLeft = _x;
  //  float otherRight = _x + _w;
  //  float otherTop = _y;
  //  float otherBottom = _y + _h;

  //  boolean intersectHorizontal = (myLeft <= otherRight) && (myRight >= otherLeft);
  //  boolean intersectVertical = (myTop <= otherBottom) && (myBottom >= otherTop);
  //  return intersectHorizontal && intersectVertical;
  //}
}

///////////////////////////////////////AUDIO///////////////////////////////////////
class Audio
{
  PApplet app;
  
  Song[] song = new Song[5];
  int nSong = 0;
  IntDict musicNames = new IntDict();
  
  SoundEffect[] effects = new SoundEffect[10];
  int nEffect = 0;
  IntDict effectNames = new IntDict();
  
  Audio(PApplet app_)
  {
    this.app = app_;
  }
  
  void update()
  {
    for(int i = 0; i < nSong; i++)
    {
      song[i].update();
    }
  }
  
  void addMusic(String filename, String name)
  {
    Song f = new Song(this.app, filename);
    if(this.nSong >= 5){
      println("Too many music files");
      return;
    }
    song[nSong] = f;
    musicNames.add(name, nSong);
    nSong ++;
  }
  
  void playSong(String name)
  {
    int m = musicNames.get(name);
    song[m].play();
  }
  
  void stopSong(String name)
  {
    int m = musicNames.get(name);
    song[m].stop();
  }
  
  void addEffect(SoundEffect effect, String name)
  {
    if(this.nEffect >= 10){
      println("Too many effects");
      return;
    }
    effects[nEffect] = effect;
    effectNames.add(name, nEffect);
    nEffect ++;
  }
  
  void playEffect(String name){
    int e = effectNames.get(name);
    effects[e].play();
  }
}

///////////////////////////////////////SONG///////////////////////////////////////
class Song
{
  PApplet app;
  SoundFile file;
  float level = 0;
  
  Song(PApplet app_, String filename)
  {
    this.app = app_;
    this.file = new SoundFile(this.app, filename);
    this.file.jump(5);
  }
  
  void update()
  {
    this.file.amp(level);
    if(this.level == 0){
      this.file.stop();
    }
  }
  
  void play()
  {
    if(this.level != 0){
      this.level = 0;
      file.stop();
    }
    file.loop();
    Ani.to(this, 1, "level", 1);
  }
  
  void stop()
  {
    Ani.to(this, 1, "level", 0);
  }
}

///////////////////////////////////////SOUND EFFECT///////////////////////////////////////
class SoundEffect
{
  PApplet app;
  TriOsc osc;
  WhiteNoise noise;
  Env env;
  float attackTime = 0.001;
  float sustainTime = 0.004;
  float sustainLevel = 0.3;
  float releaseTime = 0.4;
  boolean isOsc = true;
  
  SoundEffect(PApplet app_, boolean io_, float at_, float st_, float sl_, float rt_)
  {
    this.app = app_;
    this.isOsc = io_;
    this.attackTime = at_;
    this.sustainTime = st_;
    this.sustainLevel = sl_;
    this.releaseTime = rt_;
    if (this.isOsc)
    {
      osc = new TriOsc(this.app);
    }
    else
    {
      noise = new WhiteNoise(this.app);
    }
    env = new Env(this.app);
  }
  
  void play(){
    if (this.isOsc)
    {
      osc.play();
      env.play(osc, this.attackTime, this.sustainTime, this.sustainLevel, this.releaseTime);
    }
    else
    {
      noise.play();
      env.play(noise, this.attackTime, this.sustainTime, this.sustainLevel, this.releaseTime);
    }
  }
}
