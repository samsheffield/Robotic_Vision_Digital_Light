// SEND AN EMAIL FROM YOUR APP.
// Click on the screen to send an email

import android.content.Intent; // Connect to an app which will do the actual emailing
Intent email;

String subject = "From Processing";
String content = "Get back to work!";

boolean mailed;

void setup() {
  textSize(40);
  textAlign(CENTER, CENTER);
}

void draw() {
  background(0);
  
  // Optional: give some instruction/feedback
  if (!mailed){
    text("Click to email", displayWidth/2, displayHeight/2);
  } else {
    text("Email sent!", displayWidth/2, displayHeight/2);
  }
  
}

void mouseReleased(){
  if (!mailed) {
    mail(); // Send mail when released. Only do it once.
  }
}

// Basic email function
void mail() {
  try {
    email = new Intent(Intent.ACTION_SEND);                      // Create Intent object
    email.setType("text/plain");
    email.putExtra(Intent.EXTRA_SUBJECT, subject);              // Add subject and content
    email.putExtra(Intent.EXTRA_TEXT, content);
    startActivity(Intent.createChooser(email, "Sending email"));// Launch the system's email chooser panel
    mailed = true; // Optional: only email once
  } 
  catch (android.content.ActivityNotFoundException ex) {
    println("Error: No email sent!");                          // Raise an error if there are no email applications
  }
}
