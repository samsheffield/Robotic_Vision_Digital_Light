// BASIC POSE DETECTION TECHNIQUE

import SimpleOpenNI.*;
SimpleOpenNI  kinect;

color c = #222222;

void setup() {
    size(640, 480);
    kinect = new SimpleOpenNI(this);
    kinect.enableDepth();
    kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
    kinect.setMirror(true);
    strokeWeight(3);
}
void draw() {

    kinect.update();
    IntVector userList = new IntVector();
    kinect.getUsers(userList);

    if (userList.size() > 0) {
        background(c);
        int userId = userList.get(0);
        if ( kinect.isTrackingSkeleton(userId)) {
            int activeLimbs = 0; // RESET ACTIVE LIMB COUNT
            // HOLD JOINT INFO
            PVector rightHand = trackJoint(userId, SimpleOpenNI.SKEL_RIGHT_HAND);
            PVector rightElbow = trackJoint(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW);
            PVector rightShoulder = trackJoint(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER);

            // IF RIGHT ELBOW IS ABOVE AND TO THE RIGHT OF THE RIGHT SHOULDER...
            if (rightElbow.y < rightShoulder.y && rightElbow.x > rightShoulder.x) { 
                stroke(255, 0, 0);
                activeLimbs++;
            } else { 
                stroke(255); 
            }
            kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);

            // IF RIGHT HAND IS ABOVE AND TO THE RIGHT OF THE RIGHT ELBOW MAKE IT WHITE
            if (rightHand.y < rightElbow.y && rightHand.x > rightElbow.x) {
                stroke(255, 0, 0); 
                activeLimbs++;
            } else {
                stroke(255);
            }
            kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HAND, SimpleOpenNI.SKEL_RIGHT_ELBOW);

            // CHECK THE NUMBER OF LIMBS IN THE CORRECT POSITION
            if (activeLimbs == 2) {
                c = #ffff00;
            } else {
                c = #222222;
            }

        } else {
            image(kinect.depthImage(), 0, 0); //ONLY SHOW DEPTH IMAGE IF THERE ARE NO USERS
        }

    }
}

// RETURN PVECTOR OF CONVERTED JOINT POSITION
PVector trackJoint(int userId, int jointID) {
    PVector joint = new PVector();
    kinect.getJointPositionSkeleton(userId, jointID, joint);
    PVector convertedJoint = new PVector(); 
    kinect.convertRealWorldToProjective(joint, convertedJoint); 
    return convertedJoint;
}

// CALIBRATION
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

