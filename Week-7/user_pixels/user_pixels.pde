import SimpleOpenNI.*;
SimpleOpenNI  kinect;

int[] userMap; // FOR HOLDING USER PIXELS
PImage rgbImage;

void setup() {
    size(640, 480);
    kinect = new SimpleOpenNI(this);
    kinect.setMirror(true);
    kinect.enableDepth();
    kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_NONE); // WE'RE LOOKING FOR USERS BUT DON'T NEED SKELETAL INFO
}
void draw() {
    kinect.update();
    PImage depthImage = kinect.depthImage();
    if (kinect.getNumberOfUsers() > 0) { // IF THERE ARE ANY USERS
        userMap = kinect.getUsersPixels(SimpleOpenNI.USERS_ALL); //  STORE THEIR PIXELS

        depthImage.loadPixels();
        for (int i = 0; i < userMap.length; i++) { // LOOP THROUGH THE PIXELS IN userMap
            if (userMap[i] != 0) { // IF THE PIXEL BELONGS TO A USER
                depthImage.pixels[i] = color(255, 255, 0); // MAKE THE PIXELS YELLOW
            }
        }
        depthImage.updatePixels();
    }
    image(depthImage, 0, 0);
}


