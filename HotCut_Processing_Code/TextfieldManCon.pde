class TextfieldManCon
{
  float x, y, breite, hoehe;
  int radius = 2;
  color currentcolor;
  color basecolor = color(218);
  color overcolor = color(255);

  TextfieldManCon(float TextfieldManConx, float TextfieldManCony, float TextfieldManConbreite, float TextfieldManConhoehe) 
  {
    x = TextfieldManConx;
    y = TextfieldManCony;
    breite = TextfieldManConbreite;
    hoehe =  TextfieldManConhoehe;
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
    if ( over() ) {
      currentcolor = overcolor;
    } else {
      currentcolor = basecolor;
    }
  }
  void display() 
  {
    // stroke(umrisscolor);
    fill(currentcolor);
    rect(x, y, breite, hoehe, radius);
  }
}

