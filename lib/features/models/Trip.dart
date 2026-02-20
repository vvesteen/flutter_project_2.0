import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  String? from;
  String? to;
  List<String> stops = [];
  DateTime? departureTime;
  int freeSeats = 1;
  double? pricePerSeat;
  String? description;
  Map<String, bool> preferences = {
    'smoking': false,
    'talkative': true,
    'music': true,
    'pets': false,
  };
  Trip();

  bool get isValid {
    return from != null &&
        from!.trim().isNotEmpty &&
        to != null &&
        to!.trim().isNotEmpty &&
        departureTime != null &&
        departureTime!.isAfter(DateTime.now().subtract(const Duration(minutes: 5))) &&
        freeSeats >= 1 &&
        pricePerSeat != null &&
        pricePerSeat! > 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'from': from?.trim(),
      'to': to?.trim(),
      'stops': stops,
      'departureTime': departureTime?.toIso8601String(),
      'freeSeats': freeSeats,
      'pricePerSeat': pricePerSeat,
      'description': description?.trim(),
      'preferences': preferences,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'status': 'planned',
      //'driverId': driverId,     // будет null — это ок
      //'driverName': driverName, // будет null — это ок
    };}

  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip()
      ..from = map['from'] as String?
      ..to = map['to'] as String?
      ..stops = List<String>.from(map['stops'] ?? [])
      ..departureTime = map['departureTime'] != null
          ? DateTime.tryParse(map['departureTime'] as String)
          : null
      ..freeSeats = map['freeSeats'] as int? ?? 1
      ..pricePerSeat = (map['pricePerSeat'] as num?)?.toDouble()
      ..description = map['description'] as String?
      ..preferences = Map<String, bool>.from(map['preferences'] ?? {});
  }
}
