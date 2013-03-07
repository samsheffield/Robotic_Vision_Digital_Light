import SimpleOpenNI.*;
SimpleOpenNI  kinect;

void setup() {
    size(640, 480);
    kinect = new SimpleOpenNI(this);
    kinect.enableDepth(); 
    kinect.setMirror(true); 
    kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
}

void draw() {
    kinect.update();
    PImage depthImage = kinect.depthImage();
    image(depthImage, 0, 0);

    IntVector userList = new IntVector(); 
    kinect.getUsers(userList); 
    
    if (userList.size() > 0) {
        int userId = userList.get(0);
        if (kinect.isTrackingSkeleton(userId)) { 
            PVector leftHand = new PVector(); 
            kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, leftHand);
            PVector convertedLeftHand = new PVector();
            kinect.convertRealWorldToProjective(leftHand, convertedLeftHand);
            fill(255, 0, 0);
            ellipse(convertedLeftHand.x, convertedLeftHand.y, 20, 20);

            PVector rightHand = new PVector();
            kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);
            PVector convertedRightHand = new PVector();
            kinect.convertRealWorldToProjective(rightHand, convertedRightHand);
            fill(0, 255, 0);
            ellipse(convertedRightHand.x, convertedRightHand.y, 20, 20);

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