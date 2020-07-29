int output1 = 16;
int mtime = 500;

void setup() {
	pinMode(output1, OUTPUT);
}

void loop(){
	if (mtime <= 0){
		mtime=500;
	}else{
		mtime = mtime - 50;
	}

	digitalWrite(output1, HIGH);
	delay(mtime);
	digitalWrite(output1, LOW);
	delay(mtime);
}
