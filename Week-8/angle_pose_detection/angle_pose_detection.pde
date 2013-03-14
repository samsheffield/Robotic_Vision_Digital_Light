// USE ANGLE TO DETECT POSE

import SimpleOpenNI.*;
SimpleOpenNI  kinect;

color c = #222222;
color limbcolor, limbcolor2;

void setup() {
    kinect = new SimpleOpenNI(this);
    kinect.enableDepth();
    kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL); 
    kinect.setMirror(true); 
    size(640, 480);
    strokeWeight(3);
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
            background(c);
            int activeLimbs = 0; // RESET ACTIVE LIMB COUNT

            // LEFT ARM
            PVector leftHand = trackJoint(userId, SimpleOpenNI.SKEL_LEFT_HAND);
            PVector leftElbow = trackJoint(userId, SimpleOpenNI.SKEL_LEFT_ELBOW);
            PVector leftShoulder = trackJoint(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER);

            float angle = getLimbAngle(leftHand, leftElbow, leftShoulder);

            if (angle > 80 && angle < 100){
                stroke(#ff0000);
                activeLimbs++;
            } else {
                stroke(#ffffff);
            }

            line(leftElbow.x, leftElbow.y, leftShoulder.x, leftShoulder.y);
            line(leftElbow.x, leftElbow.y, leftHand.x, leftHand.y);

            // RIGHT ARM
            PVector rightHand = trackJoint(userId, SimpleOpenNI.SKEL_RIGHT_HAND);
            PVector rightElbow = trackJoint(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW);
            PVector rightShoulder = trackJoint(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER);

            float angle2 = getLimbAngle(rightHand, rightElbow, rightShoulder);

            if (angle2 > 80 && angle2 < 100){
                stroke(#ff0000);
                activeLimbs++;
            } else {
                stroke(#ffffff);
            }

            line(rightElbow.x, rightElbow.y, rightShoulder.x, rightShoulder.y);
            line(rightElbow.x, rightElbow.y, rightHand.x, rightHand.y);

            // CHECK THE NUMBER OF LIMBS IN THE CORRECT POSITION
            if (activeLimbs == 2) {
                c = #ffff00;
            } else {
                c = #222222;
            }

            fill(#ffff00);
            textSize(50);
            text((int)angle + "   " + (int)angle2, 20, 40);
        }
    }
}

// RETURN ANGLE BETWEEN 2 CONNECTED LIMBS
float getLimbAngle(PVector startJoint, PVector middleJoint, PVector endJoint){
    // USE TEMPORARY PVectors BECAUSE WE WILL NEED TO SHIFT THE VALUES A BIT
    PVector tempStartJoint = new PVector();
    PVector tempEndJoint = new PVector();

    pushMatrix();
    translate(middleJoint.x, middleJoint.y); 
    tempStartJoint.set(startJoint.x-middleJoint.x, startJoint.y-middleJoint.y, 0);
    tempEndJoint.set(endJoint.x-middleJoint.x, endJoint.y-middleJoint.y, 0); 
    float limbAngle = degrees(PVector.angleBetween(tempStartJoint, tempEndJoint)); 
    popMatrix();
    return limbAngle;
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

