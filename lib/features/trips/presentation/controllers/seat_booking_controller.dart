import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/entities/trip.dart';
import '../../../seats/Seat.dart';

class SeatBookingController {
  final FirebaseFirestore firestore;

  SeatBookingController(this.firestore);

  Future<List<Seat>> bookSeat({
    required Trip trip,
    required Seat seat,
    required String userId,
    required String sex,
  }) async {
    if (seat.status != SeatStatus.free &&
        seat.status != SeatStatus.selected) {
      throw Exception('Место занято');
    }

    final updatedSeats = trip.seats.map((s) {
      if (s.index == seat.index) {
        final newStatus =
        sex == 'male'
            ? SeatStatus.male
            : SeatStatus.female;

        return s.copyWith(
          status: newStatus,
          userId: userId,
          gender: sex,
        );
      }

      return s;
    }).toList();

    await firestore
        .collection('trips')
        .doc(trip.id)
        .update({
      'seats': updatedSeats.map((e) => e.toMap()).toList(),
      'passengerIds': FieldValue.arrayUnion([userId]),
      'freeSeats': FieldValue.increment(-1),
    });

    return updatedSeats;
  }
}