// ifからselectcaseに変更&2つ以上押しても光らないようにLED点灯条件見直し
int input1 = 14;
int input2 = 12;
int input3 = 13;
int input4 = 15;

int output1 = 16;
int output2 = 5;
int output3 = 4;

int mtime = 10;
int cnt = 0;
int beforeinput = 99;

void setup() {
  pinMode(output1, OUTPUT);
  pinMode(output2, OUTPUT);
  pinMode(output3, OUTPUT);
  
  pinMode(input1, INPUT);
  pinMode(input2, INPUT);
  pinMode(input3, INPUT);
  pinMode(input4, INPUT);

  Serial.begin(9600);
}

void loop() {
  boolean chkflag;
  int before_sw1 = digitalRead(input1);
  int before_sw2 = digitalRead(input2);
  int before_sw3 = digitalRead(input3);
  int before_sw4 = digitalRead(input4);

  int before_sw = before_sw1 + before_sw2 * 2 + before_sw3 * 4 + before_sw4 * 8;
  
  delay(10);
  int sw1 = digitalRead(input1);
  int sw2 = digitalRead(input2);
  int sw3 = digitalRead(input3);
  int sw4 = digitalRead(input4);

  int sw = sw1 + sw2 * 2 + sw3 * 4 + sw4 * 8;
  
  if(before_sw == sw){
    chkflag = true;
  }else{
    chkflag = false;
  }
    
  if (chkflag == true){
    if (beforeinput != sw){
      Serial.println(sw); 
      beforeinput = sw;
    } 
  }
  
  switch (sw) {
    case 0:
      digitalWrite(output1, LOW);
      break;
    case 1:
    case 2:
    case 4:
    case 8:
      LED_blink(sw);
      break;
    case 3:
    case 5:
    case 6:
    case 7:
    case 9:
    case 10:
    case 11:
    case 12:
    case 13:
    case 14:
    case 15:
      break;
    default:
      break;
  }

}

void LED_blink(int timing){
    if (cnt >= mtime * timing * 2 ){
      cnt = 0;
    } else{
      cnt = cnt + 1;
    }
    
    if (cnt <= mtime * timing ){
      digitalWrite(output1, HIGH);  
    }

    if (cnt >= mtime * timing ){
      digitalWrite(output1, LOW);  
    }
}

