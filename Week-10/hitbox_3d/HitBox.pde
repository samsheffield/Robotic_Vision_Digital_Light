class HitBox{
	float boxSize;
	PVector boxCenter;
	float startZ;

	HitBox(float x_, float y_, float z_, float boxSize_){
		boxSize = boxSize_;
		boxCenter = new PVector(x_, y_, z_);
		startZ = z_;
	}

	void draw(){
	  translate(boxCenter.x, boxCenter.y, boxCenter.z);
      strokeWeight(1);
      stroke(255, 0, 0);
      noFill();
      box(boxSize);
	}

	void move(){
		boxCenter.set(random(-600,600), random(-600,600), startZ+random(-400,400));
		boxSize = random(100, 500);
	}

	boolean hit(PVector joint){
	  if (joint.x > boxCenter.x - boxSize/2 && joint.x < boxCenter.x + boxSize/2) {
	    if (joint.y > boxCenter.y - boxSize/2 && joint.y < boxCenter.y + boxSize/2) {
	      if (joint.z > boxCenter.z - boxSize/2 && joint.z < boxCenter.z + boxSize/2) {
	        return true;
	      }
	    }
	  }
	  return false;
	}
}