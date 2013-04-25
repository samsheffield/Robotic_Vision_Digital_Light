// SENDING OSC MESSAGES FROM ANDROID (USES oscP5 LIBRARY: http://www.sojamo.de/libraries/oscP5/)
// COPY oscP5.jar from libraries > oscP5 > library INTO A FOLDER CALLED code INSIDE OF YOUR SKETCH FOLDER.
// IMPORTANT: SET INTERNET PERMISSIONS FOR YOUR SKETCH
// IMPORTANT: YOU MUST KNOW THE IP ADDRESS OF THE COMPUTER YOU WISH TO CONNECT TO

// Drag finger around and sned the coordinates to another computer as OSC

import oscP5.*;
import netP5.*;
OscMessage myOSC;

OscP5 oscP5;
NetAddress myRemoteLocation;


void setup() {
  orientation(PORTRAIT);
  oscP5 = new OscP5(this, 6666); // Start OSC, listen on this port
  myRemoteLocation = new NetAddress("10.0.1.21", 5555); // Change this to the address of the computer you want to connect to, it should be listening on port 5555
}

void draw() {
  background(0);
  // Send touch X and Y coordinates as OSC messages
  myOSC = new OscMessage("/coordinates"); // New message with id
  myOSC.add(mouseX); // What you want to send
  myOSC.add(mouseY); // What else you want to send
  oscP5.send(myOSC, myRemoteLocation); // Send OSC
}
