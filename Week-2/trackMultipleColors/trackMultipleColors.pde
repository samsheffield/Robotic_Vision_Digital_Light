// Based on color tracking example from Daniel Shiffman's Learning Processing: 
// http://www.learningprocessing.com/examples/chapter-16/example-16-11/
// Multiple selectable colors. Hold key and click for 2nd color

import processing.video.*;
Capture cam;

color[] trackColors = new color[2];
PImage mirror;

int threshold = 60;

void setup() {
  size(320, 240);
  rectMode(CENTER);
  strokeWeight(4);
  stroke(0);
  cam = new Capture(this, width, height, 30);
  cam.start();
  mirror = createImage(width, height, RGB);
}

void draw() {
  if (cam.available()) {
    cam.read();
  }

  mirror.loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int currentPixel = (cam.width-x-1) + (y * cam.width);
      mirror.set(x,y,cam.pixels[currentPixel]);
    }
  }
  mirror.updatePixels();

  fastblur(mirror,10);
  image(mirror, 0, 0);

  float[] closestMatch = {500,500}; 

  int[] closestX = {0,0};
  int[] closestY = {0,0};

  for (int x = 0; x < mirror.width; x ++ ) {
    for (int y = 0; y < mirror.height; y ++ ) {
      int currentPixel = x + (y * mirror.width); 
      color currentColor = mirror.pixels[currentPixel]; 

      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);

      // COLOR 1
      float r2 = red(trackColors[0]);
      float g2 = green(trackColors[0]);
      float b2 = blue(trackColors[0]);

      // COLOR 2
      float rz2 = red(trackColors[1]);
      float gz2 = green(trackColors[1]);
      float bz2 = blue(trackColors[1]);

      float[] d = {dist(r1, g1, b1, r2, g2, b2), dist(r1, g1, b1, rz2, gz2, bz2)};


      for (int i = 0; i < closestMatch.length; i++){
        if (d[i] < closestMatch[i]) {
          closestMatch[i] = d[i];
          closestX[i] = x;
          closestY[i] = y;
        }
      }
    }
  }

  if (closestMatch[0] < threshold) { 
    fill(trackColors[0]);
    ellipse(closestX[0], closestY[0], 16, 16);
  }

    if (closestMatch[1] < threshold) { 
    fill(trackColors[1]);
    rect(closestX[1], closestY[1], 16, 16);
  }
}

void mousePressed() {
  int currentPixel = mouseX + mouseY*mirror.width; 
  if(keyPressed){
    trackColors[0] = mirror.pixels[currentPixel];
  } else {
    trackColors[1] = mirror.pixels[currentPixel];
  }

}

// ==================================================
// Super Fast Blur v1.1
// by Mario Klingemann 
// <http://incubator.quasimondo.com>
// ==================================================

void fastblur(PImage img,int radius)
{
 if (radius<1){
    return;
  }
  int w=img.width;
  int h=img.height;
  int wm=w-1;
  int hm=h-1;
  int wh=w*h;
  int div=radius+radius+1;
  int r[]=new int[wh];
  int g[]=new int[wh];
  int b[]=new int[wh];
  int rsum,gsum,bsum,x,y,i,p,p1,p2,yp,yi,yw;
  int vmin[] = new int[max(w,h)];
  int vmax[] = new int[max(w,h)];
  int[] pix=img.pixels;
  int dv[]=new int[256*div];
  for (i=0;i<256*div;i++){
    dv[i]=(i/div);
  }

  yw=yi=0;

  for (y=0;y<h;y++){
    rsum=gsum=bsum=0;
    for(i=-radius;i<=radius;i++){
      p=pix[yi+min(wm,max(i,0))];
      rsum+=(p & 0xff0000)>>16;
      gsum+=(p & 0x00ff00)>>8;
      bsum+= p & 0x0000ff;
    }
    for (x=0;x<w;x++){

      r[yi]=dv[rsum];
      g[yi]=dv[gsum];
      b[yi]=dv[bsum];

      if(y==0){
        vmin[x]=min(x+radius+1,wm);
        vmax[x]=max(x-radius,0);
      }
      p1=pix[yw+vmin[x]];
      p2=pix[yw+vmax[x]];

      rsum+=((p1 & 0xff0000)-(p2 & 0xff0000))>>16;
      gsum+=((p1 & 0x00ff00)-(p2 & 0x00ff00))>>8;
      bsum+= (p1 & 0x0000ff)-(p2 & 0x0000ff);
      yi++;
    }
    yw+=w;
  }

  for (x=0;x<w;x++){
    rsum=gsum=bsum=0;
    yp=-radius*w;
    for(i=-radius;i<=radius;i++){
      yi=max(0,yp)+x;
      rsum+=r[yi];
      gsum+=g[yi];
      bsum+=b[yi];
      yp+=w;
    }
    yi=x;
    for (y=0;y<h;y++){
      pix[yi]=0xff000000 | (dv[rsum]<<16) | (dv[gsum]<<8) | dv[bsum];
      if(x==0){
        vmin[y]=min(y+radius+1,hm)*w;
        vmax[y]=max(y-radius,0)*w;
      }
      p1=x+vmin[y];
      p2=x+vmax[y];

      rsum+=r[p1]-r[p2];
      gsum+=g[p1]-g[p2];
      bsum+=b[p1]-b[p2];

      yi+=w;
    }
  }
}