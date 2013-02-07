// Based on code example from: http://blog.makezine.com/2011/03/02/codebox-use-qr-codes-in-processing/
// The compiled zxing files from the site are old. I would recommend compiling a newer version.

import processing.video.*;
import com.google.zxing.*;
import java.awt.image.BufferedImage;

Capture cam;
com.google.zxing.qrcode.QRCodeReader reader = new com.google.zxing.qrcode.QRCodeReader();

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
       
       // if a QR code is read...
       if (result.getText() != null) { 
          String text = result.getText();
          ResultPoint[] points = result.getResultPoints();

          println("DECODED: " + text);

          //Draw some ellipses on at the control points
          for (int i = 0; i < points.length; i++) {
            fill(#ff8c00);
            ellipse(points[i].getX(), points[i].getY(), 20,20);
          }

          //If it matches, do something...
          String qrText = "cat";  // A word held in a QR code
          if (text.equals(qrText)) { // check actual contents of result
            println("MATCH: " + text + "\n");
          }
       }
    } catch (Exception e) {
        //println(e.toString()); 
    }
  }
}