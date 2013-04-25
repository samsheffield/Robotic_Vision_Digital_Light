// CONTROL VIBRATION
// IMPORTANT: SET PERMISSIONS FOR VIBRATE

// Control vibration by moving  a finger. Pulse rate is controlled by distance of movement.

import android.content.Context;
import android.os.Vibrator;     // DOCUMENTATION: http://developer.android.com/reference/android/os/Vibrator.html
Vibrator vibrator;  

int threshhold = 1;                         // Minimum movement needed to trigger vibrator
long distMoved;                             // Keep track of distance finger has traveled
long duration = 100;                        // How long to vibrate (in milliseconds)
long[] vibrations = { 0, 100, 100, 100 };   // You can also specify this in an array (OFF, ON, OFF, ON, etc...)

void setup() {
  vibrator = (Vibrator) getSystemService(Context.VIBRATOR_SERVICE); // Start vibrator
}

void draw() {
  distMoved = (long)abs(dist(mouseX, mouseY, pmouseX, pmouseY));
  background(distMoved*20, 200, 200);
  
  if (distMoved > threshhold) {
    duration = distMoved; // Optional: Base vibration pulse on distance moved by finger
    vibrator.vibrate(duration);    
    //vibrator.vibrate(vibrations, -1); // Optional: Use an array instead! The int is used to specify where in the array to repeat from (-1 means "no repeat")          
  }
}
