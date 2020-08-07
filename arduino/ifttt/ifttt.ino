#include <ESP8266WiFi.h>

//WiFi設定 各自環境によって設定が必要
const char* ssid = "wifi";
const char* password = "0569425451";

const char* host_IFTTT = "maker.ifttt.com";
String url_IFTTT = "/trigger/digimonotest/with/key/e4O73zKaot3zR3TRfdx6KijgXNLCn0Bi-lfJoXBxDy3";
String SendMsg;

int output1 = 16;
int mtime = 500;
int input1 = 14;
int cnt = 0;
int beforeinput = 0;

//WiFi設定
void wifiConnect() {
  delay(1000);
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

  WiFiClientSecure client;
  Serial.println("Try");

 //セキュリティの設定を少々緩和
  //https://www.motohasi.net/blog/?p=3885
  client.setInsecure();

  //IFTTTのAPIサーバに接続
  if (!client.connect(host_IFTTT, 443)) {
    Serial.println("Connection failed");
    return;
  }
  Serial.println("Connected");
  //リクエストを送信
  String query = SendMsg;

  Serial.println(query);
  
  String request = String("") +
                   "POST " + url_IFTTT + " HTTP/1.1\r\n" +
                   "Host: " + host_IFTTT + "\r\n" +
                   "Content-Length: " + String(query.length()) +  "\r\n" +
                   // "Content-Type: application/x-www-form-urlencoded\r\n\r\n" +
                   "Content-Type: application/json\r\n\r\n" +
                   query + "\r\n";
  client.print(request);

//受信完了ではなく、1秒待つように訂正
  delay(1000);

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
  pinMode(input1, INPUT);
  Serial.begin(9600);

  //WIFI_STAをつけないとサーバーモードで必ず起動してしまうので注意
  WiFi.mode(WIFI_STA);

  wifiConnect();
}

void loop() {
  boolean sw = digitalRead(input1);
  if(beforeinput != sw){
    Serial.println(sw);
    beforeinput = sw;
  }

  if(sw == 1){
    
    if(cnt >= mtime *2 ){
      cnt = 0;

      //約1秒経過したらIFTTTをする
      String msg_IFTTT_value1;
      String msg_IFTTT_value2;
      String msg_IFTTT_value3;

      // --------------------------
      // IFTTT経由でSlackに投稿するプログラム
      // --------------------------
      
      msg_IFTTT_value1 = "J";
      msg_IFTTT_value2 = "大森";
      msg_IFTTT_value3 = String(sw);
      
      SendMsg ="{\"value1\": \"" + msg_IFTTT_value1 + "\"," + 
                 "\"value2\": \"" + msg_IFTTT_value2 + "\","  +  
                  "\"value3\": \"" + msg_IFTTT_value3 + "\"}";
      
      sendIFTTTWebhook();
    
      
    }else{
      cnt = cnt + 1;
    }
  
    if( cnt <= mtime){
      digitalWrite(output1, HIGH);
    }
  
    if( cnt >= mtime){
      digitalWrite(output1, LOW);
    }
  }else{
    cnt = 0;
    digitalWrite(output1, LOW);
  }
  delay(1);
}
