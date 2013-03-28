import SimpleOpenNI.*;
SimpleOpenNI  kinect;
PImage hotdog;

void setup() {
    size(640, 480);
    kinect = new SimpleOpenNI(this);
    kinect.enableDepth(); // TURN ON DEPTH CAMERA
    kinect.setMirror(true); // MAKE INTERACTION MORE NATURAL BY MIRRORING IMAGES
    kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL); // TURN ON USER TRACKING
    hotdog = loadImage("hotdog.png");
}

void draw() {
    kinect.update();
    PImage depth = kinect.depthImage();
    image(depth, 0, 0);
    IntVector userList = new IntVector(); // WILL HOLD INTS OF USERS
    kinect.getUsers(userList); // STORE THE LIST OF DETECTED USERS
    if (userList.size() > 0) { // ANY USERS? 
        int userId = userList.get(0); // GET THE FIRST ONE
        if (kinect.isTrackingSkeleton(userId)) { // CALIBRATED?
            background(0);
            drawSkeleton(userId); // CALL FUNCTION TO DRAW SKELETON
        }
    }
}


void drawSkeleton(int userId) {

    // DRAW LIMBS
    fill(255);
    stroke(0);
    strokeWeight(5);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_LEFT_HIP);


    drawPuppetLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
    drawPuppetLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
    drawPuppetLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER); 
    drawPuppetLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
    drawPuppetLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
    drawPuppetLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP); 
    drawPuppetLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
    drawPuppetLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_LEFT_HIP);
    drawPuppetLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
    drawPuppetLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
    drawPuppetLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
    drawPuppetLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
    drawPuppetLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
    drawPuppetLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
    drawPuppetLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
    drawPuppetLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);


    // DRAW JOINTS
    /*noStroke();
     fill(255, 0, 0);
     drawJoint(userId, SimpleOpenNI.SKEL_HEAD); //
     drawJoint(userId, SimpleOpenNI.SKEL_NECK);
     drawJoint(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER);
     drawJoint(userId, SimpleOpenNI.SKEL_LEFT_ELBOW);
     drawJoint(userId, SimpleOpenNI.SKEL_NECK);
     drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
     drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW);
     drawJoint(userId, SimpleOpenNI.SKEL_TORSO);
     drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HIP);
     drawJoint(userId, SimpleOpenNI.SKEL_LEFT_KNEE);
     drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_HIP);
     drawJoint(userId, SimpleOpenNI.SKEL_LEFT_FOOT);
     drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_KNEE);
     drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HIP);
     drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_FOOT);
     drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_HAND);
     drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HAND);*/
}

void drawPuppetLimb(int userId, int jointID1, int jointID2) {

    PVector joint1 = new PVector();
    PVector joint2 = new PVector();
    kinect.getJointPositionSkeleton(userId, jointID1, joint1); 
    kinect.getJointPositionSkeleton(userId, jointID2, joint2); 


    PVector convertedJoint1 = new PVector(); // WILL HOLD JOINT POSITION
    PVector convertedJoint2 = new PVector(); // WILL HOLD JOINT POSITION

    kinect.convertRealWorldToProjective(joint1, convertedJoint1); // CONVERT THE HAND POSITION TO "PROJECTIVE" COORDINATES THAT MATCH THE DEPTH IMAGE
    kinect.convertRealWorldToProjective(joint2, convertedJoint2); // CONVERT THE HAND POSITION TO "PROJECTIVE" COORDINATES THAT MATCH THE DEPTH IMAGE


    PVector distanceVector = PVector.sub(convertedJoint2, convertedJoint1); // STORE THE DIFFERENCE BETWEEN THE VECTORS. THE ORDER MATTERS!

    pushMatrix();
    translate(convertedJoint1.x, convertedJoint1.y);
    rotate(distanceVector.heading2D()); // GET HEADING DIRECTION 

    float scaler = (dist(convertedJoint1.x, convertedJoint1.y, convertedJoint2.x, convertedJoint2.y)/294); // 294 IS IMAGE WIDTH. SCALER RESIZES IMAGE PROPORTIONATELY.
    //float scaler = 1;
    image(hotdog, 0, -60.5*scaler, 294*scaler, 121*scaler); // -60.5 = OFFSET Y TO CENTER IMAGE VERTICALLY
    popMatrix();
}

void drawJoint(int userId, int jointID) { //
    PVector joint = new PVector();
    float confidence = kinect.getJointPositionSkeleton(userId, jointID, joint);

    if (confidence < 0.5) { // IF THE JOINT CAN'T BE SEEN, EXIT THE FUNCTION
        return;
    }
    PVector convertedJoint = new PVector(); // WILL HOLD JOINT POSITION
    kinect.convertRealWorldToProjective(joint, convertedJoint); // CONVERT THE HAND POSITION TO "PROJECTIVE" COORDINATES THAT MATCH THE DEPTH IMAGE
    ellipse(convertedJoint.x, convertedJoint.y, 5, 5);
}

// USER TRACKING CALLBACKS

// CALLED TO LOOK FOR NEW USERS
void onNewUser(int userId) { 
    println("start pose detection");
    kinect.startPoseDetection("Psi", userId); // START LOOKING FOR POSERS
}

void onEndCalibration(int userId, boolean successful) {
    if (successful) { 
        println("  User calibrated !!!");
        kinect.startTrackingSkeleton(userId); // IF CALIBRATING IS OK, START TRACKING SKELETON
    } 
    else { 
        println("  Failed to calibrate user !!!");
        kinect.startPoseDetection("Psi", userId); // OTHERWISE, START LOOKING FOR POSERS AGAIN
    }
}

// CALLED WHEN A USER IS FOUND
void onStartPose(String pose, int userId) {
    println("Started pose for user");
    kinect.stopPoseDetection(userId); // POSER FOUND, SO STOP LOOKING
    kinect.requestCalibrationSkeleton(userId, true); // START CALIBRATING
}

