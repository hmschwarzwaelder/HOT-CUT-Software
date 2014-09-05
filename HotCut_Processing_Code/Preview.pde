class Preview
{

  float x, y, breite, hoehe;
  int radius = 6;

  Preview (float Previewx, float Previewy, float Previewbreite, float Previewhoehe)
  {
    x = Previewx;
    y = Previewy;
    breite = Previewbreite;
    hoehe = Previewhoehe;
  }

  void display() 
  {
    noStroke();
    fill(198, 198, 197);
    rect(x, y, breite, hoehe, radius);
  }
}

