import 'package:collection/collection.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geo;

dynamic pollPoint(LatLng start) async {
  for (var element in await geo.placemarkFromCoordinates(start.latitude, start.longitude)) {
    print(element);
  }
}
