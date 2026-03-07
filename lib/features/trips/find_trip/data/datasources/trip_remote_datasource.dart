import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_project_2/features/trips/find_trip/domain/entities/trip.dart' hide Trip;

import 'package:flutter_project_2/features/trips/find_trip/domain/entities/trip.dart';


class TripRemoteDataSource {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref('Trips');

  Stream<List<Trip>> getPlannedTrips() {
    return _ref
        .orderByChild('status')
        .equalTo('planned')
        .onValue
        .map((event) {
      if (!event.snapshot.exists || event.snapshot.value == null) {
        return <Trip>[];
      }

      final data = event.snapshot.value as Map<dynamic, dynamic>;
      final List<Trip> trips = [];

      data.forEach((key, value) {
        final tripMap = Map<dynamic, dynamic>.from(value as Map);
        trips.add(Trip.fromMap(tripMap, key.toString()));
      });

      return trips;
    });
  }
}