import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_idcard_reader/constants/language.dart';

class GeolocatorWidget extends StatefulWidget {
  const GeolocatorWidget({super.key});

  @override
  State<GeolocatorWidget> createState() => _GeolocatorWidgetState();
}

class _GeolocatorWidgetState extends State<GeolocatorWidget> {
  Position? _currentPosition;
  String? _currentAddress;

  static const String _kLocationServicesDisabledMessage =
      'Location services are disabled.';
  static const String _kPermissionDeniedMessage = 'Permission denied.';
  static const String _kPermissionDeniedForeverMessage =
      'Permission denied forever.';
  static const String _kPermissionGrantedMessage = 'Permission granted.';

  final GeolocatorPlatform geolocatorAndroid = GeolocatorPlatform.instance;
  _PositionItem? _positionItem;

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return;
    }

    final position = await geolocatorAndroid.getCurrentPosition();
    setState(() {
      _currentPosition = position;
    });
    _getAddressFromLatLng();
    _updatePositionList(
      _PositionItemType.position,
      position.toString(),
    );
  }

  Future<void> _getAddressFromLatLng() async {
    try {
      if (_currentPosition != null) {
        List<Placemark> p = await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude);
        Placemark place = p[0];
        setState(() {
          _currentAddress =
              "${place.locality}, ${place.postalCode}, ${place.country}";
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await geolocatorAndroid.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      _updatePositionList(
        _PositionItemType.log,
        _kLocationServicesDisabledMessage,
      );

      return false;
    }

    permission = await geolocatorAndroid.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await geolocatorAndroid.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        _updatePositionList(
          _PositionItemType.log,
          _kPermissionDeniedMessage,
        );

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      _updatePositionList(
        _PositionItemType.log,
        _kPermissionDeniedForeverMessage,
      );

      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    _updatePositionList(
      _PositionItemType.log,
      _kPermissionGrantedMessage,
    );
    return true;
  }

  void _updatePositionList(_PositionItemType type, String displayValue) {
    _positionItem = _PositionItem(type, displayValue);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_positionItem == null) {
      return const Scaffold(body: Center(child: Text('No Position')));
    }

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -2),
            color: Colors.grey.shade400,
            blurRadius: 4,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: <Widget>[
                const Icon(
                  Icons.location_on,
                  color: Colors.redAccent,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        translation(context).location_text,
                        style: GoogleFonts.inter(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (_currentPosition != null && _currentAddress != null)
                        Text(
                          _currentAddress ?? '',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF333335),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum _PositionItemType {
  log,
  position,
}

class _PositionItem {
  _PositionItem(this.type, this.displayValue);

  final _PositionItemType type;
  final String displayValue;
}
