import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

AutoDisposeStateProvider<Position?> currentPosition =
    StateProvider.autoDispose<Position?>((ref) {
  return null;
});
