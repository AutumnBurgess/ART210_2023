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
