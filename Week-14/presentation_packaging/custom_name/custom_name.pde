// ADDING A CUSTOM NAME TO YOUR APP (NOT MUCH TO SEE HERE...)
/* 
To edit the name of your app, CAREFULLY edit the AndroidManifest.xml file in your sketch folder.

Change this:
<application android:label=""

To this:
<application android:label="YOUR APPLICATION NAME!"

OBVIOUSLY, "YOUR APPLICATION NAME!" needs to be replaced with the real name!
*/

float rotation;

void setup() {
  orientation(PORTRAIT);
  rectMode(CENTER);
}

void draw() {
  background(0);
  translate(displayWidth/2, displayHeight/2);
  rotate(radians(rotation));
  rect(0, 0, 100, 100);
  rotation++;
}
