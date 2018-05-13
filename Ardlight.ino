#define RED_LED_PIN A0
#define GREEN_LED_PIN A1
#define BLUE_LED_PIN A2
#define BAUD_RATE 9600

void setup() {
  Serial.begin(BAUD_RATE);
  pinMode(RED_LED_PIN, OUTPUT);
  pinMode(GREEN_LED_PIN, OUTPUT);
  pinMode(BLUE_LED_PIN, OUTPUT);
}

void loop() {
  String hexstring = Serial.readString();
  if (hexstring != "") {
    int i = hexstring.indexOf("#");
    int r;
    int g;
    int b;
    if (i != -1) {
      long number = (long) strtol( &hexstring[1], NULL, 16);
      r = number >> 16;
      g = number >> 8 & 0xFF;
      b = number & 0xFF;
    } else {
      long number = (long) strtol( &hexstring[0], NULL, 16);
      r = number >> 16;
      g = number >> 8 & 0xFF;
      b = number & 0xFF;
    }
    analogWrite(RED_LED_PIN, r);
    analogWrite(GREEN_LED_PIN, g);
    analogWrite(BLUE_LED_PIN, b);
  }
}
