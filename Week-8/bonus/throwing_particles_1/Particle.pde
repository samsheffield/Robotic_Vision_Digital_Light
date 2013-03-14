class Particle {
    float dx, dy, x, y, startX, startY;
    int rotation;
    color c = color(random(255), random(255), random(255));
    float spd;
    float angl;

    Particle(float x_, float y_, float dx_, float dy_, float angle, float speed) {
        rotation = int(random(360));
        dx = dx_ + speed * cos(radians(angle));
        dy = dy_ + -speed * sin(radians(angle));
        x = x_;
        y = y_;
        startX = x_;
        startY = y_;
        spd = speed;
        angl = angle;
    }

    void move(){
        angl += random(-9, 9);
        dx =  spd * cos(radians(angl));
        dy =  -spd * sin(radians(angl));
        x += dx;
        y += dy;
        //y += 1; // ads gravity. small particles fall
    }

    void display() {
        move();
        fill(c);
        ellipseMode(CENTER);
        pushMatrix();
        translate(x,y);
        ellipse(0, 0, spd*2, spd*2);
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