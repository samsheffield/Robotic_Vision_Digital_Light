// SOME 3D BASICS
float rx, rxspeed, ry, ryspeed, rz, rzspeed;

void setup(){
	size(640, 480, P3D); // SET 3D MODE
}

void draw() {
	lights();
	background(0);
	noStroke();
	fill(#ffaa00);
	//stroke(#ffffff);
	//noFill(); 
	//translate(width/2, height/2, 0); // 3D PRIMITIVES MUST BE POSITIONED WITH translate(X,Y,Z)
	//box(200);
	pushMatrix();
	translate(width/2, height/2, 0);
	spin();
	rotateX(radians(rx));
	rotateY(radians(ry));
	rotateZ(radians(rz));
	box(200); 
	popMatrix();
}

void spin(){
	// X AXIS
	rxspeed += (pmouseY-mouseY)*.025;
	rx += rxspeed;
	if (rxspeed != 0) rxspeed += (0-rxspeed)*.025;

	// Y AXIS
	ryspeed += (pmouseX-mouseX)*.025;
	ry += ryspeed;
	if (ryspeed != 0) ryspeed += (0-ryspeed)*.025;	

	//Z AXIS
	if(keyPressed){
		if (key == 'a') rzspeed += .25;
		if (key == 'd') rzspeed -= .25;
	}
	rz += rzspeed;
	if (rzspeed != 0) rzspeed += (0-rzspeed)*.025;	
}
