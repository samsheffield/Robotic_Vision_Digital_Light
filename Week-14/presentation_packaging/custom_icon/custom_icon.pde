// ADDING A CUSTOM ICON TO YOUR APP (NOT MUCH TO SEE HERE...)
/* . 
ANDROID REQUIRES DIFFERENT SIZE LAUNCHER ICONS FOR DIFFERENT SCREEN RESOLUTIONS, SO YOU'LL NEED TO CREATE A SET.
ADD THE ICONS TO YOUR SKETCH FOLDER LABELED: icon-SIZE

FOR EXAMPLE:
  icon-48
  icon-72
  icon-96
  icon-144
  
  A NICE ONLINE TOOL FOR GENERATING THE LAUNCHER ICON FILES IS THE Android Asset Studio (http://android-ui-utils.googlecode.com/hg/asset-studio/dist/index.html)
 YOU'll NEED TO MANUALLY RENAME THE FILES AND MOVE THEM TO YOUR SKETCH FOLDER. 
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
