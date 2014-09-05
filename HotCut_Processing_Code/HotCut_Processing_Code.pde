//Libraries
import processing.serial.*;
import vsync.*;//Librarie zur Synchronisierung der Variablen zwischen Processing und Arduino
import controlP5.*;
import g4p_controls.*;
import java.awt.*;
import geomerative.*;
import java.io.File;
import javax.swing.JFileChooser;
import javax.swing.JFrame;

ControlP5 cp5;

//Variablen
String name;

boolean styrodurpressed = false;
boolean styroporpressed = false;
boolean styropressed = false;
boolean custompressed = false;

boolean moveBpressed = false;
boolean cutMovBpressed = false;
boolean cutXYBpressed = false;

boolean buttonsearchpressed = false;
boolean RoGoPressed = false; 

//gemeinsame Variablen mit Arduino
public int Temperatur, Speed, RoGo, RuGo, RrGo, RlGo;
public int moveBGo, cutMovBGo;
public int KX, KY, KW, KL, KCUT;

PFont myFontUebersft, myFontUuebersft, myFontNormsft, myFontKleinsft;

PShape LogoHotCut; 
PShape thermWire;
PShape kreuzManCon;
PShape pfeilUpload;
PShape playStart;
PShape winkel;
PShape wlaenge;
PShape review;

//classes
SliderV STemperatur, SSpeed;
SliderCustom CSTemperatur, CSSpeed;
Menufenster fGetStarted, fWire, fManC, fUpload, fManueal, fStart;
Preview fStartPreview ;
ButtonsKreuz buttonsKreuzStyrodur, buttonsKreuzStyropor, buttonsKreuzCustom, buttonsKreuzStyro;
infoButton ButtonInfo;
ManConButtons moveB, cutMovB, cutXYB, clearXYB, cutStartB;
TextfieldManCon textfX, textfY, textfWinkel, textfLaenge;
SearchFenster fileUpload;
SearchButton buttonSearch;
RectMC Ro, Ru, Rr, Rl;        
GLabel lblFile;
GButton btnInput;

void setup ()
{ /*
  //Code für Kommunikation zwischen Processing und Arduino
  Serial serial = new Serial(this, "COM13", 19200);//"Name vom Port" muss die Name des Ports zwichen Arduino-Software und Arduino-Board
  ValueSender sender = new ValueSender(this, serial);
  ValueReceiver receiver = new ValueReceiver(this, serial);
  sender.observe("Temperatur");
  sender.observe("Speed");
  sender.observe("RoGo");
  sender.observe("RuGo");
  sender.observe("RrGo");
  sender.observe("RlGo");
  sender.observe("moveBGo");
  sender.observe("cutMovBGo");
  sender.observe("KCUT");
  sender.observe("KX");
  sender.observe("KY");
  sender.observe("KW");
  sender.observe("KL");
  receiver.observe("KCUT");
*/

  size (800, 600);                //Grösse der Arbeitsfläche       
  frame.setResizable(true);      //eventl. mit % bestimmen??
  smooth();                     //verbessert die Qualität der Anzeige

  //import bild.svg
  LogoHotCut = loadShape("LogoHotCut.svg");       
  thermWire = loadShape("thermWire.svg");
  kreuzManCon = loadShape("kreuzManCon.svg");
  pfeilUpload = loadShape("pfeilUpload.svg");
  playStart = loadShape("playStart.svg");
  winkel = loadShape("winkel.svg");
  wlaenge = loadShape("wlaenge.svg");

  //("Font Type", Groesse)
  myFontUebersft= createFont("Verdana Italic", 14);    
  myFontUuebersft= createFont("Verdana", 11);
  myFontNormsft= createFont("Verdana", 11);
  myFontKleinsft= createFont("Verdana", 10);  

  //Nutzung der Classes
  fGetStarted = new Menufenster(40.1, 75.1, 280, 100);
  fWire       = new Menufenster(40.1, 240, 280, 152);
  fManC       = new Menufenster(40.1, 442, 280, 117);
  fUpload     = new Menufenster(359, 75.1, 218, 100);
  fStart      = new Menufenster(359, 240, 400, 318);

  fStartPreview = new Preview (386, 336, 345, 194);   //darin erscheint meine hochgeladene datei

  buttonsKreuzStyrodur = new ButtonsKreuz(130, 258);
  buttonsKreuzStyropor = new ButtonsKreuz(210, 258);
  buttonsKreuzStyro = new ButtonsKreuz(130, 285);
  buttonsKreuzCustom = new ButtonsKreuz(210, 285);

  ButtonInfo = new infoButton(710, 77, 50, 28);

  moveB = new ManConButtons(57, 457, 41, 18);
  cutMovB = new ManConButtons(118, 457, 34, 18);
  cutXYB = new ManConButtons(197, 526, 34, 18);
  clearXYB = new ManConButtons(250, 526, 50, 18);
  cutStartB = new ManConButtons(386, 300, 34, 18);

  fileUpload = new SearchFenster(374, 122, 102, 39);
  buttonSearch = new SearchButton(484, 122);


  Ro = new RectMC(102.76, 488, 10.5, 15, 108, 483, 117, 491.5, 99, 491.5);
  Ru = new RectMC(102.76, 527, 10.5, 15, 99, 538.5, 117, 538.5, 108, 547);
  Rr = new RectMC(120, 510, 15, 10.5, 131.5, 506.25, 140, 515.25, 131.5, 524.5);
  Rl = new RectMC(81, 510, 15, 10.5, 76, 515.25, 84.5, 506.25, 84.5, 524.25);

  STemperatur = new SliderV(145, 331, 130, 12, #E73E20, #006699);
  SSpeed = new SliderV(145, 358, 130, 12, #C6C6C6, #2E2E2E);
  CSTemperatur = new SliderCustom(145, 331, 130, 12, #E73E20, #006699);
  CSSpeed = new SliderCustom(145, 358, 130, 12, #C6C6C6, #2E2E2E);

  /*btnInput = new GButton(this, 484, 122, 55, 18, "Input");*/
  lblFile = new GLabel(this, 374, 122, 102, 39);
  lblFile.setTextAlign(GAlign.MIDDLE, GAlign.MIDDLE);
  lblFile.setFont(new Font("Verdana", Font.BOLD, 8));
  lblFile.setLocalColorScheme(GCScheme.SCHEME_9);

  //Textfelder
  cp5 = new ControlP5(this);

  PFont pfont = createFont("Verdana", 12, true);
  ControlFont font = new ControlFont(pfont, 11);

  cp5.addTextfield(" ")                      // X  //1xBackspace
    .setPosition(197, 457)
      .setSize(35, 18)
        .setFont(createFont("Verdana", 12))
          .setColorActive(color(60))
            .setColorForeground(color(60))
              .setColorBackground(color(60))
                .setAutoClear(false);

  cp5.addTextfield("  ")                    // Y  //2xBackspace
    .setPosition(197, 483)
      .setSize(35, 18)
        .setFont(createFont("Verdana", 12))
          .setColorActive(color(60))
            .setColorForeground(color(60))
              .setColorBackground(color(60))
                .setAutoClear(false);

  cp5.addTextfield("   ")                  // Winkel //3xBackspace
    .setPosition(264, 457)
      .setSize(35, 18)
        //.setText("   °")
        .setFont(createFont("Verdana", 12)) 
          .setColorActive(color (60))
            .setColorForeground(color(60))
              .setColorBackground(color(60))
                .setAutoClear(false);

  cp5.addTextfield("    ")                  // Laenge //4xBackspace
    .setPosition(264, 483)
      .setSize(35, 18)
        .setFont(createFont("Verdana", 12)) 
          .setColorActive(color(60))
            .setColorForeground(color(60))
              .setColorBackground(color(60))
                .setAutoClear(false);

  cp5.addButton("clear")
    .setPosition(250, 526)
      .setSize(50, 19)
        .setColorActive(color(170))
          .setColorForeground(color(150))
            .setColorBackground(color(87))
              .setColorCaptionLabel(color(255))
                .getCaptionLabel().align(ControlP5.CENTER, ControlP5.TOP);

  cp5.getController("clear")
    .getCaptionLabel()
      .setFont(font)
        ;

  textFont(pfont);
}

void draw() {
  background(35);//Hintergrundfarbe

  //Anzeige der Menufenster
  fGetStarted.display();                  
  fUpload.display();
  fWire.display();
  fManC.display();
  fStart.display();
  fStartPreview.display();


  //bild.svg wird angezeigt
  shape(LogoHotCut, 610, 35);                
  shape(thermWire, 51, 209, 12, 19);
  shape(kreuzManCon, 51, 416);
  shape(pfeilUpload, 370, 48);
  shape(playStart, 370, 210);
  shape(winkel, 245, 460);
  shape(wlaenge, 244, 483);
  // Anzeige Buttons in Wire
  buttonsKreuzStyrodur.display();           
  buttonsKreuzStyropor.display(); 
  buttonsKreuzStyro.display();
  buttonsKreuzCustom.display(); 

  // Anzeige Infosbutton
  ButtonInfo.display();

  moveB.display();
  moveB.update();
  cutMovB.display();
  cutMovB.update();
  cutXYB.display();
  cutXYB.update();
  cutStartB.display();
  cutStartB.update();
  fileUpload.display();
  buttonSearch.display();
  buttonSearch.update();

  Ro.display();
  Ro.update();
  Ru.display();
  Ru.update();
  Rr.display();
  Rr.update();
  Rl.display();
  Rl.update();
  //review();
  /*
  port.write('T');
   port.write(STemperatur.tw);
   port.write('S');
   port.write(SSpeed.sw);
   */

  stroke(157);
  line(489, 158, 507, 158);                 //line bei svg
  line(169, 454, 169, 547);

  if (styrodurpressed && moveBpressed == false ) {
    buttonsKreuzStyrodur.kreuz();  
    STemperatur.p = 75;
    SSpeed.p = 50;
    Temperatur = STemperatur.tw;
    Speed = SSpeed.psw;
    STemperatur.render();
    STemperatur.update();
    STemperatur.renderTWert();
    SSpeed.render();
    SSpeed.update();
    SSpeed.renderSWert();
  } else if (styroporpressed && moveBpressed == false ) {
    buttonsKreuzStyropor.kreuz();
    STemperatur.p = 90;
    SSpeed.p = 110;
    Temperatur = STemperatur.tw;
    Speed = SSpeed.psw;
    STemperatur.render();
    STemperatur.update();
    STemperatur.renderTWert();
    SSpeed.render();
    SSpeed.update();
    SSpeed.renderSWert();
  } else if (styropressed && moveBpressed == false ) {
    buttonsKreuzStyro.kreuz();
    STemperatur.p = 40;
    SSpeed.p = 35;
    Temperatur = STemperatur.tw;
    Speed = SSpeed.psw;
    STemperatur.render();
    STemperatur.update();
    STemperatur.renderTWert();
    SSpeed.render();
    SSpeed.update();
    SSpeed.renderSWert();
  } else if (custompressed && moveBpressed == false ) {
    Temperatur = CSTemperatur.tw;
    Speed = CSSpeed.psw;
    buttonsKreuzCustom.kreuz();
    CSTemperatur.render();
    CSTemperatur.updateover();
    CSTemperatur.renderTWert();
    CSSpeed.render();
    CSSpeed.updateover();
    CSSpeed.renderSWert();
  } else if (styrodurpressed == false && styroporpressed == false && styropressed == false && custompressed == false) {
    STemperatur.render();
    STemperatur.updateover();
    STemperatur.renderTWert();
    SSpeed.render();
    SSpeed.updateover();
    SSpeed.renderSWert();
  }

  if (STemperatur.p > 0 && styrodurpressed == false && styroporpressed == false && styropressed == false && custompressed == false) {
    custompressed = true;
  }
  if (SSpeed.p > 0 && styrodurpressed == false && styroporpressed == false && styropressed == false && custompressed == false) {
    custompressed = true;
  }

  if (moveBpressed) {
    moveB.currentcolor = moveB.pressedcolor;
    STemperatur.p = 0;
    Temperatur = STemperatur.tw;
    STemperatur.render();
    STemperatur.update();
    STemperatur.renderTWert();
    SSpeed.p = 85;
    Speed = SSpeed.psw;
    SSpeed.render();
    SSpeed.update();
    SSpeed.renderSWert();
    moveBGo = 2;
    cutMovBGo = 0;
  } else if (cutMovBpressed) {
    cutMovB.currentcolor = cutMovB.pressedcolor;
    moveBGo = 0;
    cutMovBGo = 2;
  } else if (!moveBpressed && !cutMovBpressed) {
    moveBGo = 0;
    cutMovBGo = 0;
  }
  if(cutXYBpressed) {
    cutXYB.currentcolor = cutXYB.pressedcolor;
      }
  if (KCUT < 1) {
    cutXYBpressed = false;
  }
    
  if (mousePressed == true && Ro.over()) {
    RoGo = 2;
  } else { 
    RoGo = 0;
  }
  if (mousePressed == true && Ru.over()) {
    RuGo = 2;
  } else { 
    RuGo = 0;
  }
  if (mousePressed == true && Rl.over()) {
    RlGo = 2;
  } else { 
    RlGo = 0;
  }
  if (mousePressed == true && Rr.over()) {
    RrGo = 2;
  } else { 
    RrGo = 0;
  }
 

  KX = int(cp5.get(Textfield.class, " ").getText());
  KY = int(cp5.get(Textfield.class, "  ").getText());
  KW = int(cp5.get(Textfield.class, "   ").getText());
  KL = int(cp5.get(Textfield.class, "    ").getText());

  text();//Text wird angezeigt
  print("KX : ");
  println(KX);
  print("KY : ");
  println(KY);
  print("KCUT : ");
  println(KCUT);
  print("KW : ");
  println(KW);
  print("KL : ");
  println(KL);
}
public void clear() {
  cp5.get(Textfield.class, " ").clear();
  cp5.get(Textfield.class, "  ").clear();
  cp5.get(Textfield.class, "   ").clear();
  cp5.get(Textfield.class, "    ").clear();
}

public void input(String theText) {
  println("a textfield event for controller 'input' : "+theText);
}

void mousePressed() {


  if (buttonsKreuzStyrodur.over() ) {
    styrodurpressed = true;
    styroporpressed = false;
    styropressed = false;
    custompressed = false;
  } else if (buttonsKreuzStyropor.over() ) {
    styroporpressed = true;
    styrodurpressed = false;
    styropressed = false;
    custompressed = false;
  } else if (buttonsKreuzStyro.over() ) {
    styropressed = true;
    styroporpressed = false;
    styrodurpressed = false;
    custompressed = false;
  } else if (buttonsKreuzCustom.over() ) {
    custompressed = true;
    styroporpressed = false;
    styrodurpressed = false;
    styropressed = false;
  }
  if (moveB.over() ) {
    moveBpressed = true;
    cutMovBpressed = false;
  } else if (cutMovB.over() ) {
    cutMovBpressed = true;
    moveBpressed = false;
  } else if (cutXYB.over() ) {
    cutXYBpressed = true; 
    cutMovBpressed = false;
    moveBpressed = false;
    KCUT = 2;
      }
  if (buttonSearch.over()) {
    buttonsearchpressed = true;
  }

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
      String name = chooser.getSelectedFile().getName();
      System.out.println("You chose to open this file: " + name);
      buttonsearchpressed = true;
    }
    review = loadShape(name);
    shape(review, 500, 400);
  }
}
/* // V1
 void mouseClicked() {
 if (buttonSearch.over()) {
 selectInput("Select a file to process:", "fileSelected");
 }
 }
 
 void fileSelected(File selection) {
 if (selection == null ) {
 println("Window was closed or the user hit cancel.");
 } else {
 println("User selected " + selection.getAbsolutePath());
 }
 }
 */

/*//V2
 void mouseClicked() {
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
 String name = chooser.getSelectedFile().getName();
 System.out.println("You chose to open this file: " + name);
 
 }
 }
 
 }
 void review() {
 if (name != null) {
 review = loadShape(name);
 shape(review, 500, 400);
 }
 }
 */



/*
public void handleButtonEvents(GButton button, GEvent event) { 
 // Folder selection
 if ( button == btnInput )
 handleFileDialog(button);
 }
 
 // G4P code for folder and file dialogs
 public void handleFileDialog(GButton button) {
 
 // Folder selection
 
 // File input selection
 if (button == btnInput) {
 // Use file filter if possible
 fname = G4P.selectInput("Input Dialog", ",svg", "Image files");
 lblFile.setText(fname);
 review = loadShape(fname);
 shape(review, 500, 400);
 }
 }
 */

/*
void mouseClicked() {
 if (buttonSearch.over()) {
 fname = G4P.selectInput("Input Dialog", "svg", "Image files");
 lblFile.setText(fname);
 //review = loadShape(fname);
 shape(review, 500, 500);
 }
 }
 */
void text() {

  textFont(myFontUebersft);             //schreib einen text mit (...) format
  fill(157);                            //textfarbe
  textAlign(LEFT);                      //linksbündig
  text ("GET STARTED", 51, 62);         //(Text,x,y)
  text ("WIRE", 64, 224.5);
  text ("MANUAL CONTROL", 70, 429);
  text ("UPLOAD", 391, 62);  
  text ("START", 391, 224);

  fill(231, 62, 32);
  text("INFO", 718, 97);

  textFont(myFontUuebersft);            
  fill(255);                
  textAlign(LEFT);                  
  text ("MATERIAL", 57, 266);
  text ("TEMP (°C)", 57, 340);
  text ("SPEED (rpm)", 57, 367);
  text ("SEARCH", 490, 136);

  text ("MOVE", 62, 470);
  text ("CUT", 124, 470);
  text ("CUT", 203, 539);             //cut button in ManCOn X+Y
  //text ("CLEAR", 280, 539);
  text ("X", 183, 469);
  text ("Y", 183, 494 );
  text ("CUT", 392, 313);             //cut button in start
  fill (135);
  text ("PREVIEW FILE", 655, 313);

  textFont(myFontNormsft);            
  fill(255);                
  textAlign(LEFT);                  
  text ("Styrodur", 150, 268);        //text in "get started"
  text ("Styropor", 230, 268);
  text ("Styro", 150, 297);
  text ("Custom", 230, 297);
  text("_Connect PC or Laptop with Cutter", 57, 100);
  text("_Download and Install ARDUINO", 57, 122);
  text("get the code „hotcut“", 80, 141);
  text("at >www.hotcut.com<", 80, 156);

  textFont(myFontKleinsft);
  fill(157);                
  textAlign(LEFT);                  
  text ("(      .svg)", 483, 159);
  text ("(mm)", 197, 512);
}

