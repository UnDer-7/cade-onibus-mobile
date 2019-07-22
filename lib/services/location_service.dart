import 'package:location/location.dart';

abstract class LocationService {
    static Future<LocationData> get userLocation async {
        final location = Location();
        return await location.getLocation();
    }
}
