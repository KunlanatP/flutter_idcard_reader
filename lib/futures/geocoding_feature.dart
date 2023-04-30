import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class GeocodingFeature {
  Future<Placemark?> getAddressFromLatLng(Position? currentPosition) async {
    try {
      if (currentPosition != null) {
        List<Placemark> p = await placemarkFromCoordinates(
            currentPosition.latitude, currentPosition.longitude);
        return p[0];
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
