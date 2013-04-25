// SOUNDS: PLAYING BACK AND LOOPING

// HELP FROM HERE: https://forum.processing.org/topic/sound-libraries
// PAUSE & RESUME: http://stackoverflow.com/questions/3855151/how-to-resume-the-mediaplayer

// Loop a background melody. Trigger a sound with a tap. Notice how it won't let you overlap the same sound...

// USED to load and play audio files
import android.media.MediaPlayer;
import android.content.res.AssetManager;
import android.content.res.AssetFileDescriptor;

MediaPlayer snd; // DOCUMENTATION: http://developer.android.com/reference/android/media/MediaPlayer.html
MediaPlayer laser;
AssetManager assetManager;
AssetFileDescriptor fd;
int position;

void setup() { 
  snd = new MediaPlayer(); // Sound player object  
  laser = new MediaPlayer(); 
  // Read the audio files  
  assetManager = this.getAssets(); 

 // Set up MediaPlayers and load files 
  try {    
    fd = assetManager.openFd("test.mp3"); // Open file
    
    snd.setDataSource(fd.getFileDescriptor(), fd.getStartOffset(), fd.getLength());    
    snd.prepare(); // Prepare player for playback 
    
    snd.setLooping(true); // Optional: Turn on looping   
    snd.setVolume(.25,.25); // Optional: Set volume scaling
    snd.start();
    
    fd = assetManager.openFd("laser.wav");  // Reuse the AssetManager to open file 
    
    laser.setDataSource(fd.getFileDescriptor(), fd.getStartOffset(), fd.getLength());    
    laser.prepare();
    laser.setVolume(.25,.25);
  }   
  catch (IllegalArgumentException e) {    
    e.printStackTrace();
  }   
  catch (IllegalStateException e) {    
    e.printStackTrace();
  } 
  catch (IOException e) {
    e.printStackTrace();
  }
}

void draw(){
  background(0);
}

void mousePressed(){
  laser.start();
}

// Pause sounds when app is in background
void onPause() {
  super.onPause();
  if (snd != null) {
    snd.pause();
    position = snd.getCurrentPosition(); // Keep track of where sound left off
    laser.pause(); // Laser is very short, so we don't have to save currentPosition
  }
}

// When app is restarted, begin playing sound again 
void onResume() {
  super.onResume();
  if (snd != null) {
    snd.seekTo(position); // Go to point where audio was stopped
    snd.start();
  }
}

void onDestroy() {
  super.onDestroy(); 
  if(snd!=null) { 
    snd.release();
  }
  
  if(laser!=null) { 
    laser.release();
  }
}
