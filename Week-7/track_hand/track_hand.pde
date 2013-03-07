import SimpleOpenNI.*;
SimpleOpenNI  kinect;

void setup() {
    size(640, 480);
    kinect = new SimpleOpenNI(this);
    kinect.enableDepth(); // TURN ON DEPTH CAMERA
    kinect.setMirror(true); // MAKE INTERACTION MORE NATURAL BY MIRRORING IMAGES
    kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL); // TURN ON USER TRACKING
}

void draw() {
    kinect.update();
    PImage depthImage = kinect.depthImage();
    image(depthImage, 0, 0);

    IntVector userList = new IntVector(); // WILL HOLD INTS OF USERS
    kinect.getUsers(userList); // STORE THE LIST OF DETECTED USERS
    
    if (userList.size() > 0) { // ANY USERS? 
        int userId = userList.get(0); // GET THE FIRST ONE
        if (kinect.isTrackingSkeleton(userId)) { // CALIBRATED?
            PVector leftHand = new PVector(); // WILL HOLD LEFT HAND LOCATION
            kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, leftHand); // PUT POSITION INTO VECTOR
            PVector convertedLeftHand = new PVector();
            kinect.convertRealWorldToProjective(leftHand, convertedLeftHand); // CONVERT THE HAND POSITION TO "PROJECTIVE" COORDINATES THAT MATCH THE DEPTH IMAGE
            fill(255, 0, 0);
            ellipse(convertedLeftHand.x, convertedLeftHand.y, 20, 20); // DRAW ELLIPSE
        }
    }
}

// USER TRACKING CALLBACKS

// CALLED TO LOOK FOR NEW USERS
void onNewUser(int userId) { 
    println("start pose detection");
    kinect.startPoseDetection("Psi", userId); // START LOOKING FOR POSERS
}

// CALLED WHEN A USER IS FOUND
void onStartPose(String pose, int userId) {
    println("Started pose for user");
    kinect.stopPoseDetection(userId); // POSER FOUND, SO STOP LOOKING
    kinect.requestCalibrationSkeleton(userId, true); // START CALIBRATING
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