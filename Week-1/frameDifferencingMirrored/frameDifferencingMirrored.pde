/* Based on Learning Processing Example 16-13: Simple motion detection by Daniel Shiffman
   Mirrored motion detection with frame differencing. Show changed pixels.
   This fixes the "half of screen" issue in the original example by drawing changed pixels to the display pixels[], then going through the updated pixels[] and reversing them to draw to screen.
*/

import processing.video.*;
Capture cam;
PImage prevFrame; // image for holding our previous frame

float threshold = 50; // How different must a pixel be to be a "motion" pixel

void setup() {
  size(640, 480);
  cam = new Capture(this, width, height, 30);
  cam.start();

  prevFrame = createImage(cam.width, cam.height, RGB); // same size as capture
}

void draw() {

  if (cam.available()) {
    // Save previous frame before reading from the camera
    prevFrame.loadPixels();
    prevFrame.copy(cam, 0, 0, cam.width, cam.height, 0, 0, cam.width, cam.height); // Before we read the new frame, we always save the previous frame for comparison!
    prevFrame.updatePixels();
    cam.read();
  }

  loadPixels();
  cam.loadPixels(); // you don't need a corresponding updatePixels() if you are just reading
  prevFrame.loadPixels(); // ditto

  // Go through all pixels and see what has changed
  for (int x = 0; x < cam.width; x ++ ) {
    for (int y = 0; y < cam.height; y ++ ) {

      //int currentPixel = (cam.width - x - 1) + y*cam.width;
      int currentPixel = x + (y * cam.width);

      // get colors of pixels in both frames
      color current = cam.pixels[currentPixel];      
      color previous = prevFrame.pixels[currentPixel]; 

      // compare colors
      float r1 = red(current); 
      float g1 = green(current); 
      float b1 = blue(current);
      float r2 = red(previous); 
      float g2 = green(previous); 
      float b2 = blue(previous);
      float diff = dist(r1, g1, b1, r2, g2, b2);

      if (diff > threshold){
        pixels[currentPixel] = color(0);
      }else{
        pixels[currentPixel] = color(255);
      }
    }
  }
  updatePixels(); // save changes to display's pixels

  // mirror the output!
  loadPixels(); // not updating pixels[] so we don't need to have a matching updatePixels()
  for (int x = 0; x < width; x ++ ) {
    for (int y = 0; y < height; y ++ ) {
      int currentPixel = (width - x - 1) + y*width;
      set(x,y,pixels[currentPixel]);
    }
  }

}

