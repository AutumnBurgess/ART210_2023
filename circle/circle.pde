void setup()
{
  size(800,800);
  noStroke();
}

void draw()
{
  fill(255,255,255,10);
  rect(0,0,width,height);
  fill(0,200,150);
  circle(mouseX,mouseY,100);
}
