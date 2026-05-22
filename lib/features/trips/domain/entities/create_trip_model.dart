import '../../../../core/entities/car_seat_layout.dart';

class CreateTripModel {
  String? from;
  String? to;
  //DateTime? departureTime;
  DateTime departureTime = DateTime.now();
  int freeSeats = 1;
  double? pricePerSeat;
  String? description;
  CarSeatLayout layout =
      CarSeatLayout.sevenSeats;

  List<String> stops = [];

  Map<String, bool> preferences = {
    'smoking': false,
    'talkative': true,
    'music': true,
  };

  Map<String, dynamic> toMap(String userId) {
    return {
      'from': from,
      'to': to,
      'departureTime': departureTime.toIso8601String(),
      'freeSeats': freeSeats,
      'pricePerSeat': pricePerSeat,
      'description': description,
      'preferences': preferences,
      'driverId': userId,
      'status': 'planned',           // ← Убедись, что здесь тоже есть
      'stops': stops,
      'layout': layout.name,
    };
  }
}

