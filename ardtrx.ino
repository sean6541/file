#include <SimpleTimer.h>
#include <ArduinoJson.h>
#include <Reactduino.h>
#include <ReactduinoISR.h>
#include <Servo.h>

#define THROTTLE_PIN 2
#define STEERING_PIN_1 3
#define STEERING_PIN_2 4
#define TRANS_PIN 5
#define DIFF_PIN_1 6
#define DIFF_PIN_2 7

Servo throttle;
Servo steering1;
Servo steering2;
Servo trans;
Servo diff1;
Servo diff2;

int thr;
int str;
int tra;
int dif;
int timerId;

SimpleTimer timer;

bool resetting;

void reset() {
  timer.disable(timerId);
  resetting = true;
  str = 1500;
  tra = 2000;
  dif = 1000;
  steering1.writeMicroseconds(str);
  steering2.writeMicroseconds(str);
  trans.writeMicroseconds(tra);
  diff1.writeMicroseconds(dif);
  diff2.writeMicroseconds(dif);
  if (thr > 1500) {
    thr = 1000;
    throttle.writeMicroseconds(thr);
    delay(4000);
    thr = 1500;
    throttle.writeMicroseconds(thr);
  }
  if (thr <= 1500) {
    thr = 1500;
    throttle.writeMicroseconds(thr);
  }
  resetting = false;
  timer.enable(timerId);
}

Reactduino app([] () {
  Serial.begin(2000000);
  Serial.setTimeout(50);
  throttle.attach(THROTTLE_PIN);
  steering1.attach(STEERING_PIN_1);
  steering2.attach(STEERING_PIN_2);
  trans.attach(TRANS_PIN);
  diff1.attach(DIFF_PIN_1);
  diff2.attach(DIFF_PIN_2);
  thr = 1500;
  str = 1500;
  tra = 2000;
  dif = 1000;
  throttle.writeMicroseconds(thr);
  steering1.writeMicroseconds(str);
  steering2.writeMicroseconds(str);
  trans.writeMicroseconds(tra);
  diff1.writeMicroseconds(dif);
  diff2.writeMicroseconds(dif);
  timerId = timer.setInterval(500, reset);
  resetting = false;
  app.repeat(1, [] () {
    timer.run();
  });
  app.onAvailable(&Serial, [] () {
    DynamicJsonBuffer jsonBuffer;
    JsonObject& root = jsonBuffer.parseObject(Serial);
    if (root.success()) {
      if (resetting == false) {
        if (root.containsKey("throttle")) {
          thr = map(root["throttle"], 0, 100, 1000, 2000);
          throttle.writeMicroseconds(thr);
        }
        if (root.containsKey("steering")) {
          str = map(root["steering"], 0, 100, 1000, 2000);
          steering1.writeMicroseconds(str);
          steering2.writeMicroseconds(str);
        }
        if (root.containsKey("trans")) {
          tra = map(root["trans"], 0, 100, 1000, 2000);
          trans.writeMicroseconds(tra);
        }
        if (root.containsKey("diff")) {
          dif = map(root["diff"], 0, 100, 1000, 2000);
          diff1.writeMicroseconds(dif);
          diff2.writeMicroseconds(dif);
        }
        if (root.containsKey("reset")) {
          if (root["reset"] == true) {
            reset();
          }
        }
        timer.restartTimer(timerId);
      }
    }
  });
});
