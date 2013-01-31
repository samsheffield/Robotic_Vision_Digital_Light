// Based on Brightness Thresholding example by Golan Levin. 

import processing.video.*;

int numPixels;
Capture cam;
PImage mirror;
int threshold = 0;

void setup() {
  size(640, 480);
  strokeWeight(5);
  // Uses the default video input, see the reference if this causes an error
  cam = new Capture(this, width, height, 30);
  cam.start();  

  mirror = createImage(width, height, RGB);

  numPixels = cam.width * cam.height;
  noCursor();
  smooth();
}

void draw() {
  if (cam.available()) {
    cam.read();
    cam.loadPixels();
    float pixelBrightness; // Declare variable to store a pixel's color

    // reverse x & reduce image to black & white
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        int currentPixel = (cam.width-x-1) + (y * cam.width); // reverse
        pixelBrightness = brightness(cam.pixels[currentPixel]);

        // reduce image to black and white
        if (pixelBrightness > threshold) { 
          cam.pixels[currentPixel] = color(255); 
        } 
        else {
          cam.pixels[currentPixel] = color(0); 
        }
        mirror.set(x, y, cam.pixels[currentPixel]);
      }
    }
    cam.updatePixels();
    image(mirror, 0, 0);

    // compare for intersection
    int testValue = get(mouseX, mouseY); // point to compare brightness with
    float testBrightness = brightness(testValue); // how bright is this point?

    if (testBrightness > threshold) { // If the test location is brighter than
      fill(0); 
    } 
    else { // Otherwise, do this...
      fill(255); 
    }
    ellipse(mouseX, mouseY, 20, 20);
  }

  showThreshold();
}

void showThreshold(){
  fill(255,0,0);
  textSize(20);
  text(threshold, 10, 30);
}

void keyPressed(){
  if(keyCode == UP) threshold++;
  if (keyCode == DOWN && threshold > 0) threshold--;
}