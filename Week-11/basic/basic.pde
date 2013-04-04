// VERY BASIC EXAMPLE!
import processing.video.*;
import jp.nyatla.nyar4psg.*;

Capture cam;
MultiMarker nya;
PImage bg;

void setup() {
  size(640,480,P3D);
  colorMode(RGB, 100);
  println(MultiMarker.VERSION);
  cam=new Capture(this,640,480);
  nya=new MultiMarker(this,width,height,"camera_para.dat",NyAR4PsgConfig.CONFIG_PSG);
  nya.addARMarker("patt.hiro",80);
  bg = loadImage("room.png");
}

void draw(){
  if (cam.available() !=true) {
      return;
  }
  lights();
  fill(70,70,255);

  cam.read();
  nya.detect(cam);
  background(0);
  nya.drawBackground(cam); // // SHOW CAMERA BACKGROUND, A DIFFERENT BACKGROUND... OR NONE!

  if((!nya.isExistMarker(0))){
    return;
  }

  nya.beginTransform(0);
  translate(0,0,20);
  box(40);
  nya.endTransform();
}
