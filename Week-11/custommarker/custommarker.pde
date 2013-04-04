// USING CUSTOM MARKERS SAVED AS PNG FILES

import processing.video.*;
import jp.nyatla.nyar4psg.*;

Capture cam;
MultiMarker nya;
float yrot;

void setup() {
  size(640,480,P3D);
  colorMode(RGB, 100);
  println(MultiMarker.VERSION);
  cam=new Capture(this,640,480);
  nya=new MultiMarker(this,width,height,"camera_para.dat",NyAR4PsgConfig.CONFIG_PSG);
  //nya.addARMarker(loadImage("face.png"),16,25,80);
  nya.addARMarker("4x4_1.patt",80); // FROM patternMaker SET (http://www.cs.utah.edu/gdc/projects/augmentedreality/)
}

void draw()
{
  if (cam.available() !=true) {
      return;
  }
  cam.read();
  nya.detect(cam);
  background(0);
  nya.drawBackground(cam);

  if((!nya.isExistMarker(0))){
    return;
  }
  nya.beginTransform(0);
  fill(0,0,255);
  translate(0,0,20);
  rotateY(yrot);
  rotateX(yrot/5);
  box(20);
  nya.endTransform();

  yrot+=.05;
}
