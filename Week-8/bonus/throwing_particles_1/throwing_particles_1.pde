import SimpleOpenNI.*;
SimpleOpenNI  kinect;

//PARTICLE STUFF
ArrayList<Particle> particles = new ArrayList();
boolean mouseMove;
PVector v1 = new PVector(0,0);
PVector v2 = new PVector(0,0);
PVector v3 = new PVector(0,0);

PVector prevLeftHand = new PVector(0,0);

void setup() {
    size(640, 480);
    kinect = new SimpleOpenNI(this);
    kinect.enableDepth(); // TURN ON DEPTH CAMERA
    kinect.setMirror(true); // MAKE INTERACTION MORE NATURAL BY MIRRORING IMAGES
    kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL); // TURN ON USER TRACKING
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
            PVector leftHand = new PVector(); // WILL HOLD LEFT HAND LOCATION
            kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, leftHand); // PUT POSITION INTO VECTOR
            PVector convertedLeftHand = new PVector();
            kinect.convertRealWorldToProjective(leftHand, convertedLeftHand); // CONVERT THE HAND POSITION TO "PROJECTIVE" COORDINATES THAT MATCH THE DEPTH IMAGE
            

            //PARTICLE STUFF
            v1 = new PVector(prevLeftHand.x, prevLeftHand.y); // ANCHOR FOR ANGLE
            v2 = new PVector(convertedLeftHand.x, convertedLeftHand.y); // MOVING TOWARDS THIS POINT
            v3 = PVector.sub(v2, v1); // STORE THE DIFFERENCE BETWEEN THE VECTORS. THE ORDER MATTERS!
            particles.add(new Particle(convertedLeftHand.x, convertedLeftHand.y, 0, 0, -degrees(v3.heading2D()), dist(v1.x, v1.y, v2.x, v2.y)*.25+.1));
            particles.add(new Particle(convertedLeftHand.x, convertedLeftHand.y, 0, 0, -degrees(v3.heading2D())+random(-5,5), dist(v1.x, v1.y, v2.x, v2.y)*.25+.1));
            particles.add(new Particle(convertedLeftHand.x, convertedLeftHand.y, 0, 0, -degrees(v3.heading2D())+random(-15,15), dist(v1.x, v1.y, v2.x, v2.y)*.25+.1));
            
            prevLeftHand = convertedLeftHand;

            noStroke();
            fill(0, 125);
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

            stroke(#D65600);
            line(v1.x, v1.y, v2.x, v2.y);

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