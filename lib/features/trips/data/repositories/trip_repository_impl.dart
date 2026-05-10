import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/entities/trip.dart';
import '../../../../core/utils/seat_generator.dart';
import '../../domain/entities/create_trip_model.dart';
import '../../domain/repositories/trip_repository.dart';
import '../datasources/trip_remote_datasource.dart';

class TripRepositoryImpl implements TripRepository {
  final FirebaseFirestore _firestore;
  final TripRemoteDataSource remoteDataSource;

  TripRepositoryImpl({
    FirebaseFirestore? firestore,
    required this.remoteDataSource,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;


  Future<void> createTrip(CreateTripModel model, String userId) async {

    final trip = Trip(
      id: '',
      from: model.from!,
      to: model.to!,
      departureTime: model.departureTime!,
      freeSeats: model.freeSeats,
      pricePerSeat: model.pricePerSeat!,
      driverId: userId,
      stops: model.stops,
      preferences: model.preferences,
      description: model.description,

      // 🔥 ВОТ ЭТО ДОБАВЬ
      seats: SeatGenerator.generate(model.freeSeats),
    );

    await _firestore.collection('trips').add(trip.toMap());
  }

  @override
  Stream<List<Trip>> searchTrips({
    String? from,
    String? to,
    DateTime? date,
  }) {
    return remoteDataSource.searchTrips(
      from: from,
      to: to,
      date: date,
    );
  }
}