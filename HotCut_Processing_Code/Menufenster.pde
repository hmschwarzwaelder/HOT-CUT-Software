class Menufenster
{

  float x, y, breite, hoehe;
  int radius = 6;
  color basecolor = color(70);

  Menufenster(float Menufensterx, float Menufenstery, float Menufensterbreite, float Menufensterhoehe) 
  {
    x = Menufensterx;
    y = Menufenstery;
    breite = Menufensterbreite;
    hoehe = Menufensterhoehe;
  }

  void display() 
  {
    noStroke();
    fill(basecolor);
    rect(x, y, breite, hoehe, radius);
  }
} 

