#include <VSync.h>
ValueReceiver<13> receiver;
ValueSender<1> sender;

#define MOTOR1_DIR_PIN 4
#define MOTOR1_STEP_PIN 3
#define MOTOR2_DIR_PIN 7
#define MOTOR2_STEP_PIN 6
#define MOTOR3_DIR_PIN 13
#define MOTOR3_STEP_PIN 12

const int pingPin = 8;//Pin vom Entfernungssensor
const int Heissdraht = 10;//Pin vom Heissdraht

int Temperatur, Speed, RoGo, RuGo, RlGo, RrGo, moveBGo, cutMovBGo, KX, KY, KW, KL, KCUT;


void setup() {
  Serial.begin(19200);
  receiver.observe(Temperatur);
  receiver.observe(Speed);
  receiver.observe(RoGo);
  receiver.observe(RuGo);
  receiver.observe(RlGo);
  receiver.observe(RrGo);
  receiver.observe(moveBGo);
  receiver.observe(cutMovBGo);
  receiver.observe(KCUT);
  receiver.observe(KX);
  receiver.observe(KY);
  receiver.observe(KW);
  receiver.observe(KL);
  sender.observe(KCUT);

  pinMode(MOTOR1_DIR_PIN, OUTPUT);
  pinMode(MOTOR1_STEP_PIN, OUTPUT);
  pinMode(MOTOR2_DIR_PIN, OUTPUT);
  pinMode(MOTOR2_STEP_PIN, OUTPUT);
  pinMode(MOTOR3_DIR_PIN, OUTPUT);
  pinMode(MOTOR3_STEP_PIN, OUTPUT);
}

void loop() {  
  receiver.sync();
  sender.sync();

  pinMode(Heissdraht, OUTPUT);
  analogWrite(Heissdraht, Temperatur);

  //Kontroll der Bewegung nach Pfeilen in Processing
  if (moveBGo > 1 || cutMovBGo > 1){
    if (RoGo > 1) {
      rotateX(1,Speed); 
    }
    if (RuGo > 1) {
      rotateX(-1,Speed); 
    }
    if (RlGo > 1) {
      rotateY(1,Speed); 
    }
    if (RrGo > 1) {
      rotateY(-1,Speed);
    }
  }
  //Kontroll der Bewegung nach X, Y, Winkel und Länge
  float stepXInc;
  float stepYInc;
  float stepXPos;
  float stepYPos;
  float stepXPosMove;
  float stepYPosMove;
  int KalKoef = 360;//Koeffizient zur Kalibrierung/Konvertierung von cm in Schritten

  if (KCUT > 1)
  {
    if( KY > KX && KX >=0 && KY >=0 && KX != NULL && KY != NULL && KW == NULL && KL == NULL) {
      //stepXPos = 0.0;
      stepXInc = KY/KX;
      //stepXPosMove = 0.0;
      for (int i=0; i<KY*KalKoef; i++)
      {  
        rotateX(1, Speed*stepXInc);
        rotateY(1, Speed);  
      }
      KCUT =0;

    }
    else if( KX > KY && KX >=0 && KY >=0 && KX != NULL && KY != NULL && KW == NULL && KL == NULL) {
      //stepXPos = 0.0;
      stepXInc = KX/KY;
      //stepXPosMove = 0.0;
      for (int i=0; i<KX*KalKoef; i++)
      {  
        rotateX(1, Speed);
        rotateY(1, Speed*stepXInc);  
      }
      KCUT =0;
    }
    else if( KX == KY && KX >=0 && KY >=0 && KX != NULL && KY != NULL && KW == NULL && KL == NULL) {
      //stepXPos = 0.0;

      //stepXPosMove = 0.0;
      for (int i=0; i<KX*KalKoef; i++)
      {  
        rotateX(1, Speed);
        rotateY(1, Speed);  
      }
      KCUT = 0;
    }
    else if (KW != NULL && KL != NULL && KX == NULL  && KY == NULL)
    {
      int Xi, Yi;
      Xi= cos(KW) * KL;
      Yi= sin(KW) * KL;
      if (Yi > Xi) {
        stepXInc = Yi/Xi;
        //stepXPosMove = 0.0;
        for (int i=0; i<Yi*KalKoef; i++)
        {  
          rotateX(1, Speed*stepXInc);
          rotateY(1, Speed);  
        }
        KCUT =0;
      }
      else if (Xi > Yi) {
        stepXInc = Xi/Yi;
        //stepXPosMove = 0.0;
        for (int i=0; i<Xi*KalKoef; i++)
        {  
          rotateX(1, Speed);
          rotateY(1, Speed*stepXInc);  
        }
        KCUT =0;
      }
      else if (Xi == Yi) {
        for (int i=0; i<Xi*KalKoef; i++)
        {  
          rotateX(1, Speed);
          rotateY(1, Speed);  
        }
        KCUT =0;
      }
    }
    else if (KX == NULL || KY == NULL || KW == NULL || KL == NULL) {
      KCUT = 0;
    }
  }
}

void rotateX(int steps, float usDelay){
  //rotate a specific number of microsteps (8 microsteps per step) - (negitive for reverse movement)
  //speed is any number from .01 -> 1 with 1 being fastest - Slower is stronger
  int dir = (steps > 0)? HIGH:LOW;
  steps = abs(steps);

  digitalWrite(MOTOR1_DIR_PIN,dir); 
  //float usDelay = (1/speed) * 70;

  for(int i=0; i < steps; i++){
    digitalWrite(MOTOR1_STEP_PIN, HIGH);
    delayMicroseconds(usDelay); 
    digitalWrite(MOTOR1_STEP_PIN, LOW);
    delayMicroseconds(usDelay);
  }
} 

void rotateY(int steps, float usDelay){
  //rotate a specific number of microsteps (8 microsteps per step) - (negitive for reverse movement)
  //speed is any number from .01 -> 1 with 1 being fastest - Slower is stronger
  int dir = (steps > 0)? HIGH:LOW;
  steps = abs(steps);

  digitalWrite(MOTOR2_DIR_PIN,dir); 
  digitalWrite(MOTOR3_DIR_PIN,dir); 

  //float usDelay = (1/speed) * 70;

  for(int i=0; i < steps; i++){
    digitalWrite(MOTOR2_STEP_PIN, HIGH);
    digitalWrite(MOTOR3_STEP_PIN, HIGH);
    delayMicroseconds(usDelay); 
    digitalWrite(MOTOR2_STEP_PIN, LOW);
    digitalWrite(MOTOR3_STEP_PIN, LOW);
    delayMicroseconds(usDelay);
  }
} 













