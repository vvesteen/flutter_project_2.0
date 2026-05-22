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
      //freeSeats: model.freeSeats,
      pricePerSeat: model.pricePerSeat!,
      driverId: userId,
      stops: model.stops,
      preferences: model.preferences,
      description: model.description,

      // 🔥 ВОТ ЭТО ДОБАВЬ
      seats: SeatGenerator.generate(model.freeSeats),
      passengerIds: [],
      layout: model.layout,
    );

    await _firestore.collection('trips').add(trip.toMap());
  }

  @override
  Stream<List<Trip>> getMyTrips(String userId) {
    return remoteDataSource.getMyTrips(userId);
  }


  @override
  Future<void> joinTrip({
    required String tripId,
    required String userId,
  }) async {

    final doc = await _firestore
        .collection('trips')
        .doc(tripId)
        .get();

    if (!doc.exists || doc.data() == null) {
      throw Exception('Поездка не найдена');
    }

    final trip = Trip.fromMap(doc.data()!, doc.id);

    if (trip.passengerIds.contains(userId)) {
      throw Exception('Вы уже участвуете');
    }

    await _firestore
        .collection('trips')
        .doc(tripId)
        .update({
      'passengerIds': FieldValue.arrayUnion([userId]),
    });
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