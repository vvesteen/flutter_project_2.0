import 'package:flutter/material.dart';

enum SeatStatus {
  free,
  male,
  female,
  withChild,
  selected,
}

class Seat {
  final int index;
  final SeatStatus status;
  final String? userId;
  final String? gender;
  final bool isDriverSeat;

  Seat({
    required this.index,
    required this.status,
    this.userId,
    this.gender,
    this.isDriverSeat = false,
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

      case SeatStatus.free:
        return Colors.grey.shade300;
    }
  }

  Seat copyWith({
    int? index,
    SeatStatus? status,
    String? userId,
    String? gender,
    bool? isDriverSeat,

    bool clearUserId = false,
    bool clearGender = false,
  }) {
    return Seat(
      index: index ?? this.index,

      status: status ?? this.status,

      userId: clearUserId
          ? null
          : (userId ?? this.userId),

      gender: clearGender
          ? null
          : (gender ?? this.gender),

      isDriverSeat:
      isDriverSeat ?? this.isDriverSeat,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'index': index,
      'status': status.name,
      'userId': userId,
      'gender': gender,
      'isDriverSeat': isDriverSeat,
    };
  }

  factory Seat.fromMap(Map<String, dynamic> map) {
    return Seat(
      index: map['index'],
      status: SeatStatus.values.byName(map['status'] ?? 'free'),
      userId: map['userId'],
      gender: map['gender'],
      isDriverSeat: map['isDriverSeat'] ?? false,
    );
  }

  String get label {
    switch (status) {
      case SeatStatus.male:
        return 'M';

      case SeatStatus.female:
        return 'Ж';

      case SeatStatus.withChild:
        return 'Д';

      default:
        return '';
    }
  }
}