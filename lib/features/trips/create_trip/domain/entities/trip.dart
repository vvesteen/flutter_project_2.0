// lib/features/create_trip/domain/entities/trip.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Trip {
  String? from;
  String? to;
  DateTime? departureTime;
  int freeSeats = 1;
  double? pricePerSeat;
  String? description;
  List<String> stops = [];
  Map<String, bool> preferences = {
    'smoking': false,
    'talkative': true,
    'music': true,
  };

  bool get isValid =>
      from != null &&
          from!.isNotEmpty &&
          to != null &&
          to!.isNotEmpty &&
          departureTime != null &&
          pricePerSeat != null &&
          pricePerSeat! > 0;

  Map<String, dynamic> toMap() {
    return {
      'from': from,
      'to': to,
      'departureTime': departureTime?.toIso8601String(),
      'freeSeats': freeSeats,
      'pricePerSeat': pricePerSeat,
      'description': description,
      'stops': stops,
      'preferences': preferences,
      //'createdAt': FieldValue.serverTimestamp(),
      'userId': FirebaseAuth.instance.currentUser?.uid,  // если нужно привязать к автору
    };
  }
}