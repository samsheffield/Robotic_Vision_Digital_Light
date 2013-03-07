import SimpleOpenNI.*;
SimpleOpenNI  kinect;


void setup() {
    kinect = new SimpleOpenNI(this);
    kinect.enableDepth();
    kinect.setMirror(true);
    kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL); 
    size(640, 480);
}
void draw() {
    kinect.update();
    PImage depthImage = kinect.depthImage();
    image(depthImage, 0, 0);

    PVector user1LeftHand = new PVector();
    PVector user2LeftHand = new PVector();

    IntVector userList = new IntVector();
    kinect.getUsers(userList); 

    if (userList.size() > 0) { 
        for (int i = 0; i <userList.size(); i++) { 
            if (kinect.isTrackingSkeleton(0)) {
                user1LeftHand = getJointXYZ(0, SimpleOpenNI.SKEL_LEFT_HAND); 
                fill(255, 0, 0);
                ellipse(user1LeftHand.x, user1LeftHand.y, 20, 20);
            }
            if (kinect.isTrackingSkeleton(1)) {
                user2LeftHand = getJointXYZ(1, SimpleOpenNI.SKEL_LEFT_HAND); 
                fill(0, 255, 0);
                ellipse(user2LeftHand.x, user2LeftHand.y, 20, 20);
            }
        }
    }
}

PVector getJointXYZ(int userId, int jointID) { 
    PVector joint = new PVector();
    float confidence = kinect.getJointPositionSkeleton(userId, jointID, joint);
    if (confidence < 0.5) return;
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

// CALLED WHEN A USER IS FOUND
void onStartPose(String pose, int userId) {
    println("Started pose for user " + userId);
    kinect.stopPoseDetection(userId); // POSER FOUND, SO STOP LOOKING
    kinect.requestCalibrationSkeleton(userId, true); // START CALIBRATING
}

// CALLED WHEN CALIBRATION IS COMPLETE
void onEndCalibration(int userId, boolean successful) {
    if (successful) { 
        println("  User " + userId + " calibrated !!!");
        kinect.startTrackingSkeleton(userId); // IF CALIBRATING IS OK, START TRACKING SKELETON
    } 
    else { 
        println("  Failed to calibrate user" + userId + "!!!");
        kinect.startPoseDetection("Psi", userId); // OTHERWISE, START LOOKING FOR POSERS AGAIN
    }
}

