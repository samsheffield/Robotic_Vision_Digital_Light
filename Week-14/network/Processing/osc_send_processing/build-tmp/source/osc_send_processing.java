import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import oscP5.*; 
import netP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class osc_send_processing extends PApplet {

// SENDING OSC MESSAGES TO ANDROID (USES oscP5 LIBRARY: http://www.sojamo.de/libraries/oscP5/)
// IMPORTANT: YOU MUST KNOW THE IP ADDRESS OF THE ANDROID DEVICE YOU WISH TO CONNECT TO

// Drag finger around and send the coordinates to another computer as OSC



OscMessage myOSC;

OscP5 oscP5;
NetAddress myRemoteLocation;


public void setup() {
  size(400, 600);
  orientation(PORTRAIT);
  oscP5 = new OscP5(this, 5555); // Start OSC, listen on this port
  myRemoteLocation = new NetAddress("10.0.1.17", 6666); // Change this to the address of the device you want to connect to, it should be listening on port 6666
}

public void draw() {
  background(0);
  // Send mouse X and Y coordinates as OSC messages
  myOSC = new OscMessage("/coordinates"); // New message with id
  myOSC.add(mouseX); // What you want to send
  myOSC.add(mouseY); // What else you want to send
  oscP5.send(myOSC, myRemoteLocation); // Send OSC
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#000000", "--hide-stop", "osc_send_processing" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
