import processing.video.*;

Capture cam;

void setup() {
  size(640, 480);
  cam = new Capture(this, width, height, 30);
  cam.start();
}


void draw() {

  if (cam.available() == true) {
    cam.read();
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        int currentPixel = (cam.width-x-1) + (y * cam.width); // THIS WILL REVERSE X
        set(x, y, cam.pixels[currentPixel]); // draws the pixels to the screen
      }
    }
  }
}

