// USING THE KEYBOARD AS INPUT
// HELP FROM HERE: https://forum.processing.org/topic/show-hide-the-keyboard

// Press a key to begin typing. Toggle keyboard with MENU button

// Android keyboard manager
import android.view.inputmethod.InputMethodManager;
import android.content.Context;
char letter;
boolean showKeyboard;

void setup() {
  orientation(PORTRAIT);
  textSize(displayWidth/4);
  textAlign(CENTER, CENTER);
}

void draw() {
  background(0);
  text(letter, displayWidth/2, displayHeight/2);
}

// Override InputMethodManager's keyboard methods 
void showVirtualKeyboard() {
  InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
  imm.toggleSoftInput(InputMethodManager.SHOW_FORCED, 0);
}

void hideVirtualKeyboard() {
  InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
  imm.toggleSoftInput(InputMethodManager.HIDE_IMPLICIT_ONLY, 0);
}

// Toggle keyboard based on MENU key presses. A little goofy...
void keyReleased() {
  if (key == CODED) {                // If the key is not an alphanumeric character...
    if (keyCode == MENU) {           // Is it the MENU key
      showKeyboard = !showKeyboard;  // Toggle keyboard trigger
      if (showKeyboard) {            // Keyboard!
        showVirtualKeyboard();
      } else {
        hideVirtualKeyboard();
      }
    }
  } else {                           // ... if the key is alphanumeric
    letter = key;                    // Set letter to value of key pressed
  }
}

