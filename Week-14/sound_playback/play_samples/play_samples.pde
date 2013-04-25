// SAMPLES: TRIGGERING STREAMING/OVERLAPPING SOUNDS
// HELP FROM HERE: https://forum.processing.org/topic/audio-with-soundpool-ok-but-it-drops-out

// Tap screen to fire laser! Pew! Pew!

// These are needed to load and play audio samples
import android.media.SoundPool;
import android.content.res.AssetManager; 
import android.media.AudioManager; 
AssetManager assetManager;

SoundPool sounds; // DOCUMENTATION: http://developer.android.com/reference/android/media/SoundPool.html


int soundID1;

void setup() {
  // Arguments: Maximum number of simultaneous streams, Stream type, quality (use 0)
  sounds = new SoundPool(10, AudioManager.STREAM_MUSIC, 0); 
  assetManager = this.getAssets();

  try { 
    soundID1 = sounds.load(assetManager.openFd("laser.wav"), 0); // Load file, set priority of playback, and give it an ID
  } 
  catch (IOException e) {
    e.printStackTrace(); 
  }
}

void draw() {  
  background(0);
}

void mousePressed() {
  // Sound ID, left volume, right volume, priority, loop (-1 means loop), playback rate(0.5-2.0)
    sounds.play(soundID1, 1, 1, 0, 0, random(.5,2));
}    

// Get rid of stored sounds when app is fully closed
public void onDestroy() {
  super.onDestroy(); 
  if(sounds!=null) { 
    sounds.release();
  }
}

