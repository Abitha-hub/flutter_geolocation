import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  /// Checks location permissions and returns the current position
  static Future<Position?> getCurrentLocation() async {
    try {
      // Check if permission is granted
      var permission = await Permission.location.request();
      if (permission.isGranted) {
        // Check if location services are enabled
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          await Geolocator.openLocationSettings();
          return null;
        }

        // Get current location
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
      } else {
        await openAppSettings();
        return null;
      }
    } catch (e) {
      print("Error in LocationService: $e");
      return null;
    }
  }
}

