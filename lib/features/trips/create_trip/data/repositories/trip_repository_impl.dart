// lib/features/create_trip/data/repositories/trip_repository_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/trip.dart';
import '../../domain/repositories/trip_repository.dart';

class TripRepositoryImpl implements TripRepository {
  final FirebaseFirestore _firestore;

  TripRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createTrip(Trip trip) async {
    await _firestore.collection('trips').add(trip.toMap());
    // или .doc(customId).set(...) если нужен свой ID
  }
}