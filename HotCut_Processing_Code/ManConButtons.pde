class ManConButtons
{
  float x, y, breite, hoehe;
  int radius = 2;
  color currentcolor;
  color basecolor = color(87);
  color overcolor = color(150);
  color umrisscolor = color(135);
  color pressedcolor = color(200);

  ManConButtons(float ManConButtonsx, float ManConButtonsy, float ManConButtonsbreite, float ManConButtonshoehe) 
  {
    x = ManConButtonsx;
    y = ManConButtonsy;
    breite = ManConButtonsbreite;
    hoehe = ManConButtonshoehe;
  }
  boolean overManCon(float x, float y, float width, float height, int radius) 
  {
    if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
      return true;
    } else {
      return false;
    }
  }

  boolean over() 
  {
    if (overManCon(x, y, breite, hoehe, radius) ) {
      return true;
    } else {
      return false;
    }
  }

  //Änderung von der Farbe abhängig vom Kursor
  void update()
  {
    if (over() )
    { 
      currentcolor = overcolor;
    } else {
      currentcolor = basecolor;
    }
  }
  void display() 
  {
    stroke(umrisscolor);
    fill(currentcolor);
    rect(x, y, breite, hoehe, radius);
  }
}

