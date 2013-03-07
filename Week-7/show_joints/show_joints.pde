import SimpleOpenNI.*;
SimpleOpenNI  kinect;
void setup() {
    kinect = new SimpleOpenNI(this);
    kinect.enableDepth();
    kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
    size(640, 480);
    fill(255, 0, 0);
}
void draw() {
    kinect.update();
    image(kinect.depthImage(), 0, 0);
    IntVector userList = new IntVector();
    kinect.getUsers(userList);

    if (userList.size() > 0) {
        int userId = userList.get(0);
        if ( kinect.isTrackingSkeleton(userId)) {
            noStroke();
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
            drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HAND);
        }
    }
}

void drawJoint(int userId, int jointID) { 
    PVector joint = new PVector();
    float confidence = kinect.getJointPositionSkeleton(userId, jointID, joint);
    if (confidence < 0.5) { // IF OPENNI IS GUESSING THE LOCATION, EXIT THIS FUNCTION IMMEDIATELY
        return;
    }
    PVector convertedJoint = new PVector();
    kinect.convertRealWorldToProjective(joint, convertedJoint);
    ellipse(convertedJoint.x, convertedJoint.y, 5, 5);
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

