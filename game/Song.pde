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
  
  void fadeIn()
  {
    if(this.level != 0){
      this.level = 0;
      file.stop();
    }
    file.loop();
    Ani.to(this, 1, "level", 1);
  }
  
  void fadeOut()
  {
    Ani.to(this, 1, "level", 0);
  }
}
