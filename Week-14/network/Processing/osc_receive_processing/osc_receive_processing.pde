// RECEIVING OSC FROM ANDROID

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
OscMessage myOSC;

float x, y;

void setup() {
  size(400,600);
  oscP5 = new OscP5(this, 5555); // START OSC, LISTEN ON THIS PORT
  x = width/2;
  y = height/2;
}

void draw() {
  background(0);
  ellipse(x, y, 50, 50);
}

// Parse incoming OSC messages. Looking for two integers
void oscEvent(OscMessage theOscMessage) {
    if (theOscMessage.checkAddrPattern("/coordinates")) { // This must match OSC message nake from Android app
        x = theOscMessage.get(0).intValue(); 
        y = theOscMessage.get(1).intValue();
    } 
}
