class SearchFenster
{
  float x, y, breite, hoehe;
  int radius = 6;

  SearchFenster (float SearchFensterx, float SearchFenstery, float SearchFensterbreite, float SearchFensterhoehe)
  {
    x = SearchFensterx;
    y = SearchFenstery;
    breite = SearchFensterbreite;
    hoehe = SearchFensterhoehe;
  }

  void display() 
  {
    noStroke();
    fill(198, 198, 197);
    rect(x, y, breite, hoehe, radius);
  }
}

