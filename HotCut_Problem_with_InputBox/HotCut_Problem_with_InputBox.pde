import java.awt.*;
import java.io.File;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import g4p_controls.*;
import processing.serial.*;
import geomerative.*;

// Part of Styrosimulation
Serial serialPort;
RPoint[] points;
int i = 0;
float scaleFactor = 1;
int msgQueue[];
int lstMsg;
int wait = 0;
boolean CutLaunch;

Menufenster fUpload, fStart;
SearchFenster fileUpload;
SearchButton buttonSearch;
Preview fStartPreview ;
ManConButtons cutStartB;




PFont myFont, myFontitalic, myFontsmall, myFontFileName, DrawFont;
PShape review;
String ChoosedFile;

void setup ()
{ 
  // Part of Styrosimulation
  msgQueue = new int[0];

  size (800, 600);                   
  smooth();       

  fUpload     = new Menufenster(359, 75.1, 218, 100);
  fStart      = new Menufenster(359, 240, 400, 318);
  fileUpload = new SearchFenster(386, 122, 164, 39);
  buttonSearch = new SearchButton(494, 95);
  fStartPreview = new Preview (386, 336, 345, 194);
  cutStartB = new ManConButtons(386, 300, 34, 18);
  myFontitalic= createFont("Verdana Italic", 14); 
  myFont= createFont("Verdana", 11);
  myFontsmall= createFont("Verdana", 10);
  myFontFileName = createFont("Verdana", 8.5);

  DrawFont = createFont("Verdana", 14);
}

void draw() 
{ 
  print("CutLaunch : ");
  println(CutLaunch);
  /*
    background(35);
   fUpload.display();
   fileUpload.display();
   fStart.display();
   fStartPreview.display();
   buttonSearch.display();
   buttonSearch.update();
   cutStartB.display();
   cutStartB.update();
   
   stroke(157);
   line(489, 158, 507, 158);               
   text();
   PreviewFileName();
   */

  if (CutLaunch) {
    PreviewCutting();
  } else {
    background(35);
    fUpload.display();
    fileUpload.display();
    fStart.display();
    fStartPreview.display();
    buttonSearch.display();
    buttonSearch.update();
    cutStartB.display();
    cutStartB.update();
    stroke(157);
    line(436, 108, 454, 108);               
    text();
    PreviewFileName();
    PreviewFileDrawing();
  }
}
void text() 
{
  textFont(myFontitalic);
  fill(157);                          
  textAlign(LEFT);
  text ("UPLOAD", 391, 62);  
  text ("START", 391, 224);

  textFont(myFont);            
  fill(255);                
  textAlign(LEFT);
  text ("SEARCH", 500, 109);
  text ("CUT", 392, 313);             
  fill (135);
  text ("PREVIEW FILE", 655, 313);

  textFont(myFontsmall);
  fill(157);                
  textAlign(LEFT);                  
  text ("(      .svg)", 430, 109);
  //text(File, 483, 159);
}

void PreviewFileName() {
  if (ChoosedFile == null) {
    //fileUpload.display();
    textFont(myFontFileName);
    fill(255);
    text("No File Selected", 395, 145);
  } else {
    //fileUpload.display();
    textFont(myFontFileName);
    fill(255);
    textAlign(LEFT, TOP);
    text(ChoosedFile, 395, 124, 148, 38);
  }
}

void PreviewFileDrawing() {
  if (ChoosedFile != null) {
    review = loadShape(ChoosedFile);
    review.disableStyle();
    noFill(); 
    stroke(255, 130, 0);
    //The dimensions of the document has to be adjusted with the size of the drawing!!! 
    if (review.height > review.width) {
      shape(review, 390, 340, (review.width*180)/review.height, 180);
    } else if (review.width > review.height) {
      shape(review, 390, 340, 337, (337*review.height)/review.width);
    }
  }
}

void PreviewCutting() {
  RG.init(this);
  RShape objShape = RG.loadShape(ChoosedFile);
  points = objShape.getPoints();
  if (wait == 0) {
    delay(1000);
    wait = 1;
  }
  if (i < points.length - 1) {
    translate(390, 340);
    if (review.height > 180 || review.width > 337) {
      if (review.height > review.width) {
        scaleFactor =  1/(review.height/180);
      } else if (review.width > review.height) {
        scaleFactor = 1/(review.width/337);
      }
    } else if ( review.height < 180 && review.width < 337) {
      if (review.height > review.width) {
        scaleFactor =  180/review.height;
      } else if (review.width > review.height) {
        scaleFactor = 337/review.width;
      }
    }

    // Objekt auf der Arbeitsfläche zeichnen
    stroke(color(#FF0000));
    line(points[i].x * scaleFactor, points[i].y * scaleFactor, 
    points[i + 1].x * scaleFactor, points[i + 1].y * scaleFactor);

    // Zwischenpunkte zischen den beiden koordinaten berechnen und dann in
    // die Plotqueue schreiben
    move(round(points[i].x * scaleFactor), round(points[i].y * scaleFactor), 
    round(points[i + 1].x * scaleFactor), round(points[i + 1].y * scaleFactor));
  } else {

    // Motoren releasen nachdem geplottet wurde
    if (wait == 1) {
      queueMessage(1);
      wait = 1;
      CutLaunch = false;
      i = 0;
    }
    
  }

  // Nächster Punkt
  i++;
}
void move(int x0, int y0, int x1, int y1) {

  int md1, md2, s_s1, s_s2, ox, oy;

  int dx = abs(x1-x0)
    , sx = (x0 < x1)? 1 : -1;

  int dy = abs(y1-y0)
    , sy = (y0 < y1)? 1 : -1;

  int err = ((dx > dy)? dx : -dy)/2, e2;

  // Zwischenpunkte berechnen und die Bewegung in die Plotqueue schreiben
  for (;; ) {

    ox = x0;
    oy = y0;

    if (x0 == x1 && y0 == y1) {
      break;
    }

    e2 = err;
    if (e2 > -dx) {
      err -= dy;
      x0 += sx;
    }

    if (e2 < dy) {
      err += dx;
      y0 += sy;
    }

    /*
        * die Bewegung wird über bitcodierte Steuerbefehle an die serielle Schnittstelle geschickt.
     * 0001:     x0,     y+      (1)
     * 0010:     x0,     y-      (2)
     * 0100:     x+,     y0      (4)
     * 1000:     x-,     y0      (8)
     * 0101:     x+,     y+      (5)
     * 0110:     x+,     y-      (6)
     * 1010:     x-,     y-      (10)
     * 1001:     x-,     y+      (9)
     */

    int movement = 0; //Bewegungsvariable auf Null setzen

    // Bewegungsbits setzen
    if (y0 < oy) { // runter
      movement |= 2;
    }

    if (y0 > oy) { // rauf
      movement |= 1;
    }

    if (x0 < ox) { // links
      movement |= 4;
    }

    if (x0 > ox) { // rechts
      movement |= 8;
    }

    // Steuerbefehl in die Plotqueue schreiben
    queueMessage(movement);
  }
}


// Plotqueue befüllen
public void queueMessage(int msg) {
  msgQueue = append(msgQueue, msg);
}


//Version 1
/*
void mousePressed() {
 
 if  (buttonSearch.over()) {
 JFileChooser chooser = new JFileChooser();
 chooser.setCurrentDirectory(new File("."));
 chooser.setFileFilter(new javax.swing.filechooser.FileFilter() {
 public boolean accept(File f) {
 return f.getName().toLowerCase().endsWith(".svg")
 || f.isDirectory();
 }
 public String getDescription() {
 return "SVG Images";
 }
 }
 );
 
 int returnVal = chooser.showOpenDialog(new JFrame());
 if (returnVal == JFileChooser.APPROVE_OPTION) 
 { 
 File file = chooser.getSelectedFile();
 String ChoosedFile = chooser.getSelectedFile().getName();
 System.out.println("You chose to open this file: " + ChoosedFile);
 }
 
 }
 }
 */



//Version 2

void mouseClicked() {
  if (buttonSearch.over()) {
    selectInput("Select a file to process:", "fileSelected");
  }
  if (cutStartB.over() && CutLaunch == false) {
    CutLaunch = true;
  }
}

void fileSelected(File selection) {
  if (selection == null ) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("File selected : " + selection.getAbsolutePath());
    ChoosedFile = selection.getAbsolutePath();
  }
}
/*
void mousePressed() {
 if (cutStartB.over() && CutLaunch == false) {
 CutLaunch = true;
 }
 }
 */



/*
//Version 3
 
 void mouseClicked() {
 if (buttonSearch.over()) {
 String fname = G4P.selectInput("Input Dialog", "svg", "Image files");
 lblFile.setText(fname);
 review = loadShape(fname);
 shape(review, 500, 500);
 }
 }
 */

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

