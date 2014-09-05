class ButtonsKreuz {             // Anzeige der Buttons

  float x, y, breite, hoehe;
  int radius = 2;
  color basecolor = color(218);
 
  ButtonsKreuz(float ButtonsKreuzx, float ButtonsKreuzy) 
  {
    x = ButtonsKreuzx;
    y = ButtonsKreuzy;
  }

  boolean overButtonsKreuz(float x, float y, float width, float height, int radius)
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
    if ( overButtonsKreuz (x, y, 14, 12, radius) ) {
      return true;
    } else {
      return false;
    }
  }

  void display() 
  {
    fill(basecolor);
    rect(x, y, 14, 12, radius);
  }

  void kreuz()
  {
    stroke(0);
    line(x+2, y+2, x+12, y+10);
    line(x+12, y+2, x+2, y+10);
  }
} 

