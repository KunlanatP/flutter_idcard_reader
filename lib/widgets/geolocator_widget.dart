import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum PositionItemType {
  log,
  position,
}

class PositionItem {
  PositionItem(this.type, this.displayValue);

  final PositionItemType type;
  final String displayValue;
}

typedef PositionCallback = void Function(Position position);

class MapsWidget extends StatefulWidget {
  final PositionCallback? positionCallback;

  const MapsWidget({super.key, this.positionCallback});

  @override
  State<MapsWidget> createState() => _MapsWidgetState();
}

class _MapsWidgetState extends State<MapsWidget> {
  var mapmarker = HashSet<Marker>();
  CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(17.0761884, 102.9304118),
    zoom: 17,
  );
  late GoogleMapController _googleMapController;

  static const String _kLocationServicesDisabledMessage =
      'Location services are disabled.';
  static const String _kPermissionDeniedMessage = 'Permission denied.';
  static const String _kPermissionDeniedForeverMessage =
      'Permission denied forever.';
  static const String _kPermissionGrantedMessage = 'Permission granted.';

  final GeolocatorPlatform geolocatorAndroid = GeolocatorPlatform.instance;
  PositionItem? _positionItem;

  @override
  void initState() {
    _getCurrentPosition();
    super.initState();
  }

  @override
  void deactivate() {
    _googleMapController.dispose();
    super.deactivate();
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return;
    }

    final position = await geolocatorAndroid.getCurrentPosition();
    setState(() {
      mapmarker.add(
        Marker(
          markerId: const MarkerId('1'),
          position: LatLng(position.latitude, position.longitude),
        ),
      );
      _initialCameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 17,
      );
    });

    _updatePositionList(
      PositionItemType.position,
      position.toString(),
    );

    widget.positionCallback?.call(position);
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
        PositionItemType.log,
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
          PositionItemType.log,
          _kPermissionDeniedMessage,
        );

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      _updatePositionList(
        PositionItemType.log,
        _kPermissionDeniedForeverMessage,
      );

      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    _updatePositionList(
      PositionItemType.log,
      _kPermissionGrantedMessage,
    );
    return true;
  }

  void _updatePositionList(PositionItemType type, String displayValue) {
    _positionItem = PositionItem(type, displayValue);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    if (_positionItem == null) {
      return const Text('No Position');
    }

    return SizedBox(
      width: screenSize.width,
      height: screenSize.height * 0.3,
      child: Stack(
        children: [
          GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) => _googleMapController = controller,
            markers: mapmarker,
          ),
          Align(
            alignment: const Alignment(0.95, -0.95),
            child: InkWell(
              onTap: () => _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(_initialCameraPosition),
              ),
              child: Container(
                width: 48,
                height: 48,
                decoration: ShapeDecoration(
                  color: Colors.grey.shade300.withAlpha(210),
                  shape: const CircleBorder(),
                ),
                child: Icon(
                  Icons.center_focus_strong,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
