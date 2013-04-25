// SKETCH DEMONSTRATING A FEW BASIC DIFFERENCES BETWEEN JAVA AND ANDROID MODES

float x, y;
boolean started;
PFont font;

void setup() {
  // Use displayWidth and displayHeight instead of height and width
  x = displayWidth/2;
  y = displayHeight/2;
  // Do not set size() unless you want to use P3D. Even then, use displayWidth, displayHeight as arguments.
  // Use orientation if you want to fix the orientation: PORTRAIT (hamburger), LANDSCAPE (hotdog).
  // If you don't fix orientation, it will rotate with the device.
  orientation(PORTRAIT);
  font = createFont("SansSerif", 30); // Use createFont() instead of loadFont() in Android
  textSize(30);
  textAlign(CENTER,CENTER);
}

void draw() {
  fill(0, 50);
  rect(0, 0, displayWidth, displayHeight);
  
  // The mouseX and mouseY variables can be used to track touches
  if (started) { // only reposition ellipse if mouse has been pressed
    x = mouseX;
    y = mouseY;
  }
  
  // Mouse related functions work too!
  if (mousePressed) {
    fill(#ff0000);
    // trigger start variable if it hasn't been set already
    if(!started){
      started = true;
    }
  } else {
    fill(#ffff00);
  }
  ellipse(x, y, 100, 100);
  fill(255);
  text("That's the way it goes.", displayWidth/2, displayHeight/2);
}


