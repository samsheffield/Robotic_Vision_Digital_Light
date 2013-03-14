import SimpleOpenNI.*;
SimpleOpenNI  kinect;

//PARTICLE STUFF
ArrayList<Particle> particles = new ArrayList();
boolean mouseMove;

PVector prevLeftHand = new PVector(0,0);
PVector prevRightHand = new PVector(0,0);

void setup() {
    size(640, 480);
    kinect = new SimpleOpenNI(this);
    kinect.enableDepth(); // TURN ON DEPTH CAMERA
    kinect.setMirror(true); // MAKE INTERACTION MORE NATURAL BY MIRRORING IMAGES
    kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL); // TURN ON USER TRACKING
    smooth();
}

void draw() {
    kinect.update();
    PImage depth = kinect.depthImage();
    //image(depth, 0, 0);
    IntVector userList = new IntVector(); // WILL HOLD INTS OF USERS
    kinect.getUsers(userList); // STORE THE LIST OF DETECTED USERS
    if (userList.size() > 0) { // ANY USERS? 
        int userId = userList.get(0); // GET THE FIRST ONE
        if (kinect.isTrackingSkeleton(userId)) { // CALIBRATED?
            PVector leftHand = new PVector();
            kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, leftHand); 
            PVector convertedLeftHand = new PVector();
            kinect.convertRealWorldToProjective(leftHand, convertedLeftHand); 

            PVector rightHand = new PVector();
            kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, rightHand); 
            PVector convertedRightHand = new PVector();
            kinect.convertRealWorldToProjective(rightHand, convertedRightHand); 
            
            //PARTICLE STUFF
            particles.add(new Particle(convertedLeftHand, prevLeftHand));
            particles.add(new Particle(convertedLeftHand, prevLeftHand, 5));
            particles.add(new Particle(convertedLeftHand, prevLeftHand, 15));

            particles.add(new Particle(convertedRightHand, prevRightHand));
            particles.add(new Particle(convertedRightHand, prevRightHand, 5));
            particles.add(new Particle(convertedRightHand, prevRightHand, 15));
            
            prevLeftHand = convertedLeftHand;
            prevRightHand = convertedRightHand;

            noStroke();
            fill(0, 20);
            rect(0,0,width,height);
            //noFill();
            for (int i=0; i< particles.size();i++) {
                Particle p = particles.get(i);
                p.display(); 
            }
            for (int i=0; i< particles.size();i++) {
                Particle p = particles.get(i);
                if (p.finished()) {
                    particles.remove(i);
                }   
            }
        }
    }
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