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

const int trigPin19 = 19;
const int echoPin21 = 21;

int calculateDistance(int trig,int echo);

void setup() {
  Serial.begin(9600);
  
  pinMode(trigPin4, OUTPUT);
  pinMode(echoPin34, INPUT);

  pinMode(trigPin5, OUTPUT);
  pinMode(echoPin35, INPUT);

  pinMode(trigPin13, OUTPUT);
  pinMode(echoPin36, INPUT);

  pinMode(trigPin14, OUTPUT);
  pinMode(echoPin39, INPUT);

  pinMode(trigPin15, OUTPUT);
  pinMode(echoPin18, INPUT);

  pinMode(trigPin19, OUTPUT);
  pinMode(echoPin21, INPUT);
}

void loop() {
  int a[6] = {0,0,0,0,0,0};
  a[0] = calculateDistance(trigPin4,echoPin34);
  a[1] = calculateDistance(trigPin5,echoPin35);
  a[2] = calculateDistance(trigPin13,echoPin36);
  a[3] = calculateDistance(trigPin14,echoPin39);
  a[4] = calculateDistance(trigPin15,echoPin18);
  a[5] = calculateDistance(trigPin19,echoPin21);
  
  for(int i=0;i<6;i++){
    Serial.print(a[i]);
    Serial.print(" ");
  }
  Serial.println();
  delay(1000);
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
