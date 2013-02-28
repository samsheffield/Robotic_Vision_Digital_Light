// RENDERING A SCENE AS A 3D POINT CLOUD

import SimpleOpenNI.*;
SimpleOpenNI kinect;
float rotation, rspeed;

void setup() {
  size(640, 480, P3D);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.setMirror(true);
  stroke(255);
}

void draw() {
  background(0);
  kinect.update();

  translate(width/2, height/2, -500); // X Y Z
  rotateX(radians(180)); // 3D FROM THE KINECT IS INVERTED SO WE NEED TO FLIP IT

  translate(0, 0, 500); // X Y Z
  rotateY(radians(rotation));
  
  // EXTRACT A PVector ARRAY OF POINTS
  PVector[] depthPoints = kinect.depthMapRealWorld();  
  for(int i = 0; i < depthPoints.length; i+=13){ // REDUCE POINTS BY RAISING NUMBER
    PVector currentPoint = depthPoints[i];
    point(currentPoint.x, currentPoint.y, currentPoint.z);  
  }
  rotation += rspeed;
}

// SPIN
void mouseMoved(){
  rspeed = (width/2-mouseX)*.025;
}