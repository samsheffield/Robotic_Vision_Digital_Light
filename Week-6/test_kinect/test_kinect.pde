import SimpleOpenNI.*;
SimpleOpenNI kinect;

void setup() {
  kinect = new SimpleOpenNI(this); 
  kinect.enableRGB(); 
  kinect.setMirror(true);
  size(640, 480);
}

void draw() {
  kinect.update();
  PImage ir = kinect.rgbImage(); 
  image(ir, 0, 0); 
}
