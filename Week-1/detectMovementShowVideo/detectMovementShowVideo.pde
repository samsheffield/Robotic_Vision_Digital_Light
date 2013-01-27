// Based on Learning Processing Example 16-13: Simple motion detection by Daniel Shiffman
// Mirrored motion detection (show video)

import processing.video.*;
Capture cam;
PImage prevFrame; // image for holding our previous frame
PImage mirror;

void setup() {
  size(640, 480);
  cam = new Capture(this, width, height, 30);
  cam.start();

  prevFrame = createImage(cam.width, cam.height, RGB); // same size as capture
  mirror = createImage(cam.width, cam.height, RGB);
}

void draw() {
  float totalPixelsChanged = 0.0; // store and reset amount of change

  if (cam.available()) {
    // Save previous frame before reading from the camera
    prevFrame.copy(mirror, 0, 0, mirror.width, mirror.height, 0, 0, mirror.width, mirror.height); // Before we read the new frame, we always save the previous frame for comparison!
    prevFrame.updatePixels();
    cam.read();
  }

  cam.loadPixels(); // you don't need a corresponding updatePixels() if you are just reading
  prevFrame.loadPixels(); // ditto

  // Go through all pixels
  for (int x = 0; x < cam.width; x ++ ) {
    for (int y = 0; y < cam.height; y ++ ) {

      int currentPixel = (cam.width - x - 1) + y*cam.width;
      mirror.set(x, y, cam.pixels[currentPixel]);

      // get colors of pixels in both frames
      color current = mirror.pixels[currentPixel];      
      color previous = prevFrame.pixels[currentPixel]; 

      // compare colors
      float r1 = red(current); 
      float g1 = green(current); 
      float b1 = blue(current);
      float r2 = red(previous); 
      float g2 = green(previous); 
      float b2 = blue(previous);
      float diff = dist(r1, g1, b1, r2, g2, b2);

      totalPixelsChanged += diff;
    }
  }
  totalPixelsChanged = totalPixelsChanged/mirror.pixels.length; // make percentage
  image(mirror, 0, 0); // draw mirrored video

  fill(255,0,0);
  text(totalPixelsChanged, 20,20); // show percentage

}

