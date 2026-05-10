// features/seats/Seat.dart
import 'package:flutter/material.dart';

enum SeatStatus { free, male, female, withChild, selected }

class Seat {
  final int index;
  final SeatStatus status;
  final String? userId;
  final String? gender;   // 'male' или 'female'

  Seat({
    required this.index,
    required this.status,
    this.userId,
    this.gender,
  });

  Color get color {
    switch (status) {
      case SeatStatus.male:
        return Colors.blue.shade400;
      case SeatStatus.female:
        return Colors.pink.shade400;
      case SeatStatus.withChild:
        return Colors.purple.shade400;
      case SeatStatus.selected:
        return Colors.orange;
      default:
        return Colors.grey.shade300;
    }
  }

  Seat copyWith({
    int? index,
    SeatStatus? status,
    String? userId,
    String? gender,
  }) {
    return Seat(
      index: index ?? this.index,
      status: status ?? this.status,
      userId: userId ?? this.userId,
      gender: gender ?? this.gender,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'index': index,
      'status': status.name,
      'userId': userId,
      'gender': gender,
    };
  }

  factory Seat.fromMap(Map<String, dynamic> map) {
    return Seat(
      index: map['index'],
      status: SeatStatus.values.byName(map['status'] ?? 'free'),
      userId: map['userId'],
      gender: map['gender'],
    );
  }
}