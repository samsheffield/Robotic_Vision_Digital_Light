
// Based on Mirror 2 by Daniel Shiffman. 

import processing.video.*;

int cellSize = 15;
int cols, rows;

Capture cam;


void setup() {
  size(640, 480);
  cols = width / cellSize;
  rows = height / cellSize;
  rectMode(CENTER);

  // Uses the default cam input, see the reference if this causes an error
  cam = new Capture(this, width, height);
  cam.start();

  background(0);
}


void draw() { 
  if (cam.available()) {
    cam.read();
    cam.loadPixels();

    background(0);

    // Begin loop for columns
    for (int i = 0; i < cols;i++) {
      // Begin loop for rows
      for (int j = 0; j < rows;j++) {

        // Where are we, pixel-wise?
        int x = i * cellSize;
        int y = j * cellSize;
        int loc = (cam.width - x - 1) + y*cam.width; // Reversing x to mirror the image
        color c = cam.pixels[loc];
        
        float sz = (brightness(c) / 255.0) * cellSize;
        
        noStroke();
        fill(c);

        pushMatrix();
        translate(x, y);
        rect(0, 0, sz, sz);
        popMatrix();
        
      }
    }
  }
}

