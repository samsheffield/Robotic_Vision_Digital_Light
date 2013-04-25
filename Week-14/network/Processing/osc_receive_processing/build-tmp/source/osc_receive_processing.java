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

public class osc_receive_processing extends PApplet {

// RECEIVING OSC FROM ANDROID




OscP5 oscP5;
NetAddress myRemoteLocation;
OscMessage myOSC;

float x, y;

public void setup() {
  size(400,600);
  oscP5 = new OscP5(this, 5555); // START OSC, LISTEN ON THIS PORT
  x = width/2;
  y = height/2;
}

public void draw() {
  background(0);
  ellipse(x, y, 50, 50);
}

// DEAL WITH INCOMING OSC
public void oscEvent(OscMessage theOscMessage) {
    if (theOscMessage.checkAddrPattern("/coordinates")) { // This must match OSC message nake from Android app
        x = theOscMessage.get(0).intValue(); 
        y = theOscMessage.get(1).intValue();
    } 
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#000000", "--hide-stop", "osc_receive_processing" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
