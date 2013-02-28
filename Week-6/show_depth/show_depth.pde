// DISPLAYING AN IMAGE OF THE DEPTH MAP

import SimpleOpenNI.*;
SimpleOpenNI kinect;

void setup() {
  kinect = new SimpleOpenNI(this); // INSTANTIATE A SIMPLEOPENNI OBJECT IN PROCESSING
  kinect.enableDepth(); // TURN ON DEPTH CAMERA
  //kinect.setMirror(true); // MIRROR DISPLAY
  size(640, 480);
}

void draw() {
  kinect.update(); // GET DATA FROM KINECT
    
  PImage depth = kinect.depthImage(); // CREATE A PImage OF THE DEPTH IMAGE (THIS IS FOR CONVENIENCE... SEE BELOW)
  image(depth, 0, 0);
  //image(kinect.depthImage(), 0, 0); // SAME AS ABOVE
}
