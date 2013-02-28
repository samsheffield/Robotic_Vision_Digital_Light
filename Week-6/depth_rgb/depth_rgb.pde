import SimpleOpenNI.*;
SimpleOpenNI kinect;

void setup() {
  kinect = new SimpleOpenNI(this); // INSTANTIATE A SIMPLEOPENNI OBJECTIN THIS NAMESPACE
  kinect.enableDepth(); // TURN ON DEPTH CAMERA
  kinect.enableRGB(); // TURN ON RGB CAMERA
  kinect.alternativeViewPointDepthToImage(); // MATCH UP RGB AND DEPTH IMAGES
  kinect.setMirror(true); // MAKE INTERACTION MORE NATURAL BY MIRRORING IMAGES
  size(640*2, 480);
}

void draw() {
  kinect.update(); // GET DATA FROM KINECT
    
  PImage depth = kinect.depthImage(); // CREATE AN IMAGE OBJECT OF THE INCOMING DEPTH DATA
  image(depth, 0, 0);
  PImage rgb = kinect.rgbImage(); // CREATE AN IMAGE OF THE INCOMING RGB DATA
  image(rgb,640, 0); // SET THE RGB IMAGE BESIDE THE DEPTH IMAGE IN THE WINDOW
}
