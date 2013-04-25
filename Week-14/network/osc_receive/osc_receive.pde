// RECEIVING OSC MESSAGES ON ANDROID (USES oscP5 LIBRARY: http://www.sojamo.de/libraries/oscP5/)
// COPY oscP5.jar from libraries > oscP5 > library INTO A FOLDER CALLED code INSIDE OF YOUR SKETCH FOLDER.
// IMPORTANT: SET INTERNET PERMISSIONS FOR YOUR SKETCH
// IMPORTANT: YOU MUST KNOW THE IP ADDRESS OF THE COMPUTER YOU WISH TO CONNECT TO

// Move mouse on computer and see the ellipse move on your Android device

import oscP5.*;
import netP5.*;
OscMessage myOSC;

OscP5 oscP5;
NetAddress myRemoteLocation;
int x, y;

void setup() {
	orientation(PORTRAIT);
	oscP5 = new OscP5(this, 6666); // Start OSC, listen on this port
	myRemoteLocation = new NetAddress("10.0.1.21", 5555); // Change this to the address of the computer you want to connect to, it should be listening on port 5555
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