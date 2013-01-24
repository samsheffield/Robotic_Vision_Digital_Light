import processing.video.*;

Capture cam;
PImage mirror; // store our mirrored image here!
float r;

void setup() {
  size(640, 480);
  mirror = createImage(width, height, RGB); // initializing a holder for our mirror image
  cam = new Capture(this, width, height, 30);
  cam.start();
}


void draw() {
background(0);
  if (cam.available() == true) {
    cam.read();
  }
  
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int currentPixel = (cam.width-x-1) + (y * cam.width); // THIS WILL REVERSE X
      mirror.set(x, y, cam.pixels[currentPixel]);
    }
  }
  image(mirror, 0, 0);
  /*tint(255,0,0); // now we can do this kind of fun stuff!
  pushMatrix();
  translate(width/2, height/2);
  imageMode(CENTER);
  rotate(r);
  image(mirror, 0, 0, 320, 240);
  popMatrix();
  r+= .025;*/
}

