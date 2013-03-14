// GET 2D ANGLE OF LIMB

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
            PVector leftElbow = trackJoint(userId, SimpleOpenNI.SKEL_LEFT_ELBOW);

            strokeWeight(3);
            stroke(#ffff00);
            line(leftHand.x, leftHand.y, leftElbow.x, leftElbow.y);

            PVector differenceVector = PVector.sub(leftElbow, leftHand); // STORE THE DIFFERENCE BETWEEN THE VECTORS.
            println(differenceVector.heading2D());
            
            noStroke();
            fill(#ffff00);
            textSize(60);
            text(degrees(differenceVector.heading2D()), 50, 50); // -180 TO 180 DEGREES
            //text(degrees(differenceVector.heading2D()+PI), 50, 50); // 360 DEGREES, BUT NOTICE HOW OUR 0 DEGREE IS NOW ON THE OPPOSITE SIDE.
        }
    }
}

// RETURN PVector OF CONVERTED JOINT POSITION
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

// CALLED WHEN A USER IS FOUND
void onStartPose(String pose, int userId) {
    println("Started pose for user");
    kinect.stopPoseDetection(userId); // POSER FOUND, SO STOP LOOKING
    kinect.requestCalibrationSkeleton(userId, true); // START CALIBRATING
}

// CALIBRATION IS DONE
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

