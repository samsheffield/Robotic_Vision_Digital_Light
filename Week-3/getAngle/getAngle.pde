// Based on code example from: http://blog.makezine.com/2011/03/02/codebox-use-qr-codes-in-processing/

import processing.video.*;
import com.google.zxing.*;
import java.awt.image.BufferedImage;

Capture cam;
com.google.zxing.qrcode.QRCodeReader reader = new com.google.zxing.qrcode.QRCodeReader();

String qrText = "cat";  // A word held in a QR code

float angle, currentAngle, lastAngle;

void setup() {
  size(640, 480);
  cam = new Capture(this, width, height, 30);
  cam.start();
}
 

void draw() {
  if (cam.available() == true) {
    cam.read();    
    image(cam, 0,0);

    try {
       // Now test to see if it has a QR code embedded in it
       LuminanceSource source = new BufferedImageLuminanceSource((BufferedImage)cam.getImage());
       BinaryBitmap bitmap = new BinaryBitmap(new HybridBinarizer(source));       
       Result result = reader.decode(bitmap); 
       
       //If a QR code is detected...
       if (result.getText() != null) { 
          println(result.getText());
          ResultPoint[] points = result.getResultPoints();

          //Draw some ellipses on at the control points
          for (int i = 0; i < points.length; i++) {
            fill(#ff8c00);
            ellipse(points[i].getX(), points[i].getY(), 20,20);
          }

          // Use PVectors to get angle of QR code
          if (result.getText().equals(qrText)) {
            PVector v1 = new PVector(points[0].getX(), points[0].getY());  
            PVector v2 = new PVector(points[1].getX(), points[1].getY()); 
            PVector v3 = PVector.sub(v1, v2);
            angle = v3.heading2D();
          }
       }
    } catch (Exception e) {
        //println(e.toString()); 
    }

    currentAngle += (lastAngle-currentAngle)*.5;
    lastAngle = angle;
    fill(#ff0000);
    rectMode(CENTER);

    pushMatrix();
    translate(width/2, height/2);
    rotate(currentAngle);
    rect(0,0,100,100);
    popMatrix();

  }
}