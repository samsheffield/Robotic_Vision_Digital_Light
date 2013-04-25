// GETTING GPS COORDINATES
// BASED ON ORIGINAL CODE BY JEFF THOMPSON (www.jeffreythompson.org)
// SET PERMISSIONS: ACCESS_FINE_LOCATION AND INTERNET

// Tap screen to get current GPS location

import android.content.Context;              // Required imports for GPS
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.location.Criteria;

import android.location.Geocoder;            // Optional imports to get address from GPS coordinates
import android.location.Address;
import java.util.Locale;                     
import java.util.List;

String location;                             // String to format location
String address;                              // String of street address
double longitude, latitude;                  // Note: Android returns location as a double

void setup() {
  orientation(LANDSCAPE);           
  textSize(40);
  textAlign(CENTER, CENTER);
  location = "Click for current location.";
}

void draw() {
  background(0);
  text(location, displayWidth/2, displayHeight/2);
}

void mouseReleased() {
  location = "Fetching current location."; // Give a little feedback if the service is slow
  getGPSLocation(); // Get location
}


// Get the location, store the latitude and longitude, and (optionally) get address.
void getGPSLocation() {
  try {
    // Get GPS coordinates by choosing best provider (3G or Wifi)
    LocationManager lm = (LocationManager)getSystemService(Context.LOCATION_SERVICE);
    Criteria criteria = new Criteria();                       
    String provider = lm.getBestProvider(criteria, false);       // Can get a list of providers, or the best
    Location gpsLocation = lm.getLastKnownLocation(provider);    // Location (last known if new isn't available)

    // Parse GPS coordinates
    longitude = gpsLocation.getLongitude();
    latitude = gpsLocation.getLatitude();

    address = coordinatesToAddress(latitude, longitude); // Convert coordinates to an address

    // Format String with coordinates and address
    location = "Lat: " + latitude + " / Lon: " + longitude + "\n\n" + address;
  }
  catch (NullPointerException npe) {
    location = "GPS is not available."; // Set text to display an error message if we can't connect
  }

}

// Get address from coordinates. 
String coordinatesToAddress(double latitude_, double longitude_){ 
  String tempAddress="";
  
  try{
    Geocoder geocoder = new Geocoder(this, Locale.getDefault());
    
    List<Address> addresses = geocoder.getFromLocation(latitude_, longitude_, 1);  // 1 = # of results to get
    if (!addresses.isEmpty()) {                                                    // if there is an address...
      Address addr = addresses.get(0);                                             // get from list...

      // Go through all entries (can include street address, city, postal code, or even points of interest)
      for (int i=0; i<addr.getMaxAddressLineIndex(); i++) {
        tempAddress += addr.getAddressLine(i) + "\n";         // Add to address with newline character
      }
    } else {
      tempAddress = "Could not find an address!";             // If not found, let us know
    }
  }
  catch (IOException ioe) {
     println("Could not load address.");                     // Problem loading address?
  }
  
  return tempAddress;                                       // Return the address string
}
