// TURN OFF DEFAULT DIMMING/SLEEPING
// SOLUTION FROM HERE: https://forum.processing.org/topic/turning-sleep-mode-off-in-android

float x, y;

// TO DO THIS, IT'S NECESSARY TO OVERRIDE THE DEFAULT WINDOWING. SINCE THESE ARE NOT PROCESSING CLASSES, WE NEED TO IMPORT THEM.
import android.os.Bundle;
import android.view.WindowManager;

void setup() {
  x = displayWidth/2;
  y = displayHeight/2;
  orientation(PORTRAIT);
}

void draw() {
  x = mouseX;
  y = mouseY;
  fill(0, 60);
  rect(0, 0, width, height);
  fill(255);
  ellipse(x, y, 100, 100);
}

// OVERRIDE THE DEFAULT ACTIVITY INITIALIZATION (Android.app.Activity.onCreate())
void onCreate(Bundle bundle) {
  // DO ALL THE OTHER NORMAL STUFF...
  super.onCreate(bundle);
  // KEEP SCREEN ON!
  getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON); // DETAILS: http://developer.android.com/reference/android/view/WindowManager.LayoutParams.html
}
