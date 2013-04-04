// GETTING RELATIVE DISTANCE BETWEEN 2 MARKERS

import processing.video.*;
import jp.nyatla.nyar4psg.*;

Capture cam;
MultiMarker nya;
int totalMarkers = 2;

PVector[] middle = new PVector[totalMarkers];


void setup() {
  size(640,480,P3D);
  colorMode(RGB, 100);
  println(MultiMarker.VERSION);  
  cam=new Capture(this,640,480);
  nya=new MultiMarker(this,width,height,"camera_para.dat",NyAR4PsgConfig.CONFIG_PSG);
  nya.addARMarker("patt.hiro",80);//id=0
  nya.addARMarker("patt.kanji",80);//id=1
  nya.setLostDelay(1); // set delay to a very small number 
  stroke(#0000ff);
  fill(#0000ff);

  for(int i=0; i < middle.length; i++){
    middle[i] = new PVector(0,0);
  }
}

void draw(){
  if (cam.available() !=true) {
      return;
  }
  cam.read();
  nya.detect(cam);
  background(0);
  nya.drawBackground(cam);

  int activeMarkers = 0;
  for(int i=0; i < middle.length; i++){
    if((nya.isExistMarker(i))){
      nya.beginTransform(i);
      translate(0,0,20);
      nya.endTransform();
      middle[i] = getScreenMidPoint(i);
      activeMarkers++;
    }
  }

  
  ellipse(middle[0].x, middle[0].y, 10,10);
  ellipse(middle[1].x, middle[1].y, 10,10);

  if(activeMarkers == totalMarkers){
    line(middle[0].x, middle[0].y, middle[1].x, middle[1].y);
    textSize(16);
    text (dist(middle[0].x, middle[0].y, middle[1].x, middle[1].y), 20, 20);
  }

}

// Just getting the diagonal and dividing in half to get a quick and dirty, measurable midpoint
PVector getScreenMidPoint(int markerId){
  PVector[] v = nya.getMarkerVertex2D(markerId);
  PVector mid = PVector.add(v[0], v[2]);
  mid.div(2); 
  return mid;
}
