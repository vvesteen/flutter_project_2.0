import 'package:flutter_project_2/features/trips/find_trip/domain/entities/trip.dart';
import 'package:flutter_project_2/features/trips/find_trip/domain/repositories/trip_repository.dart';

class SearchTripsUseCase {
  final TripRepository repository;

  SearchTripsUseCase(this.repository);

  Stream<List<Trip>> call({
    String? from,
    String? to,
    DateTime? date,
  }) {
    return repository.getPlannedTrips().map((trips) {
      return trips.where((trip) {
        final matchFrom = from == null || from.trim().isEmpty ||
            trip.from.toLowerCase().contains(from.toLowerCase().trim());

        final matchTo = to == null || to.trim().isEmpty ||
            trip.to.toLowerCase().contains(to.toLowerCase().trim());

        bool matchDate = true;
        if (date != null) {
          matchDate = trip.departureTime.year == date.year &&
              trip.departureTime.month == date.month &&
              trip.departureTime.day == date.day;
        }

        return matchFrom && matchTo && matchDate && trip.hasAvailableSeats;
      }).toList()
        ..sort((a, b) => a.departureTime.compareTo(b.departureTime));
    });
  }
}