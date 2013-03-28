import SimpleOpenNI.*;
SimpleOpenNI  kinect;
PImage fish;

void setup() {
    size(640, 480);
    kinect = new SimpleOpenNI(this);
    kinect.enableDepth(); // TURN ON DEPTH CAMERA
    kinect.enableRGB(); // TURN ON RGB CAMERA
    kinect.alternativeViewPointDepthToImage(); // MATCH UP RGB AND DEPTH IMAGES
    kinect.setMirror(true); // MAKE INTERACTION MORE NATURAL BY MIRRORING IMAGES
    kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL); // TURN ON USER TRACKING
    fish = loadImage("fish.png");
}

void draw() {
    kinect.update();
    PImage depth = kinect.depthImage();
    image(depth, 0, 0);
    IntVector userList = new IntVector(); // WILL HOLD INTS OF USERS
    kinect.getUsers(userList); // STORE THE LIST OF DETECTED USERS
    if (userList.size() > 0) { // ANY USERS? 
        int userId = userList.get(0); // GET THE FIRST ONE
        if (kinect.isTrackingSkeleton(userId)) { // CALIBRATED?
            PImage rgb = kinect.rgbImage(); // CREATE AN IMAGE OF THE INCOMING RGB DATA
            image(rgb, 0, 0); 
            PVector leftHand = new PVector(); // WILL HOLD LEFT HAND LOCATION
            kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, leftHand); // PUT POSITION INTO VECTOR
            PVector convertedLeftHand = new PVector();
            kinect.convertRealWorldToProjective(leftHand, convertedLeftHand); // CONVERT THE HAND POSITION TO "PROJECTIVE" COORDINATES THAT MATCH THE DEPTH IMAGE
            fill(255, 0, 0);
            //ellipse(convertedLeftHand.x, convertedLeftHand.y, 40, 40); // DRAW ELLIPSE

            PVector rightHand = new PVector(); // WILL HOLD LEFT HAND LOCATION
            kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, rightHand); // PUT POSITION INTO VECTOR
            PVector convertedRightHand = new PVector();
            kinect.convertRealWorldToProjective(rightHand, convertedRightHand);
            //ellipse(convertedRightHand.x, convertedRightHand.y, 40, 40); // DRAW ELLIPSE
            PVector v3 = PVector.sub(convertedRightHand, convertedLeftHand); // STORE THE DIFFERENCE BETWEEN THE VECTORS. THE ORDER MATTERS!

            pushMatrix();
            translate(convertedLeftHand.x, convertedLeftHand.y);
            stroke(0);
            rotate(v3.heading2D()); // GET HEADING DIRECTION FROM JOINT 1 TO JOINT 2 AND ROTATE IMAGE TO MATCH
            float distance2d = dist(convertedLeftHand.x, convertedLeftHand.y, convertedRightHand.x, convertedRightHand.y);
            image(fish, 0, -(87/2), distance2d, 87); // OFFSET Y TO CENTER IMAGE, MAKE WIDTH OF IMAGE THE 2D DISTANCE BETWEEN JOINTS
            /*
            // SCALE THE IMAGES IF YOU DON'T WANT A ELASTIC EFFECT
             float scaler = (dist(convertedLeftHand.x, convertedLeftHand.y, convertedRightHand.x, convertedRightHand.y)/294); // 294 is original width
             image(fish, 0, -60.5*scaler, 294*scaler, 121*scaler); // OFFSET Y TO CENTER IMAGE
             */
            popMatrix();
        }
    }
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

