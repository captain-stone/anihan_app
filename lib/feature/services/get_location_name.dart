import 'package:geocoding/geocoding.dart';
import 'package:logger/logger.dart';

Future<String?> getCityName(double latitude, double longitude) async {
  final logger = Logger();
  try {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);

    logger.d(placemarks);
    if (placemarks.isNotEmpty) {
      return placemarks[0].locality;
    }
  } catch (e) {
    logger.e("Error occurred while retrieving city name: $e");
  }
  return null;
}

Future<String?> getFullAddress(String locationString) async {
  final logger = Logger();

  List<String> parts = locationString.split(',');

  // Convert the strings to double
  double latitude = double.parse(parts[0].trim());
  double longitude = double.parse(parts[1].trim());
  try {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);

    // logger.d(placemarks);
    if (placemarks.isNotEmpty) {
      var name = placemarks[0].name;
      var street = placemarks[0].thoroughfare;

      var city = placemarks[0].locality;

      return "$name, $street, $city";
    }
  } catch (e) {
    logger.e("Error occurred while retrieving address name: $e");
  }
  return null;
}
