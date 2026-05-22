// lib/features/create_trip/domain/repositories/trip_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_project_2/core/entities/trip.dart';

import '../entities/create_trip_model.dart';

abstract class TripRepository {
  Future<void> createTrip(CreateTripModel model, String userId);
  Stream<List<Trip>> getMyTrips(String userId);

  Stream<List<Trip>> searchTrips({
    String? from,
    String? to,
    DateTime? date,
  });

  Future<void> joinTrip({
    required String tripId,
    required String userId,
  });

}
