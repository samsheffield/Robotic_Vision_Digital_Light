import SimpleOpenNI.*;
SimpleOpenNI  kinect;

int userId = 0; // ONLY USE FIRST TRACKED USER

void setup() {
    size(640, 480);
    kinect = new SimpleOpenNI(this);
    kinect.enableDepth();
    kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL); // WE WANT ALL SKELETAL JOINTS
    kinect.setMirror(true);
}

void draw() {
    kinect.update();
    PImage userImage = kinect.depthImage();
    image(userImage, 0, 0);
    
    IntVector userList = new IntVector();
    kinect.getUsers(userList);
    if (userList.size() > 0) { // IF THERE IS A USER...
        userId = userList.get(0); // GET THEIR ID NUMBER (0 = FIRST USER)
        if (kinect.isTrackingSkeleton(userId)) { // IF SKELETON IS BEING TRACKED
            stroke(255,0,0);
            strokeWeight(3);
            drawSkeleton(userId); // DRAW SKELETON
        }
    }
}

// SAVE SKELETON CALIBRATION IN DATA FOLDER WHEN A KEY IS PRESSED
void keyPressed() {
    if (kinect.isTrackingSkeleton(userId)) { // IF SKELETON IS BEING TRACKED...
        kinect.saveCalibrationDataSkeleton(userId, "calibration.skel"); // SAVE CALIBRATION INFO IN FILE
    }
}

// DRAW THE SKELETON OF THE SELECTED USER
void drawSkeleton(int userId) {
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
}


// USER TRACKING
void onNewUser(int userId) {
    println("start pose detection");
    kinect.startPoseDetection("Psi", userId);
}

void onStartPose(String pose, int userId) {
    println("Started pose for user");
    kinect.stopPoseDetection(userId);
    kinect.requestCalibrationSkeleton(userId, true);
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

