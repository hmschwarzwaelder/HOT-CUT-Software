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

Menufenster fUpload, fStart;
SearchFenster fileUpload;
SearchButton buttonSearch;
Preview fStartPreview ;
ManConButtons cutStartB;

//For Version 3 of Input
GLabel lblFile;


PFont myFont, myFontitalic, myFontsmall, myFontFileName, DrawFont;
PShape review;
String name, ChoosedFile;

void setup ()
{ 
  // Part of Styrosimulation
  msgQueue = new int[0];

  size (800, 600);                   
  smooth();       

  fUpload     = new Menufenster(359, 75.1, 218, 100);
  fStart      = new Menufenster(359, 240, 400, 318);
  fileUpload = new SearchFenster(374, 122, 102, 39);
  buttonSearch = new SearchButton(484, 122);
  fStartPreview = new Preview (386, 336, 345, 194);
  cutStartB = new ManConButtons(386, 300, 34, 18);
  myFontitalic= createFont("Verdana Italic", 14); 
  myFont= createFont("Verdana", 11);
  myFontsmall= createFont("Verdana", 10);
  myFontFileName = createFont("Verdana", 9);

  DrawFont = createFont("Verdana", 14);

  lblFile = new GLabel(this, 374, 122, 102, 39);
  lblFile.setTextAlign(GAlign.MIDDLE, GAlign.MIDDLE);
  lblFile.setFont(new Font("Verdana", Font.BOLD, 8));
  lblFile.setLocalColorScheme(GCScheme.SCHEME_9);
}

void draw() 
{
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
  text ("SEARCH", 490, 136);
  text ("CUT", 392, 313);             
  fill (135);
  text ("PREVIEW FILE", 655, 313);

  textFont(myFontsmall);
  fill(157);                
  textAlign(LEFT);                  
  text ("(      .svg)", 483, 159);
  //text(File, 483, 159);
}

void PreviewFileName() {
  if (ChoosedFile == null) {
    textFont(myFontFileName);
    fill(255);
    text("No File Selected", 385, 145);
  } else {
    textFont(myFontFileName);
    fill(255);
    textAlign(LEFT, TOP);
    text(ChoosedFile, 382, 125, 90, 80);
    review = loadShape(ChoosedFile);
    review.disableStyle();
    noFill(); 
    stroke(231, 62, 32);
    shape(review, 390, 340, 337, (337*review.height)/review.width);
  }
}
/*
void PreviewCutting() {
 RG.init(this);
 RShape objShape = RG.loadShape(File);
 points = objShape.getPoints();
 if (wait == 0) {
 delay(1000);
 wait = 1;
 }
 */


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

