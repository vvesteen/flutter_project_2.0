import '../../features/seats/Seat.dart';

class SeatGenerator {
  static List<Seat> generate(int count) {
    return List.generate(count, (index) {
      return Seat(
        index: index,
        status: SeatStatus.free,
        userId: null,
        gender: null,
      );
    });
  }
}