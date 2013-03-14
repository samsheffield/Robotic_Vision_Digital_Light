import SimpleOpenNI.*;
SimpleOpenNI  kinect;
PVector lastRightHand;

void setup() {
    size(640, 480);
    kinect = new SimpleOpenNI(this);
    kinect.enableDepth(); 
    kinect.setMirror(true); 
    kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL); 
    lastRightHand = new PVector();
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
            noStroke();
            fill(0,180);
            rect(0,0,width, height);

            PVector rightHand = trackJoint(userId, SimpleOpenNI.SKEL_RIGHT_HAND); 

            stroke(#ff2200);
            fill(#ff2200, 100);
            ellipse(rightHand.x, rightHand.y, 5, 5);
            line(rightHand.x, rightHand.y, lastRightHand.x, lastRightHand.y);

            // GET AVERAGE VELOCITY
            float averageJointVelocity = PVector.dist(rightHand, lastRightHand);
            // GET SINGLE AXIS VELOCITY
            float xJointVelocity = rightHand.x-lastRightHand.x;
            float yJointVelocity = rightHand.y-lastRightHand.y;
            float zJointVelocity = rightHand.z-lastRightHand.z;


            // GETTING DIRECTION
            String xDirection;
            float xThreshold = 3;

            if(xJointVelocity > xThreshold){
                xDirection = "RIGHT";
            } else if(xJointVelocity < -xThreshold){
                xDirection = "LEFT";
            } else {
                xDirection = "STILL";
            }

            println("AVG: " + nfs(averageJointVelocity, 3, 2) + "    X: " + nfs(xJointVelocity, 3, 2) + "    Y: " + nfs(yJointVelocity, 3, 2) + "    Z: " + nfs(zJointVelocity, 3, 2) + "    X DIR: " + xDirection);

            lastRightHand = rightHand.get(); // STORE THIS SET OF COORDINATES
        }
    }
}



PVector trackJoint(int userId, int jointID) { //
    PVector joint = new PVector();
    kinect.getJointPositionSkeleton(userId, jointID, joint);
    PVector convertedJoint = new PVector(); // WILL HOLD JOINT POSITION
    kinect.convertRealWorldToProjective(joint, convertedJoint); // CONVERT THE HAND POSITION TO "PROJECTIVE" COORDINATES THAT MATCH THE DEPTH IMAGE
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

