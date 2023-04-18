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
    song[m].fadeIn();
  }
  
  void stopSong(String name)
  {
    int m = musicNames.get(name);
    song[m].fadeOut();
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
