import SimpleOpenNI.*;
SimpleOpenNI kinect;

void setup() {
  kinect = new SimpleOpenNI(this); 
  kinect.enableIR(); 
  size(640, 480);
}

void draw() {
  kinect.update();
  PImage ir = kinect.irImage(); 
  image(ir, 0, 0); 
}
