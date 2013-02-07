// This is a basic example using zxing to generate QR codes.
// If you get a bitMatrix to byteMatrix conversion error, update your zxing files.

import com.google.zxing.*;

void setup() {
  int qrCodeSize = 600;
  size(qrCodeSize, qrCodeSize);

  PImage qr = generateQRCode("hello", qrCodeSize);
  image(qr,0,0);
}


void draw() {
  // nothin'
}


// Function for generating QR Code
PImage generateQRCode(String qrCodeText, int qrCodeSize){
  PImage qrImage;
  qrImage = createImage(qrCodeSize, qrCodeSize, RGB);

  try {
    QRCodeWriter qrCodeWriter = new QRCodeWriter();

    // build the QR code
    BitMatrix bitMatrix = qrCodeWriter.encode(qrCodeText, BarcodeFormat.QR_CODE, qrCodeSize, qrCodeSize);

    for (int x = 0; x < qrCodeSize; x++){ 
      for (int y = 0; y < qrCodeSize; y++){ 
        
        // if some data is stored in the 2d matrix
        if (!bitMatrix.get(x, y)) { 
          qrImage.set(x, y, color(255));
        } else { 
          qrImage.set(x, y, color(0));
        }
      }
    } 
  } 
  catch (Exception e) {
    //println(e.toString());
  }
  return qrImage;
}

