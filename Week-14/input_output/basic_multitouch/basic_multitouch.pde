// BASIC MULTITOUCH FUNCTIONALITY
// BASED ON multiTouchCore.pde BY Eric Pavey - 2011-01-02
import android.view.MotionEvent;

float pressureSize;

int maxTouchEvents = 5;
MultiTouch[] mt; // HOLD MULTITOUCH DATA     

boolean[] reset = {true, true, true, true, true};

color[] c = {#ffcc66, #ff6766, #9359a6, #6d9e76, #526ec2};

void setup() {
  orientation(PORTRAIT);
  smooth();
  stroke(110);
  background(255);

  // CREATE MULTITOUCH ARRAY
  mt = new MultiTouch[maxTouchEvents];
  for(int i=0; i < maxTouchEvents; i++) {
    mt[i] = new MultiTouch();
  }
}

void draw() {
  background(255);
  if (mousePressed == true) {
    for(int i=0; i < maxTouchEvents; i++) { // CHECK FOR MULTITOUCH WHEN SCREEN IS PRESSED
      if(mt[i].touched == true) { // IF THERE IS A TOUCH...
        reset[i] = false;
        
        // SO MANY SCREEN SIZES, SO LET'S MAP THE X, Y RANGES TO RELATIVE (PREDICTABLE) VALUES
        int adjustedX = (int)map(mt[i].motionX, 0, displayWidth, 0, 255);
        int adjustedY = (int)map(mt[i].motionY, 0, displayHeight, 0, 255);

        pressureSize = 120 + (mt[i].size * 90);
        fill(100);
        textSize(30);
        textAlign(CENTER);
        text(i+1, mt[i].motionX, mt[i].motionY - pressureSize/2 - 20);

        textAlign(LEFT);
        textSize(20);
        text(mt[i].size, mt[i].motionX - pressureSize, mt[i].motionY);
        fill(c[i]);
        strokeWeight(10);
        ellipse(mt[i].motionX, mt[i].motionY, pressureSize, pressureSize);
      }else{
        if(!reset[i]){ // RESET TOUCH 1-4 TO 0 WHEN NO LONGER PRESSED
          reset[i] = true;
        }
      }
    }
  }else{
    if(!reset[0]){ // NEEDED TO RESET TOUCH 0 WHEN NOT PRESSED
      reset[0] = true;
    }
  }
}  


// OVERRIDE surfaceTouchEvent TO GRAB MULTITOUCH DATA FROM ANDROID
boolean surfaceTouchEvent(MotionEvent me) {
  int pointers = me.getPointerCount(); // HOW MANY TOUCH POINTS

  for(int i=0; i < maxTouchEvents; i++) { // RESET ALL TOUCHES
    mt[i].touched = false;
  }

  for(int i=0; i < maxTouchEvents; i++) { 
    if(i < pointers) {
      mt[i].update(me, i); // UPDATE TOUCHES
    }
    else {
      mt[i].update(); // UPDATE NON-TOUCHES
    }
  }
  return super.surfaceTouchEvent(me);
}


