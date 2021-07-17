#include<WiFi.h>
#include<WiFiClient.h>
#include <ESP32Servo.h>
#include<String.h>
WiFiClient client;
Servo s1,s2,s3,s4,s5;
Servo mainGate;

class Slot{ 
  public:
  int trig,echo,dist,group;
  Servo servo;
  Slot(int trigPin,int echoPin,int servoPin,int grp){
    trig = trigPin;
    echo = echoPin;
    group = grp;
    servo.attach(servoPin);
  }
};



const int trigPin4 = 4;
const int echoPin34 = 34;
const int servoPin16 = 16;

const int trigPin5 = 5;
const int echoPin35 = 35;
const int servoPin17 = 17;

const int trigPin13 = 13;
const int echoPin36 = 36;
const int servoPin22 = 22;

const int trigPin14 = 14;
const int echoPin39 = 39;
const int servoPin19 = 19;

const int trigPin15 = 15;
const int echoPin18 = 18;
const int servoPin21 = 21;

const int mainGatePin = 27;
const int entryIR = 26;
const int exitIR = 25;

Slot s[] = {
  Slot(trigPin4,echoPin34,servoPin16,1),
  Slot(trigPin5,echoPin35,servoPin17,1),
  Slot(trigPin13,echoPin36,servoPin22,2),
  Slot(trigPin14,echoPin39,servoPin19,2),
  Slot(trigPin15,echoPin18,servoPin21,2)
  };

const char* ssid = "TP-Link_2.4";
const char* pass = "tplink@2.4hz";
const char* host = "192.168.0.105";

int calculateDistance(int trig,int echo);
void initPins();
String readUltrasonic();
String reserveSpot(int spotNumber);
String releaseSpot(int spotNumber);
void connectWifi();
void checkWifi();
void connectToServer();
void checkServer();
void mainProcess(WiFiClient client);
String getCommand(String s);
String getOption(String s);
void handleRequest(WiFiClient client,char com,char opt);
int isLotFull();
void autoGates();

void setup() {
  Serial.begin(9600);
  delay(3000);
  initPins();
  connectWifi();
  connectToServer();
 
}

void loop() {

}

void connectToServer()
{
  Serial.println("Connecting to Server");
  bool c = client.connect(host,8000);
  while(!c){
    Serial.print("*");
    c = client.connect(host,8000);
    digitalWrite(2,HIGH);
    delay(500);
    digitalWrite(2,LOW);
    delay(500);
  }
  Serial.println();
  Serial.println("Server Connected");
  digitalWrite(2,HIGH);
  mainProcess(client);
}

int isLotFull(){
  int i;
  for(i=0;i<5;i++)
  {
    s[i].dist = calculateDistance(s[i].trig,s[i].echo);
    if(s[i].dist > 0 && s[i].dist <5){
      continue;
    }
    break;
  }
  if(i == 5)
  {
    return 1;
  }
  return 0;
}

void autoGates(){
  int entryStatus = !digitalRead(entryIR);
  int exitStatus = !digitalRead(exitIR);
  Serial.println("IR Status");
  Serial.println(entryStatus);
  Serial.println(exitStatus);
  if(entryStatus){
    if(!isLotFull()){
      mainGate.write(180);
      Serial.println("Raising barrier for entry");
      delay(2000);
      mainGate.write(90);
    }
  }
  else{
    if(exitStatus){
      mainGate.write(180);
      Serial.println("Raising barrier for exit");
      delay(2000);
      mainGate.write(90);
    }
  }
  
}

void mainProcess(WiFiClient client){
  while(1)
  {
    autoGates();
    String dat = "";
    while(client.available())
    {
      dat += client.readString();
    }
    if(dat.length() > 0 )
    {
      Serial.println("Server Requested");
      char str[1][50];
      dat.toLowerCase();
      dat.toCharArray(str[0],50);
      Serial.println(dat);
      handleRequest(client,str[0][0],str[0][1]);
    }
    checkWifi();
    checkServer();
  }
  
}

String reserveSpot(int spotNumber){
  spotNumber = spotNumber -48; //ascii conversion
  Serial.print("Reserving ");
  Serial.println(spotNumber-1);
  int actualSpot = spotNumber-1;
  int grp = s[actualSpot].group;
  if(grp == 1){
    s[actualSpot].servo.write(180);
  }
  else{
    s[actualSpot].servo.write(90);
  }
    return "ok";
}

String releaseSpot(int spotNumber){
  spotNumber = spotNumber -48; //ascii conversion
  Serial.print("Releasing ");
  Serial.println(spotNumber-1);
  int actualSpot = spotNumber-1;
  int grp = s[actualSpot].group;
  if(grp == 1){
    s[actualSpot].servo.write(90);
  }
  else{
    s[actualSpot].servo.write(180);
  }
    return "ok";
}

void handleRequest(WiFiClient client,char com,char opt){
  Serial.print("Command : ");
  Serial.println(com);
  Serial.print("Option : ");
  Serial.println(opt);
  switch(com)
  {
    case '1' : client.print(readUltrasonic());
                    break;
    case '2' : client.print(reserveSpot(opt));
                break;
    case '3' : client.print(releaseSpot(opt));
                break;
    default: Serial.print("Invalid Request");
             client.println("Invalid Request"); 
             break;
  }
}



String readUltrasonic(){
  Serial.println("Reading Sensors");
  for(int i=0;i<5;i++)
  {
    s[i].dist = calculateDistance(s[i].trig,s[i].echo);
  }
  
  String r="";
  r+=s[0].dist;
  for(int i=1;i<5;i++)
  {
    r+=",";
    r+=s[i].dist;
  }
  Serial.println(r);

  return r;
}

void initPins(){
  Serial.println("Initializing Componenets");
  pinMode(2,OUTPUT);
  mainGate.attach(mainGatePin);
  mainGate.write(180);
  delay(1000);
  mainGate.write(90);
  pinMode(entryIR,INPUT);
  pinMode(exitIR,INPUT);
  for(int i=0;i<5;i++){
    Serial.print("*");
    pinMode(s[i].trig,OUTPUT);
    pinMode(s[i].echo,INPUT);
    if(s[i].group == 1){
      s[i].servo.write(90);
      delay(1000);
      s[i].servo.write(180);
      delay(1000);
      s[i].servo.write(90);
    }
    else{
      s[i].servo.write(180);
      delay(1000);
      s[i].servo.write(90);
      delay(1000);
      s[i].servo.write(180);
    }
  }
  Serial.println();
  Serial.println("Init Complete");
}

int calculateDistance(int trig,int echo){
  digitalWrite(trig,LOW);
  delayMicroseconds(2);
  digitalWrite(trig, HIGH);
  delayMicroseconds(10);
  digitalWrite(trig, LOW);
  
  long duration = pulseIn(echo, HIGH);

  return (int)(duration*0.034/2);
  
}

void connectWifi(){
  WiFi.mode(WIFI_STA);
  Serial.println("Connecting to Wifi");
  Serial.print("SSID = ");
  Serial.println(ssid);
  WiFi.begin(ssid,pass);
  Serial.println();
  while( WiFi.status() != WL_CONNECTED )
  {
    Serial.print("*");
    digitalWrite(2,HIGH);
    delay(500);
    digitalWrite(2,LOW);
    delay(500);
  }
  Serial.println();
  if(WiFi.status() == WL_CONNECTED){
    Serial.println("Wifi Connected");
    Serial.print("IP = ");
    Serial.println(WiFi.localIP());
    
  }
}

void checkWifi(){
  if(WiFi.status() == WL_DISCONNECTED)
  {
    digitalWrite(2,LOW);
    Serial.println("Wifi connection lost. Retrying connection!");
    connectWifi();
    connectToServer();
  }
}
void checkServer(){
  if(!client.connected())
  {
    digitalWrite(2,LOW);
    Serial.println("Connection to server lost. Retrying connection!");
    client.stop();
    connectToServer();
  }
}
