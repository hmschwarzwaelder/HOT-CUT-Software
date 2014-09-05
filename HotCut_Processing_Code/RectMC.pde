class RectMC
{
  float ax, ay, bx, by, cx, cy, rx, ry, rbreite, rhoehe;
  color currentcolor;
  color basecolor = color(155);
  color overcolor = color(255);

  RectMC(float Prx, float Pry, float Prbreite, float Prhoehe, float Pax, float Pay, float Pbx, float Pby, float Pcx, float Pcy) //color Prbasecolor, color Provercolor, color Prpressedcolor
  {
    rx = Prx;
    ry = Pry;
    rbreite = Prbreite;
    rhoehe = Prhoehe;
    ax = Pax;
    ay = Pay;
    bx = Pbx;
    by = Pby;
    cx = Pcx;
    cy = Pcy;
    // basecolor = Prbasecolor;
    //overcolor = Provercolor;
    //pressedcolor = Prpressedcolor;
  }
  boolean overRectMc(float x, float y, float width, float height) 
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
    if ( overRectMc(rx, ry, rbreite, rhoehe) ) {
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

  void display ()
  {
    noStroke();
    fill(currentcolor);
    rect(rx, ry, rbreite, rhoehe);
    triangle(ax, ay, bx, by, cx, cy);
  }
}

