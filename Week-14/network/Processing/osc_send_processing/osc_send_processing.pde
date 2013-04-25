// SENDING OSC MESSAGES TO ANDROID (USES oscP5 LIBRARY: http://www.sojamo.de/libraries/oscP5/)
// IMPORTANT: YOU MUST KNOW THE IP ADDRESS OF THE ANDROID DEVICE YOU WISH TO CONNECT TO

// Drag finger around and send the coordinates to another computer as OSC

import oscP5.*;
import netP5.*;
OscMessage myOSC;

OscP5 oscP5;
NetAddress myRemoteLocation;


void setup() {
  size(400, 600);
  orientation(PORTRAIT);
  oscP5 = new OscP5(this, 5555); // Start OSC, listen on this port
  myRemoteLocation = new NetAddress("10.0.1.17", 6666); // Change this to the address of the device you want to connect to, it should be listening on port 6666
}

void draw() {
  background(0);
  // Send mouse X and Y coordinates as OSC messages
  myOSC = new OscMessage("/coordinates"); // New message with id
  myOSC.add(mouseX); // What you want to send
  myOSC.add(mouseY); // What else you want to send
  oscP5.send(myOSC, myRemoteLocation); // Send OSC
}
