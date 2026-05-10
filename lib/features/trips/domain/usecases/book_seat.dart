import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../seats/Seat.dart';

class BookSeatUseCase {
  final FirebaseFirestore firestore;

  BookSeatUseCase(this.firestore);

  Future<void> call({
    required String tripId,
    required List<Seat> seats,
    required Seat seat,
    required String userId,
  }) async {

    final updatedSeats = seats.map((s) {
      if (s.index == seat.index) {
        return s.copyWith(
          status: SeatStatus.male, // потом заменим на gender
          userId: userId,
        );
      }
      return s;
    }).toList();

    await firestore
        .collection('trips')
        .doc(tripId)
        .update({
      'seats': updatedSeats.map((e) => e.toMap()).toList(),
    });
  }
}