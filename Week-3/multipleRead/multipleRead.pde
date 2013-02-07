// Based on code example from: http://blog.makezine.com/2011/03/02/codebox-use-qr-codes-in-processing/

import processing.video.*;
import com.google.zxing.*;
import java.awt.image.BufferedImage;

Capture cam; //Set up the camera
com.google.zxing.multi.qrcode.QRCodeMultiReader reader = new com.google.zxing.multi.qrcode.QRCodeMultiReader();

String[] qrTexts = {"cat","bird"};  // Aa array of words held in QR codes

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
       // Now test to see if it has a QR code
       LuminanceSource source = new BufferedImageLuminanceSource((BufferedImage)cam.getImage());
       BinaryBitmap bitmap = new BinaryBitmap(new HybridBinarizer(source));       
       Result[] result = reader.decodeMultiple(bitmap);
       
       // Go through all results
       for (int i = 0; i < result.length; i++){
         if (result[i].getText() != null) { 
          String text = result[i].getText();
          ResultPoint[] points = result[i].getResultPoints();

          println("DECODED: " + text);

          //Draw some ellipses on at the control points
          for (int j = 0; j < points.length; j++) {
            fill(#ff8c00);
            ellipse(points[j].getX(), points[j].getY(), 20,20);
          }

          //Now do something if any of the text in our array match the decoded text!
          for (int j = 0; j < qrTexts.length; j++) {
            if (text.equals(qrTexts[j])) {
              println("MATCH: " + text);
            }
          }
         }
       }

    } catch (Exception e) {
        //println(e.toString()); 
    }
  }
}