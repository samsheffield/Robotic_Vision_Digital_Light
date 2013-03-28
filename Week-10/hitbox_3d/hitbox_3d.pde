import SimpleOpenNI.*;
SimpleOpenNI  kinect;

HitBox hb1;
float startRotationY = 180; // TURN THE CAMERA 180 DEGREES TO START

void setup() {
  size(1028, 768, P3D);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  kinect.setMirror(true);
  hb1 = new HitBox(0, 0, 1400, 500);
}

void draw() {
  kinect.update();
  background(#ffff77);
  
  IntVector userList = new IntVector();
  kinect.getUsers(userList);

  if (userList.size() > 0) {
    int userId = userList.get(0);

    if ( kinect.isTrackingSkeleton(userId)) {
      translate(width/2, height/2, 0);
      rotateX(radians(180)); // INVERT IMAGE

      translate(0, 0, 1400); // DISTANCE FROM CAMERA
      float rotation = startRotationY-map(mouseX, 0, width, -180, 180);
      rotateY(radians(rotation));

      translate(0,0,-1400); // MOVE ROTATION POINT
      stroke(255);

      /*PVector position = new PVector();
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_TORSO, position);

      PMatrix3D orientation = new PMatrix3D();
      kinect.getJointOrientationSkeleton(userId, SimpleOpenNI.SKEL_TORSO, orientation);*/
      
      drawSkeleton(userId);
      drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_HAND);

      kinect.drawCamFrustum(); // WANT TO SEE THE KINECT?

      /*pushMatrix();
      translate(position.x, position.y, position.z);
      applyMatrix(orientation);
      drawOrientation();
      popMatrix();*/

      // LET'S SEE IF WE HIT A BOX
      PVector rHand = new PVector();
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, rHand);

      if(hb1.hit(rHand)){
        hb1.move();
      }
      hb1.draw();

    }else{
      translate(width/2, height/2, 0);
      image(kinect.depthImage(),-320, -240);
    }
  }
}

void drawOrientation(){
    stroke(255, 0, 0);
    line(0, 0, 0, 250, 0, 0); // X-AXIS (RED)
    stroke(0, 255, 0);
    line(0, 0, 0, 0, 250, 0); // Y-AXIS (BLUE)
    stroke(0, 0, 255);
    line(0, 0, 0, 0, 0, 250); // Z-AXIS (GREEN)
}

void drawSkeleton(int userId) {
  drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
  drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
  drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
  drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
  drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
  drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_LEFT_HIP);
}

void drawJoint(int userId, int jointID) { 
    PVector joint = new PVector();
    float confidence = kinect.getJointPositionSkeleton(userId, jointID, joint);
    if (confidence < 0.5) { // IF OPENNI IS GUESSING THE LOCATION, EXIT THIS FUNCTION IMMEDIATELY
        return;
    }
    fill(#0000ff);
    noStroke();
    pushMatrix();
    translate(joint.x, joint.y, joint.z);
    sphere(80);
    popMatrix();
}

void drawLimb(int userId,int jointType1,int jointType2){
  PVector jointPos1 = new PVector();
  PVector jointPos2 = new PVector();
  float  confidence;

  confidence = kinect.getJointPositionSkeleton(userId,jointType1,jointPos1);
  confidence +=  kinect.getJointPositionSkeleton(userId,jointType2,jointPos2);
  stroke(100);
  strokeWeight(2);
  if(confidence > 0.5){
    line(jointPos1.x,jointPos1.y,jointPos1.z, jointPos2.x,jointPos2.y,jointPos2.z);
  }
}

// user-tracking callbacks!
void onNewUser(int userId) {
  println("start pose detection");
  kinect.startPoseDetection("Psi", userId);
}

void onEndCalibration(int userId, boolean successful) {
  if (successful) { 
    println("  User calibrated !!!");
    kinect.startTrackingSkeleton(userId);
  } 
  else { 
    println("  Failed to calibrate user !!!");
    kinect.startPoseDetection("Psi", userId);
  }
}

void onStartPose(String pose, int userId) {
  println("Started pose for user");
  kinect.stopPoseDetection(userId); 
  kinect.requestCalibrationSkeleton(userId, true);
}

