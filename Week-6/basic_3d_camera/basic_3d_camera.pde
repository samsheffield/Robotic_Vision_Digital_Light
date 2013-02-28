// SOME 3D BASICS + PEASYCAM

/*
DRAG ROTATE
CMD-DRAG PAN
SHIFT-DRAG RESTRICT TO AXIS
DOUBLE-DRAG ZOOM
DOUBLE-CLICK RESET
*/
import peasy.*;

PeasyCam cam;


void setup(){
	size(640, 480, P3D); // SET 3D MODE
	cam = new PeasyCam(this, width/2, height/2, 0, 400); // THIS, LOOK AT X, LOOK AT Y, LOOK AT Z, DISTANCE FROM OBJECT
	// OPTIONAL RESTRICTIONS
	cam.setMinimumDistance(50);
	cam.setMaximumDistance(1000);
}

void draw() {
	lights();
	background(0);
	noStroke();
	fill(#ffaa00);
	pushMatrix();
	translate(width/2, height/2, 0);
	box(200); 
	popMatrix();
}
