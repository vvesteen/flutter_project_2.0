import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  StreamSubscription<Position>? _positionStream;

  Future<bool> requestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  void startSharingLocation(String tripId) async {
    bool hasPermission = await requestPermission();
    if (!hasPermission) return;

    _positionStream?.cancel();

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // обновлять каждые 10 метров
      ),
    ).listen((Position position) {
      _updateTripLocation(tripId, position);
    });
  }

  void stopSharingLocation() {
    _positionStream?.cancel();
    _positionStream = null;
  }

  Future<void> _updateTripLocation(String tripId, Position position) async {
    final locationData = {
      'lat': position.latitude,
      'lng': position.longitude,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'speed': position.speed * 3.6, // m/s -> км/ч
      'heading': position.heading,
    };

    await FirebaseFirestore.instance
        .collection('trips')
        .doc(tripId)
        .update({
      'currentLocation': locationData,
      'sharingEnabled': true,
      'routePath': FieldValue.arrayUnion([locationData]),
    });
  }
}