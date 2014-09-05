class SliderCustom {
  int x, y, w, h;
  int p;
  int t;
  int tw;
  int s;
  int sw;
  int psw;
  color cor;
  boolean slide;
  int X_AXIS = 2;
  color c1;
  color c2;
  color currentcolor;
  color basecolor = color (255, 255, 255, 100);
  color overcolor = color (255, 255, 255, 200);


  SliderCustom (int _x, int _y, int _w, int _h, color _c1, color _c2) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    p = 0;
    c1 = _c1;
    c2 = _c2;
    slide = true;
  }

  boolean overSliderCustom(int xa, int ya, int xb, int yb, int xc, int yc) 
  {
    if (mouseX >= xa && mouseX <= xb && 
      mouseY >= ya && mouseY <= yc) {
      return true;
    } else {
      return false;
    }
  }

  boolean over() 
  {
    if ( overSliderCustom(p+x, y, p+x+8, y, p+x+4, y+h)) {
      return true;
    } else {
      return false;
    }
  }

  void update()
  {
    currentcolor = basecolor;
  }

  //Änderung von der Farbe abhängig vom Kursor
  void updateover() 
  {
    if ( over() ) {
      currentcolor = overcolor;
    } else {
      currentcolor = basecolor;
    }
  }

  void render() {
    t = round(p*3);
    tw = int (map(p, 0, w-5, 0, 255));
    s = round(p*1.8);
    sw = int (map(p, 0, w-5, 0, 3000));
    psw = int (map(p, 0, w-5, 7000, 700));
    setGradient(x, y, w, h, c2, c1, X_AXIS);
    noStroke();
    fill(currentcolor);
    triangle(p+x, y, p+x+7, y, p+x+3.5, y+h);



    if (slide==true && mousePressed==true && mouseY<y+h && mouseY>y) {
      if ((mouseX<=x+w) && (mouseX>=x)) {
        p = (mouseX-x);
        if (p<0) {
          p=0;
        } else if (p>w-5) {
          p=w-5;
        }
      }
    }
  }  

  void setGradient(int x, int y, float breite, float hoehe, color c1, color c2, int axis) {
    noFill();

    if (axis == X_AXIS) {  // Links nach Rechts Gradient
      for (int i = x; i <= x+breite; i++) {
        float inter = map(i, x, x+breite, 0.1, 1);
        color c = lerpColor(c1, c2, inter);
        stroke(c);
        line(i, y, i, y+hoehe);
      }
    }
  }

  void renderTWert() {
    fill(255);
    text(t, x+w+5, y+10);
  }
  void renderSWert() {
    fill(255);
    text(sw, x+w+5, y+10);
  }
}

