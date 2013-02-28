import SimpleOpenNI.*;
import peasy.*;

PeasyCam cam;
SimpleOpenNI kinect;

void setup() {
 size(640, 480, P3D);
 kinect = new SimpleOpenNI(this);
 kinect.enableDepth();
 kinect.setMirror(true);
 cam = new PeasyCam(this, 0, 0, 0, 1000);
 stroke(255);
}

void draw() {
  background(0); 
  kinect.update();

  lights();
  rotateX(radians(180)); // FLIP INVERTED 3D

  PVector[] depthPoints = kinect.depthMapRealWorld();
  for (int i = 0; i < depthPoints.length; i+=13) {
    PVector currentPoint = depthPoints[i];
    point(currentPoint.x, currentPoint.y, currentPoint.z);
  }
}