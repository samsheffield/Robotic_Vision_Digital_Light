// LIMITING RANGE OF MEASUREMENT AND COUNTING HOW MUCH IS THERE

import SimpleOpenNI.*;
SimpleOpenNI  kinect;
float closestValue = 914; // 3 FEET
float farthestValue = 1067; // 3 1/2 FEET

void setup() {
    size(640, 480);
    kinect = new SimpleOpenNI(this);
    kinect.enableDepth();
}

void draw() {
    int activePixels = 0; // RESET NUMBER OF ACTIVE PIXELS IN THE RANGE
    kinect.update();
    
    int[] depthValues = kinect.depthMap(); // GET REAL DEPTH VALUES
    
    PImage depthImage = kinect.depthImage();
    depthImage.loadPixels();
    // GO THROUGH EACH PIXEL IN EACH ROW
    for (int x = 0; x < 640; x++) {
        for (int y = 0; y < 480; y++) {
            int i = x + y * 640; // CONVERT THE X Y TO A FLAT VALUE
            int currentDepthValue = depthValues[i]; // GET CURRENT DEPTH AT THAT PIXEL
            if (currentDepthValue < closestValue || currentDepthValue > farthestValue) { // IF A PIXEL IS NOT WITHIN THE RANGE
                depthImage.pixels[i] = 0; // SET THOSE PIXELS BLACK
            }else{
                activePixels++; // OTHERWISE, COUNT IT
                // YOU COULD ALSO SET THE COLOR IF YOU LIKE... depthImage.pixels[i] = #FFFF00;
            }
        }
    }
    depthImage.updatePixels();
    
    image(depthImage, 0, 0); // SHOW THE MODIFIED IMAGE
    
    println("Active pixels in range: " + activePixels);
}

