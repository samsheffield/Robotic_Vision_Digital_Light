// USER SKELETON AUTOCALIBRATION

import SimpleOpenNI.*;
SimpleOpenNI  kinect;

// A CALIBRATION FILE MUST BE IN data FOLDER

void setup() {
    size(640, 480);
    kinect = new SimpleOpenNI(this);
    kinect.enableDepth();
    kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL); // WE WANT TO TRACK USER SKELETONS
    kinect.setMirror(true);
}
void draw() {
    kinect.update();
    image(kinect.depthImage(), 0, 0); // SHOW DEPTH IMAGE
    IntVector userList = new IntVector();
    kinect.getUsers(userList);

    if (userList.size() > 0) {
        int userId = userList.get(0);
        if ( kinect.isTrackingSkeleton(userId)) {
            strokeWeight(3);
            stroke(#ffff00);
            drawSkeleton(userId);
        }
    }
}

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

// CALLED WHEN A USER IS DETECTED
void onNewUser(int userId) {
    println("start auto calibration");

    if (kinect.loadCalibrationDataSkeleton(userId, "calibration.skel")) { // IF USER SKELETON CAN BE TRACKED USING CALIBRATION FILE
        println("calibration succeeded");
        kinect.startTrackingSkeleton(userId); // START TRACKING SKELETON
    } 
    else {
        println("calibration failed");
    }
}