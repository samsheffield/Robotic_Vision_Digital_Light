// GET ANGLE OF TWO CONNECTED LIMBS

import SimpleOpenNI.*;
SimpleOpenNI  kinect;

float angle;

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
            PVector leftShoulder = trackJoint(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER);

            background(255);
            fill(0);
            line(leftElbow.x, leftElbow.y, leftShoulder.x, leftShoulder.y);
            line(leftElbow.x, leftElbow.y, leftHand.x, leftHand.y);
            ellipse(leftShoulder.x, leftShoulder.y, 10, 10);
            ellipse(leftHand.x, leftHand.y, 10, 10);

            pushMatrix(); // KEEP THIS STUFF PRIVATE
            translate(leftElbow.x, leftElbow.y); // MOVE POINT OF ORIGIN TO MIDDLE JOINT
            leftHand.set(leftHand.x-leftElbow.x, leftHand.y-leftElbow.y, 0); // OFFSET COORDINATES RELATIVE TO MIDDLE JOINT
            leftShoulder.set(leftShoulder.x-leftElbow.x, leftShoulder.y-leftElbow.y, 0); // WE'RE NOT USING sub() BECAUSE IT WILL ALSO SUBTRACT Z POSITIONS. WE ONLY WANT 2D.
            angle = PVector.angleBetween(leftHand, leftShoulder); // CALCULATE ANGLE
            popMatrix();

            fill(255,0,0);
            textSize(80);
            text((int)degrees(angle), 20, 70);
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

