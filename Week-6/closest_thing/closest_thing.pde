// TRACKING CLOSEST POINT (WITHIN RANGE)

import SimpleOpenNI.*;
SimpleOpenNI kinect;

int closestValue; 
int closestX;
int closestY;

void setup() {
    size(640, 480);
    kinect = new SimpleOpenNI(this);
    kinect.enableDepth();
    kinect.setMirror(true);
}
void draw() {
    closestValue = 8000; // RESET THE DISTANCE TO SOMETHING FAR AWAY
    kinect.update();
    
    int[] depthValues = kinect.depthMap(); // GET REAL DEPTH VALUES

    // GO THROUGH EACH PIXEL IN EACH ROW
    for (int x = 0; x < 640; x++) {
        for (int y = 0; y < 480; y++) { 
            int i = x + y * 640; // CONVERT THE X Y FROM 2D TO 1D
            int currentDepthValue = depthValues[i]; // GET CURRENT DEPTH AT THAT PIXEL
            if (currentDepthValue > 0 && currentDepthValue < closestValue) { 
                closestValue = currentDepthValue; // IF IT IS CLOSEST THING, SAVE IT
                closestX = x;
                closestY = y;
            }
        }
    }
    
    PImage depthImage = kinect.depthImage(); 
    image(depthImage, 0, 0);
    
    fill(255, 0, 0);
    ellipse(closestX, closestY, 20, 20);
}