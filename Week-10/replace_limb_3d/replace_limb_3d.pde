import SimpleOpenNI.*;
SimpleOpenNI  kinect;

void setup() {
  size(1028, 768, P3D);

  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  kinect.setMirror(true);
  
}

void draw() {
  kinect.update();
  background(#666666);
  lights();
  IntVector userList = new IntVector();
  kinect.getUsers(userList);
  if (userList.size() > 0) {
    int userId = userList.get(0);

    if ( kinect.isTrackingSkeleton(userId)) {
      translate(width/2, height/2, 0);
      rotateX(radians(180));
      drawSkeleton(userId);
      noStroke();

      PVector position = new PVector();
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, position);

      PMatrix3D orientation = new PMatrix3D();
      kinect.getJointOrientationSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, orientation);

      pushMatrix();
      translate(position.x, position.y, position.z);
      applyMatrix(orientation);
      translate(150,0,0); // TRANSLATE WIDTH OF BOX/2 TO FIX ROTATION TO END
      fill(#7db3a4);
      box(300, 100, 100);
      popMatrix();

      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, position);
      kinect.getJointOrientationSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, orientation);

      pushMatrix();
      translate(position.x, position.y, position.z);
      applyMatrix(orientation);
      translate(150,0,0); 
      fill(#51b3ab);
      box(300, 100, 100);
      popMatrix();
    }else{
      translate(width/2, height/2, 0);
      image(kinect.depthImage(), -320, -240);
    }
  }
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

// CUSTOM drawLimb WHICH DOES NOT CONVERT TO PROJECTIVE SPACE
void drawLimb(int userId,int startJoint,int endJoint){
  PVector joint1 = new PVector();
  PVector joint2 = new PVector();
  float  confidence;

  // ONLY DRAW LIMB IF CUMULATIVE CONFIDENCE IS HIGH ENOUGH
  confidence = kinect.getJointPositionSkeleton(userId, startJoint, joint1);
  confidence +=  kinect.getJointPositionSkeleton(userId, endJoint, joint2);
  
  if(confidence > 0.5){
    stroke(255);
    strokeWeight(2);
    line(joint1.x,joint1.y,joint1.z, joint2.x,joint2.y,joint2.z);
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

