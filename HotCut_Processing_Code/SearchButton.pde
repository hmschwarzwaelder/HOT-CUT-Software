class SearchButton
{
  float x, y;
  int radius = 2;
  color currentcolor;
  color basecolor = color(87);
  color overcolor = color(150);
  color umrisscolor = color(135);
  color pressedcolor = color(200);

  SearchButton (float SearchButtonx, float SearchButtony)
  {
    x = SearchButtonx;
    y = SearchButtony;
  }
  boolean overSearchButton(float x, float y, float width, float height, int radius) 
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
    if (overSearchButton(x, y, 55, 18, radius) ) {
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
    stroke(135);
    fill(currentcolor);
    rect(x, y, 55, 18, radius);
  }
}

