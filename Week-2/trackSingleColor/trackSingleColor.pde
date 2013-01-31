// Based on color tracking example from Daniel Shiffman's Learning Processing: 
// http://www.learningprocessing.com/examples/chapter-16/example-16-11/

import processing.video.*;
Capture cam;

PImage mirror;
color trackColor; // which color to track
int prevX, prevY;
int threshold = 60; // how close does the matched color need to be.

boolean blurred;
int blurAmount;

void setup() {
  size(320, 240);
  mirror = createImage(width, height, RGB);
  cam = new Capture(this, width, height, 15);
  cam.start();
}

void draw() {
  if (cam.available()) {
    cam.read();
  }

  // Mirror image
  cam.loadPixels();
  mirror.loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int currentPixel = (cam.width-x-1) + (y * cam.width);
      mirror.set(x,y,cam.pixels[currentPixel]);
    }
  }
  mirror.updatePixels();

  // toggle blur & draw mirrored image
  if (blurred) {
    fastblur(mirror,blurAmount);
  }
  image(mirror, 0, 0);

  // Before we begin searching, set the closestMatch to a high number that is easy for the first pixel to beat.
  float closestMatch = 500; 

  // will hold the x & y coordinates of closest color
  int closestX = 0;
  int closestY = 0;

  // Go through all pixels and find closest match to tracked color.
  for (int x = 0; x < mirror.width; x ++ ) {
    for (int y = 0; y < mirror.height; y ++ ) {
      int currentPixel = x + y*mirror.width;
      
      // What is current color?
      color currentColor = mirror.pixels[currentPixel];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      float d = dist(r1, g1, b1, r2, g2, b2); // How different is the color?

      // If current color is more similar to tracked color than previous closest color, save current location and difference.
      if (d < closestMatch) {
        closestMatch = d;
        closestX = x;
        closestY = y;
      }
    }
  }

  // We only consider the color found if its color distance is less than threshold. 
  if (closestMatch < threshold) { 
    // Draw a circle at the tracked pixel
    fill(trackColor);
    strokeWeight(4.0);
    stroke(0);

    // smooth current location by getting midpoints
    float currentX = lerp(closestX, prevX, 0.5);
    float currentY = lerp(closestY, prevY, 0.5);
    ellipse(closestX, closestY, 16, 16);
  }

  prevX = closestX;
  prevY = closestY;
  
  if (blurred) showBlurAmount();
}

void mousePressed() {
  // Save color where the mouse is clicked in trackColor variable
  int currentPixel = mouseX + mouseY*mirror.width;
  trackColor = mirror.pixels[currentPixel];
}

void keyReleased() {
  if(key=='b') blurred = !blurred;
  if(key=='=' || key=='+') blurAmount++;
  if((key=='-' || key=='_') && blurAmount > 0) blurAmount--;
}

void showBlurAmount(){
  fill(255);
  textSize(20);
  text(blurAmount, 10, 30);
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

