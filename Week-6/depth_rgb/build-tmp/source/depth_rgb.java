import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import SimpleOpenNI.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class depth_rgb extends PApplet {


SimpleOpenNI kinect;

public void setup() {
  kinect = new SimpleOpenNI(this); // INSTANTIATE A SIMPLEOPENNI OBJECTIN THIS NAMESPACE
  kinect.enableDepth(); // TURN ON DEPTH CAMERA
  kinect.enableRGB(); // TURN ON RGB CAMERA
  kinect.alternativeViewPointDepthToImage(); // MATCH UP RGB AND DEPTH IMAGES
  kinect.setMirror(true); // MAKE INTERACTION MORE NATURAL BY MIRRORING IMAGES
  size(640*2, 480);
}

public void draw() {
  kinect.update(); // GET DATA FROM KINECT
    rotateX(-.5f);
  rotateY(-.5f);
  PImage depth = kinect.depthImage(); // CREATE AN IMAGE OBJECT OF THE INCOMING DEPTH DATA
  image(depth, 0, 0);
  PImage rgb = kinect.rgbImage(); // CREATE AN IMAGE OF THE INCOMING RGB DATA
  image(rgb,640, 0); // SET THE RGB IMAGE BESIDE THE DEPTH IMAGE IN THE WINDOW
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#000000", "--hide-stop", "depth_rgb" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
