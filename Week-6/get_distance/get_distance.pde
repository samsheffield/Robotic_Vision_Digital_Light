// USING DEPTH MAP TO MEASURE REAL DISTANCES

import SimpleOpenNI.*;
SimpleOpenNI kinect;

void setup() {
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth(); // TURN ON DEPTH CAMERA
  kinect.setMirror(true); // MIRROR DISPLAY
  size(640, 480);
}

void draw() {
  kinect.update(); // GET DATA FROM KINECT
  PImage depth = kinect.depthImage(); // CREATE AN IMAGE OBJECT OF THE INCOMING DEPTH DATA
  image(depth, 0, 0);
}

void mousePressed(){
    int[] depthValues = kinect.depthMap(); // GET RAW DEPTH VALUES (MILLIMETERS). NOT IMAGE!
    int currentPixel = mouseX + (mouseY * 640); // OUR OLD FRIEND WHICH IS USED TO LOCATE A POINT ON THE SCREEN
    int millimeters = depthValues[currentPixel];
    float inches = millimeters / 25.4;
    println("mm: " + millimeters + "\tin: " + inches);
}

