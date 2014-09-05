class infoButton
{

  float x, y, breite, hoehe;
  int radius = 2;
  color basecolor = color(35);

  infoButton(float infoButtonx, float infoButtony, float infoButtonbreite, float infoButtonhoehe) 
  {
    x = infoButtonx;
    y = infoButtony;
    breite = infoButtonbreite;
    hoehe = infoButtonhoehe;
  }

  void display() 
  {
    stroke(135);
    fill(basecolor);
    rect(x, y, breite, hoehe, radius);
  }
}

