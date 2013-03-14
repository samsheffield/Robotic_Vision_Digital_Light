class Particle {
    float dx, dy, x, y, startX, startY;
    int rotation;
    color c = color(random(255), random(255), random(255));
    //color c = color(255, 255, random(125, 225));
    float speed;
    float angle;
    PVector v1 = new PVector(0,0);
    PVector v2 = new PVector(0,0);
    PVector v3 = new PVector(0,0);
    float offset;


    Particle(PVector convertedJoint, PVector prevJoint) {
        x = convertedJoint.x;
        y = convertedJoint.y;
        startX = convertedJoint.x;
        startY = convertedJoint.y;

        v1 = new PVector(prevJoint.x, prevJoint.y); // ANCHOR FOR ANGLE
        v2 = new PVector(convertedJoint.x, convertedJoint.y); // MOVING TOWARDS THIS POINT
        v3 = PVector.sub(v2, v1); // STORE THE DIFFERENCE BETWEEN THE VECTORS. THE ORDER MATTERS!

        angle = -degrees(v3.heading2D())+random(-15,15);
        speed = dist(v1.x, v1.y, v2.x, v2.y)*.25+.1;
        dx =  speed * cos(radians(angle));
        dy =  -speed * sin(radians(angle));
    }

    Particle(PVector convertedJoint, PVector prevJoint, float offsetXY) {
        offset = random(-offsetXY, offsetXY);
        x = convertedJoint.x + offset;
        y = convertedJoint.y + offset;
        startX = x;
        startY = x;

        v1 = new PVector(prevJoint.x, prevJoint.y); // ANCHOR FOR ANGLE
        v2 = new PVector(convertedJoint.x, convertedJoint.y); // MOVING TOWARDS THIS POINT
        v3 = PVector.sub(v2, v1); // STORE THE DIFFERENCE BETWEEN THE VECTORS. THE ORDER MATTERS!

        angle = -degrees(v3.heading2D())+random(-15,15);
        speed = dist(v1.x, v1.y, v2.x, v2.y)*.25+.1;
        dx =  speed * cos(radians(angle));
        dy =  -speed * sin(radians(angle));
    }

    void move(){
        angle += random(-9, 9);
        dx =  speed * cos(radians(angle));
        dy =  -speed * sin(radians(angle));
        x += dx;
        y += dy;
        //y += 1; // ads gravity. small particles fall
    }

    void display() {
        move();
        //fill(c, 60);
        //stroke(c, 80);
        fill(c);
        ellipseMode(CENTER);
        pushMatrix();
        translate(x,y);
        ellipse(0, 0, speed*2, speed*2);
        popMatrix();

    }

    boolean finished(){
        if(x > width+50 || x < -50 || y > height+50 || y < -50){
            return true;
        }else{
            return false;
        }
    }
    
    
}