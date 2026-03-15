// lib/features/create_trip/domain/repositories/trip_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/trip.dart';

abstract class TripRepository {
  Future<void> createTrip(Trip trip);
}