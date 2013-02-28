class Button {
	float x, y, w, h;
	color c;

	Button(float x_, float y_, float w_, float h_){
		x = x_;
		y = y_;
		w = w_;
		h = h_;
		c = color(#ffaa00, 100);
	}

	void draw(){
		stroke(#ffaa00);
		fill(c);
		rect(x, y, w, h);
	}

	boolean hit(float hitX_, float hitY_){
		if ((hitX_ > x && hitX_ < x + w) && (hitY_ > y && hitY_ < y + h) ){
			c = color(#ffaa00, 200);
			return true;
		} else {
			c = color(#ffaa00, 100);
			return false;
		}	
	}
}