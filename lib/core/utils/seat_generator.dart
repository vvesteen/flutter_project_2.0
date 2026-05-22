import '../../features/seats/Seat.dart';

class SeatGenerator {

  static List<Seat> generate(int passengerSeatsCount) {

    return List.generate(
      passengerSeatsCount + 1, // +1 место водителя
          (index) {

        // 🚗 водительское место
        if (index == 0) {
          return Seat(
            index: index,
            status: SeatStatus.selected,
            userId: null,
            gender: null,
            isDriverSeat: true,
          );
        }

        // 👤 пассажирские места
        return Seat(
          index: index,
          status: SeatStatus.free,
          userId: null,
          gender: null,
        );
      },
    );
  }
}