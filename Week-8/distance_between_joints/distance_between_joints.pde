// GET DISTANCE BETWEEN 2 JOINTS

import SimpleOpenNI.*;
SimpleOpenNI  kinect;

void setup() {
    kinect = new SimpleOpenNI(this);
    kinect.enableDepth();
    kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL); 
    kinect.setMirror(true); 
    size(640, 480);
}

void draw() {
    kinect.update();
    PImage depth = kinect.depthImage();
    image(depth, 0, 0);  
    IntVector userList = new IntVector(); 
    kinect.getUsers(userList); 

    if (userList.size() > 0) { 
        int userId = userList.get(0); 
        if (kinect.isTrackingSkeleton(userId)) { 

            PVector leftHand = trackJoint(userId, SimpleOpenNI.SKEL_LEFT_HAND);
            PVector rightHand = trackJoint(userId, SimpleOpenNI.SKEL_RIGHT_HAND);

            float distance = PVector.dist(leftHand, rightHand); // GET THE 3D DISTANCE BETWEEN LEFT AND RIGHT HANDS. TO CONVERT IT TO INCHES, DIVIDE BY 25.4.
            float distance2D = dist(leftHand.x, leftHand.y, rightHand.x, rightHand.y); // 2D DISTANCE
            noStroke();
            fill(#ffff00);
            textSize(30);
            text("3D: " + (int)distance, 20, 30);
            text("2D: " + (int)distance2D, 20, 70);
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

