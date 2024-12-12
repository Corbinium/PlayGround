/*********
  Rui Santos
  Complete project details at https://RandomNerdTutorials.com/vs-code-platformio-ide-esp32-esp8266-arduino/
*********/

#include <Arduino.h>
#include <string>
#include <sstream>

#define LED 2

/*
  Reload
*/
const int reloadPin = 34;

void setupReload() {
  pinMode(reloadPin, INPUT);
}

void runReload() {
  int state = digitalRead(reloadPin);
  // std::ostringstream message;
  // message << "Reload state: " << state;
  // Serial.println(message.str().c_str());
  if (state == HIGH) {
    Serial.println("Reloading...");
    delay(1000);
  }
}


/*
  Fire
*/
const int firePin = 13;
const int triggerPin = 35;

void setupFire() {
  pinMode(firePin, OUTPUT);
  pinMode(triggerPin, INPUT);
}

void runFire() {
  int state = digitalRead(triggerPin);
  // std::ostringstream message;
  // message << "Trigger state: " << state;
  // Serial.println(message.str().c_str());
  if (state == HIGH) {
    Serial.println("Firing...");
    digitalWrite(firePin, HIGH);
    delay(100);
    digitalWrite(firePin, LOW);
  }
}


/*
  Get Hit
*/
const int hitPin = 32;
int health = 0;

void setupHit() {
  pinMode(hitPin, INPUT);
  health = 9;
}

void runHit() {
  int state = analogRead(hitPin);
  std::ostringstream message;
  message << "  " << state;
  Serial.println(message.str().c_str());
  // if (state == HIGH) {
  //   health--;
  //   std::ostringstream message2;
  //   message2 << "You got hit! health " << health;
  //   Serial.println(message2.str().c_str());
  //   delay(500);
  // }
}


/*
  Change Weapon
*/
const int weaponPin = 33;
int weapon = 0;
bool weaponChanged = false;

void setupWeapon() {
  pinMode(weaponPin, INPUT);
  weapon = 0;
  weaponChanged = false;
}

void runWeapon() {
  int state = analogRead(weaponPin);
  // int stateD = digitalRead(weaponPin);
  // std::ostringstream message;
  // message << stateD << "   " << state;
  // Serial.println(message.str().c_str());
  if (state > 0x500 && !weaponChanged) {
    weapon++;
    weapon = weapon % 4;
    std::ostringstream message2;
    message2 << "Weapon changed! weapon: " << weapon;
    Serial.println(message2.str().c_str());
    weaponChanged = true;
    delay(100);
  } else if (state == LOW) {
    weaponChanged = false;
  }
}


/*
  Change Team
*/
const int teamPin = 27;
int team = 0;
bool teamChanged = false;

void setupTeam() {
  pinMode(teamPin, INPUT);
  team = 0;
  teamChanged = false;
}

void runTeam() {
  int state = analogRead(teamPin);
  // std::ostringstream message;
  // message << "Team state: " << state;
  // Serial.println(message.str().c_str());
  if (state > 0x500 && !teamChanged) {
    team++;
    team = team % 4;
    std::ostringstream message2;
    message2 << "Team changed! team: " << team;
    Serial.println(message2.str().c_str());
    teamChanged = true;
    delay(100);
  } else if (state == LOW) {
    teamChanged = false;
  }
}


/*
  sound
*/
const int soundPin = 26;
void setupSound() {
  pinMode(soundPin, OUTPUT);
}

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  

  setupReload();
  setupFire();
  setupHit();
  setupWeapon();
  setupTeam();
  setupSound();
}

void loop() {
  runReload();
  runFire();
  runHit();
  runWeapon();
  runTeam();
}
