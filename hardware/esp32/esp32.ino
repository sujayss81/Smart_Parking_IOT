#include<WiFi.h>
#include<WiFiClient.h>
#include <ESP32Servo.h>
#include<String.h>
WiFiClient client;

class Slot{ 
  public:
  int trig,echo,dist;
  Slot(int trigPin,int echoPin){
    trig = trigPin;
    echo = echoPin;
  }
};



const int trigPin4 = 4;
const int echoPin34 = 34;

const int trigPin5 = 5;
const int echoPin35 = 35;

const int trigPin13 = 13;
const int echoPin36 = 36;

const int trigPin14 = 14;
const int echoPin39 = 39;

const int trigPin15 = 15;
const int echoPin18 = 18;

Slot s[] = {Slot(trigPin4,echoPin34),Slot(trigPin5,echoPin35),Slot(trigPin13,echoPin36),Slot(trigPin14,echoPin39),Slot(trigPin15,echoPin18)};

//const int trigPin19 = 19;
//const int echoPin21 = 21;

const char* ssid = "TP-Link_2.4";
const char* pass = "tplink@2.4hz";
const char* host = "192.168.0.105";

int calculateDistance(int trig,int echo);
void initPins();
String readUltrasonic();
void connectWifi();
void checkWifi();
void connectToServer();
void checkServer();
void mainProcess(WiFiClient client);
String getCommand(String s);
String getOption(String s);
void handleRequest(WiFiClient client,char com,char opt);

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

void mainProcess(WiFiClient client){
  while(1)
  {
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

void handleRequest(WiFiClient client,char com,char opt){
  switch(com)
  {
    case '1' : client.print(readUltrasonic());
                    break;
    default: Serial.println("Invalid Request");
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
  Serial.println("Initializing Pins");

  pinMode(2,OUTPUT);

  for(int i=0;i<5;i++){
    pinMode(s[i].trig,OUTPUT);
    pinMode(s[i].echo,INPUT);
  }
  
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
