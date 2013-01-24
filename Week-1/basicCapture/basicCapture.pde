// Based on GettingStartedCapture video example 

import processing.video.*;

Capture cam;

void setup() {
  size(640, 480);
  noSmooth(); // smooth is the new default
  String[] cameras = Capture.list();
  for (int i = 0; i < cameras.length; i++) {
    println(cameras[i]);
  }
  //cam = new Capture(this, cameras[0]); // capture at specified configuration
  cam = new Capture(this, width, height, 30); // or force it. framerate is optional
  cam.start();
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  }
  
  tint(mouseX, mouseY, 255);
  image(cam, 0, 0, width, height);

  fill(255, 0, 0);
  textSize(20);
  text(frameRate, 10, 30);
}

