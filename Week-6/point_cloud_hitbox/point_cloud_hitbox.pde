// HITTING A 3D CUBE. ORIGINAL CODE BY GREG BORENSTEIN (http://bit.ly/13pswhJ)

import SimpleOpenNI.*;
SimpleOpenNI kinect;

float rotation;

int boxSize = 150;
PVector boxCenter = new PVector(0, 0, 600);

void setup() {
  size(800, 600, P3D);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.setMirror(true);
}

void draw() {
  background(0);
  kinect.update();

  translate(width/2, height/2, -1000);
  rotateX(radians(180));

  translate(0, 0, 1400);
  rotateY(radians(map(mouseX, 0, width, -180, 180)));
  
  translate(0,0,-1000);
  stroke(255);

  PVector[] depthPoints = kinect.depthMapRealWorld();

  // HOW MANY POINTS ARE HIT IN BOX
  int depthPointsInBox = 0;

  for (int i = 0; i < depthPoints.length; i+=13) {
    PVector currentPoint = depthPoints[i];

    // 3D HIT TEST
    if (currentPoint.x > boxCenter.x - boxSize/2 && currentPoint.x < boxCenter.x + boxSize/2) {
      if (currentPoint.y > boxCenter.y - boxSize/2 && currentPoint.y < boxCenter.y + boxSize/2) {
        if (currentPoint.z > boxCenter.z - boxSize/2 && currentPoint.z < boxCenter.z + boxSize/2) {
          depthPointsInBox++; // COUNT HOW MANY POINTS ARE COLLIDING WITH THE BOX
        }
      }
    }

    point(currentPoint.x, currentPoint.y, currentPoint.z);
  }
  
    println(depthPointsInBox);

  // MAP NUMBER OF HIT POINTS TO AN ALPHA RANGE
  float boxAlpha = map(depthPointsInBox, 0, 1000, 0, 255);
  
  translate(boxCenter.x, boxCenter.y, boxCenter.z);
  fill(255, 0, 0, boxAlpha);
  stroke(255, 0, 0);
  box(boxSize);
}