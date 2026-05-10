import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/entities/UserEntity.dart';
import '../../../../../core/entities/trip.dart';

class TripRemoteDataSource {
  final _firestore = FirebaseFirestore.instance;

  Stream<List<Trip>> searchTrips({
    String? from,
    String? to,
    DateTime? date,
  }) {
    // Простой запрос — почти без ограничений (не требует составных индексов)
    return _firestore
        .collection('trips')
        .where('status', isEqualTo: 'planned')
        .snapshots()  // убрали where freeSeats и orderBy
        .map((snapshot) {
      List<Trip> trips = snapshot.docs
          .map((doc) => Trip.fromMap(doc.data(), doc.id))
          .where((trip) => trip.freeSeats > 0)           // фильтр на клиенте
          .toList();

      // Фильтрация по "Откуда" и "Куда"
      if (from != null && from.trim().isNotEmpty) {
        trips = trips.where((trip) =>
            trip.from.toLowerCase().contains(from.trim().toLowerCase())).toList();
      }

      if (to != null && to.trim().isNotEmpty) {
        trips = trips.where((trip) =>
            trip.to.toLowerCase().contains(to.trim().toLowerCase())).toList();
      }

      // Фильтр по дате
      if (date != null) {
        trips = trips.where((trip) =>
        trip.departureTime.year == date.year &&
            trip.departureTime.month == date.month &&
            trip.departureTime.day == date.day).toList();
      }

      // Сортировка на клиенте
      trips.sort((a, b) => a.departureTime.compareTo(b.departureTime));

      return trips;
    });
  }

  Future<UserEntity?> getUserById(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();

    if (!doc.exists || doc.data() == null) return null;

    return UserEntity.fromMap(doc.data()!, doc.id);
  }
}