// SEND AN TEXT MESSAGE FROM YOUR APP. (REQUIRES AN ANDROID PHONE, NOT TABLET.)
// UNLIKE EMAIL, THIS WILL SEND DIRECTLY FROM YOUR APP! USE THIS POWER FOR GOOD, NOT EVIL ;-)
// IMPORTANT: SET THE FOLLOWING PERMISSIONS: SEND_SMS

// Click on the screen to send a text message

// THIS ANDROID CLASS HANDLES SMS
import android.telephony.SmsManager; // DOCUMENTATION: http://developer.android.com/reference/android/telephony/SmsManager.html
SmsManager sms;

String txt = "Sent from Processing!";   // YOUR MESSAGE
String sendTo = "0001112222"; // PHONE NUMBER OF RECIPIENT

boolean messageSent;

void setup() {
  textSize(40);
  textAlign(CENTER, CENTER);
  sms = SmsManager.getDefault();
}

void draw() {
  background(0);
  
  // Optional: give some instruction/feedback
  if (!messageSent){
    text("Click to send message", displayWidth/2, displayHeight/2);
  } else {
    text("Message sent!", displayWidth/2, displayHeight/2);
  }
}

void mouseReleased(){
  if (!messageSent) {
    message(); // Send text message when released. Only do it once.
  }
}

// Basic email function
void message() {
  try {
    sms.sendTextMessage(sendTo, null, txt, null,null); // Send message
    messageSent = true; // Optional: only send once
  } 
  catch (android.content.ActivityNotFoundException ex) {
    println("Error: No message sent!"); 
  }
}