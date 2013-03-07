import SimpleOpenNI.*;
SimpleOpenNI kinect; 

void setup() {
    size(640, 480, P3D);
    kinect = new SimpleOpenNI(this); 
    kinect.enableDepth(); 
    kinect.setMirror(true);
    kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_NONE); // GET USERS, BUT NOT SKELETON DATA
    
}
void draw() {
    kinect.update();
    PImage depthImage = kinect.depthImage();
    image(depthImage, 0, 0);
    
    IntVector userList = new IntVector(); // WILL HOLD INTS OF USERS
    kinect.getUsers(userList); // STORE THE LIST OF DETECTED USERS
    
    for (int i=0; i<userList.size(); i++) { // GO THROUGH THE ARRAY OF USERS
        int userId = userList.get(i); // GET THE USER
        PVector position = new PVector();
        kinect.getCoM(userId, position); // STORE userId XYZ IN position
        kinect.convertRealWorldToProjective(position, position);

        fill(#ff5500);
        textAlign(CENTER);
        textSize(50);
        text(userId, position.x, position.y); // SHOW USER ID
    }
}

