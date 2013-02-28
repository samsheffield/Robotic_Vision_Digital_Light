// VIRTUAL BUTTON. 

Button b1;

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
    b1 = new Button(50, 50, 100, 100);
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
                sumX += x;
                sumY += y;
                activePixels++;
            }
        }
    }
    depthImage.updatePixels();
    image(depthImage, 0, 0);
    
    float averagedX = sumX/activePixels;
    float averagedY = sumY/activePixels;

    stroke(#ff0000);
    fill(#ffffff);
    if (activePixels > threshold) ellipse(averagedX, averagedY, 20, 20);

    // ARE WE HITTING THE BUTTON?
    if(b1.hit(averagedX, averagedY)){
        println("do something");
    }
    b1.draw();
}

