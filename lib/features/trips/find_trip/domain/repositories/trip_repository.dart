import 'package:flutter_project_2/features/trips/find_trip/domain/entities/trip.dart';


abstract class TripRepository {
  Stream<List<Trip>> getPlannedTrips();

// Можно добавить параметры фильтрации позже
// Future<List<Trip>> searchTrips(String from, String to, DateTime? date);
}