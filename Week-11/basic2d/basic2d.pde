// WORKING WITH 2D IMAGES

import processing.video.*;
import jp.nyatla.nyar4psg.*;

Capture cam;
MultiMarker nya;
float yrot, xrot;
PImage coin;

void setup() {
  size(640,480,P3D);
  colorMode(RGB, 100);
  println(MultiMarker.VERSION);
  cam=new Capture(this,640,480);
  nya=new MultiMarker(this,width,height,"camera_para.dat",NyAR4PsgConfig.CONFIG_PSG);
  nya.addARMarker("patt.kanji",80);
  nya.setLostDelay(1); // set delay to a very small number 
  coin = loadImage("coin.png");
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
  translate(0,0,0);
  imageMode(CENTER);
  image(coin, 0,0);

  //PUSH IT UP
  translate(0,0,25);
  rotateY(yrot);
  rotateX(xrot);
  image(coin, 0,0);
  imageMode(CORNER);
  nya.endTransform();
  yrot+=.045;
  xrot+=.055;
}
