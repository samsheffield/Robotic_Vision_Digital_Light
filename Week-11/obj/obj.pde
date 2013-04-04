// IMPORTED 3D MODELS USING OBJLoader LIBRARY (https://code.google.com/p/saitoobjloader/). USE VERSION 23, NOT 23b!
import processing.video.*;
import jp.nyatla.nyar4psg.*;

import saito.objloader.*;

OBJModel model ;

Capture cam;
MultiMarker nya;

void setup() {
  size(640,480,P3D);
  colorMode(RGB, 100);
  println(MultiMarker.VERSION);
  cam=new Capture(this,640,480);
  nya=new MultiMarker(this,width,height,"camera_para.dat",NyAR4PsgConfig.CONFIG_PSG);
  nya.addARMarker("patt.hiro",80);
  model = new OBJModel(this, "fire.obj", "absolute", POLYGON);
  //model.scale(2); // MODELS OFTEN NEED TO BE SCALED
  model.translateToCenter();
  noStroke();
}

void draw(){
  if (cam.available() !=true) {
      return;
  }

  cam.read();
  nya.detect(cam);
  background(0);
  nya.drawBackground(cam); // // SHOW CAMERA BACKGROUND, A DIFFERENT BACKGROUND... OR NONE!

  if((!nya.isExistMarker(0))){
    return;
  }
  lights();
  nya.beginTransform(0);
  translate(0,0,40);
  rotateX(radians(-90));
  model.draw();
  nya.endTransform();
}
