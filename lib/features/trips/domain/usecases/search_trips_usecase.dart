import '../../../../../core/entities/trip.dart';
import '../repositories/trip_repository.dart';

class SearchTripsUseCase {
  final TripRepository repository;

  SearchTripsUseCase(this.repository);

  Stream<List<Trip>> call({
    String? from,
    String? to,
    DateTime? date,
  }) {
    return repository.searchTrips(
      from: from,
      to: to,
      date: date,
    );
  }
}