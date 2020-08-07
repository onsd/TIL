#include <ESP8266WiFi.h>
#include <NTP.h>

//WiFi設定 各自環境によって設定が必要
const char* ssid = "arduino";
const char* password = "0569425451";
// ifttt
const char* host_IFTTT = "maker.ifttt.com";
// String url_IFTTT = "/trigger/digimonotest/with/key/e4O73zKaot3zR3TRfdx6KijgXNLCn0Bi-lfJoXBxDy3";
String url_IFTTT = "/trigger/digimono/with/key/hLXYtC8DuVFHhkirPDMTQLqwhToxbXLFPjDyzJkWlYX";

const char* host_GOOGLE = "script.google.com";
String url_GOOGLE = "/macros/s/AKfycby1lD_OyzHRoglW9LbxrtTYwnq2wswo-ry-b1V6Dxmrd9mBM3xz/exec";

String SendMsg;

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

long beforeinputtime = 0;
long cycletime = 0;
long beforesendtime = 0;




//WiFi設定
void wifiConnect() {
  Serial.print("Connecting to " + String(ssid));

  //WiFi接続開始
  WiFi.begin(ssid, password);

  //接続状態になるまで待つ
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  //接続に成功。IPアドレスを表示
  Serial.print("Connected! IP address: ");
  Serial.println(WiFi.localIP());
}

//IFTTT Webhook通知
void sendIFTTTWebhook(){

//  beforesendtime = millis(); //IFTTTするまえの時間
//  cycletime = millis() - beforeinputtime;  

  WiFiClientSecure client;
  Serial.println("Try");

  client.setInsecure();
  //IFTTTのAPIサーバに接続
  if (!client.connect(host_GOOGLE, 443)) {
    Serial.println("Connection failed");
    return;
  }
  Serial.println("Connected");
  //リクエストを送信
  String query = SendMsg;

  Serial.println(query);
  
  String request = String("") +
                   "POST " + url_GOOGLE + " HTTP/1.1\r\n" +
                   "Host: " + host_GOOGLE + "\r\n" +
                   "Content-Length: " + String(query.length()) +  "\r\n" +
                   // "Content-Type: application/x-www-form-urlencoded\r\n\r\n" +
                   "Content-Type: application/json\r\n\r\n" +
                   query + "\r\n";
  client.print(request);

//受信完了ではなく、2秒待つように訂正
  delay(2000);

  //受信終了まで待つ
//  while (client.connected()) {
//    String line = client.readStringUntil('\n');
//    if (line == "\r") {
//      break;
//    }
//  }

  String line = client.readStringUntil('\n');
  Serial.println(line);
 
  
  
}

void setup() {
  pinMode(output1, OUTPUT);
  pinMode(output2, OUTPUT);
  pinMode(output3, OUTPUT);
  
  pinMode(input1, INPUT);
  pinMode(input2, INPUT);
  pinMode(input3, INPUT);
  pinMode(input4, INPUT);

  Serial.begin(9600);

  //WIFI_STAをつけないとサーバーモードで必ず起動してしまうので注意
  WiFi.mode(WIFI_STA);
  
  wifiConnect();

  //NTP 初期化
  // 2390 はローカルのUDPポート。空いている番号なら何番でもいいです。
  ntp_begin(2390);
  
  // NTPサーバを変更 (デフォルト: ntp.nict.jp)
  //setTimeServer("s2csntp.miz.nao.ac.jp");
  
  // NTP同期間隔を変更 (デフォルト: 300秒)
  setSyncInterval(3600);
  GetDateTime();
}

void loop() {
  String msg_IFTTT_value1;
  String msg_IFTTT_value2;
  String msg_IFTTT_value3;

  
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
    
    LED_blink(10);          //ここにLEDblinkつけておくと、変化ない限りは点滅を繰り返す

    if (beforeinput != sw){
            
      Serial.println(sw); 
      beforeinput = sw;
  
      switch (sw) {
        case 0:
//          LED_blink(10);
          break;
        case 1:
        case 2:
        case 4:
        case 8:
          // --------------------------
          // IFTTT経由でSlackに投稿するプログラム
          // --------------------------

          beforesendtime = millis(); //IFTTTするまえの時間
          cycletime = beforesendtime - beforeinputtime;
                  
          msg_IFTTT_value1 = changeDateTime(now());
        //   msg_IFTTT_value2 = String(sw);
          msg_IFTTT_value2 = "J 大森";
          msg_IFTTT_value3 = cycletime;
          
          SendMsg ="{\"value1\": \"" + msg_IFTTT_value1 + "\"," + 
                     "\"value2\": \"" + msg_IFTTT_value2 + "\","  +  
                      "\"value3\": \"" + msg_IFTTT_value3 + "\"}";
          
          digitalWrite(output1, HIGH);

          sendIFTTTWebhook();

          beforeinputtime = beforesendtime; 
          
          digitalWrite(output1, LOW);
          
          // --------------------------
          //【ここまで】IFTTT経由でSlackに投稿するプログラム
          // --------------------------
          
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
  }

}

void LED_blink(int timing){
    if (cnt >= mtime * timing * 2 ){
      cnt = 0;
    } else{
      cnt = cnt + 1;
    }

    // Serial.println(cnt);
    
    if (cnt <= mtime * timing ){
      digitalWrite(output1, HIGH);  
    }

    if (cnt >= mtime * timing ){
      digitalWrite(output1, LOW);  
    }
}

void GetDateTime(){

  time_t n = now();
  time_t t;

  char s[20];
  const char* format = "%04d-%02d-%02d %02d:%02d:%02d";

  // JST
  t = localtime(n, 9);
  sprintf(s, format, year(t), month(t), day(t), hour(t), minute(t), second(t));
  Serial.print("JST : ");
  Serial.println(s);

  // UTC
  // t = localtime(n, 0);
  // sprintf(s, format, year(t), month(t), day(t), hour(t), minute(t), second(t));
  // Serial.print("UTC : ");
  // Serial.println(s);
}

String changeDateTime(time_t dateTime){

  // time_t n = now();
  time_t t;
  String changeTime;

  char s[20];
  const char* format = "%04d/%02d/%02d %02d:%02d:%02d";

  // JST
  t = localtime(dateTime, 9);
  sprintf(s, format, year(t), month(t), day(t), hour(t), minute(t), second(t));
  // Serial.print("JST : ");
  Serial.println(s);

  changeTime = s;

  return changeTime;
  

  // UTC
  // t = localtime(n, 0);
  // sprintf(s, format, year(t), month(t), day(t), hour(t), minute(t), second(t));
  // Serial.print("UTC : ");
  // Serial.println(s);
}
