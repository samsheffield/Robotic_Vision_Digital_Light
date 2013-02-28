// TRACKING SOMETHING IN RANGE. 

import SimpleOpenNI.*;
SimpleOpenNI  kinect;
float closestValue = 700; 
float farthestValue = 750; 
float threshold = 8000;

void setup() {
    size(640, 480);
    kinect = new SimpleOpenNI(this);
    kinect.enableDepth();
    kinect.setMirror(true);
}

void draw() {
    int activePixels = 0;
    float sumX = 0;
    float sumY = 0;

    kinect.update();
    int[] depthValues = kinect.depthMap(); // GET REAL DEPTH VALUES
    
    PImage depthImage = kinect.depthImage();
    depthImage.loadPixels();

    for (int x = 0; x < 640; x++) {
        for (int y = 0; y < 480; y++) {
            int i = x + y * 640;
            int currentDepthValue = depthValues[i];
            if (currentDepthValue < closestValue || currentDepthValue > farthestValue) { 
                depthImage.pixels[i] = 0;
            }else{
                // COUNT ALL PIXELS WHICH ARE IN RANGE
                sumX += x;
                sumY += y;
                activePixels++;
            }
        }
    }
    depthImage.updatePixels();
    image(depthImage, 0, 0);
    
    // FIND THE MIDDLE OF THE "BLOB"
    float averagedX = sumX/activePixels;
    float averagedY = sumY/activePixels;
    if (activePixels > threshold) ellipse(averagedX, averagedY, 20, 20); // ONLY DRAW CIRCLE IF THE BLOB IS BIGGER THAN A SET AMOUNT
}

