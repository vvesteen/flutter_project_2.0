import 'package:flutter_project_2/features/trips/find_trip/data/datasources/trip_remote_datasource.dart';
import 'package:flutter_project_2/features/trips/find_trip/domain/entities/trip.dart';
import 'package:flutter_project_2/features/trips/find_trip/domain/repositories/trip_repository.dart';


class TripRepositoryImpl implements TripRepository {
  final TripRemoteDataSource remoteDataSource;

  TripRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<Trip>> getPlannedTrips() {
    return remoteDataSource.getPlannedTrips();
  }
}