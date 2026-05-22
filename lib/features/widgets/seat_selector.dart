import 'package:flutter/material.dart';

import '../../core/entities/car_seat_layout.dart';
import '../seats/Seat.dart';

class SeatSelector extends StatelessWidget {
  final List<Seat> seats;

  final CarSeatLayout layout;

  final Function(Seat) onSeatSelected;

  final Function(Seat)? onOccupiedSeatTap;

  final bool readOnly;

  const SeatSelector({
    super.key,
    required this.seats,
    required this.layout,
    required this.onSeatSelected,
    this.onOccupiedSeatTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 340,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(32),
      ),

      child: Stack(
        children: _buildSeats(),
      ),
    );
  }

  List<Widget> _buildSeats() {

    final positions =
    layout == CarSeatLayout.sevenSeats
        ? _sevenSeatPositions()
        : _eightSeatPositions();

    return List.generate(
      seats.length,
          (index) {

        final seat = seats[index];

        final pos = positions[index];

        return Positioned(
          left: pos.dx,
          top: pos.dy,

          child: GestureDetector(
            onTap: () {

              if (readOnly) return;

              if (seat.status == SeatStatus.free) {
                onSeatSelected(seat);
              }

              else {
                onOccupiedSeatTap?.call(seat);
              }
            },

            child: Container(
              width: 52,
              height: 52,

              decoration: BoxDecoration(
                color: seat.color,
                shape: BoxShape.circle,
              ),

              alignment: Alignment.center,

              child: Text(
                seat.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Offset> _sevenSeatPositions() {
    return const [

      Offset(40, 20),
      Offset(160, 20),

      Offset(40, 110),
      Offset(160, 110),

      Offset(40, 200),
      Offset(160, 200),

      Offset(280, 110),
    ];
  }

  List<Offset> _eightSeatPositions() {
    return const [

      Offset(40, 20),
      Offset(160, 20),
      Offset(280, 20),

      Offset(40, 110),
      Offset(160, 110),

      Offset(40, 200),
      Offset(160, 200),
      Offset(280, 200),
    ];
  }
}