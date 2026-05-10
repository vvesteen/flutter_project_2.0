// widgets/seat_selector.dart
import 'package:flutter/material.dart';
import '../../../../../features/seats/Seat.dart';

class SeatSelector extends StatelessWidget {
  final List<Seat> seats;
  final Function(Seat) onSeatSelected;
  final bool isDriverMode; // для водителя

  const SeatSelector({
    super.key,
    required this.seats,
    required this.onSeatSelected,
    this.isDriverMode = false,
  });

  @override
  Widget build(BuildContext context) {
    // Примерная схема на 4 места (1 водитель + 3 пассажира)
    // Можно расширить позже
    return Column(
      children: [
        // Передний ряд
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Водитель (слева)
            _buildSeat(seats[0], label: 'Водитель'),
            const SizedBox(width: 40),
            // Пассажир спереди
            if (seats.length > 1) _buildSeat(seats[1]),
          ],
        ),

        const SizedBox(height: 40),

        // Задний ряд (3 места)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (seats.length > 2) _buildSeat(seats[2]),
            const SizedBox(width: 12),
            if (seats.length > 3) _buildSeat(seats[3]),
            const SizedBox(width: 12),
            if (seats.length > 4) _buildSeat(seats[4]),
          ],
        ),

        const SizedBox(height: 20),
        const Text('Экран / Капот', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildSeat(Seat seat, {String? label}) {
    final isOccupied = seat.status != SeatStatus.free;

    return GestureDetector(
      onTap: isOccupied ? null : () => onSeatSelected(seat),
      child: Column(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: seat.color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: seat.status == SeatStatus.selected
                    ? Colors.orange
                    : Colors.grey.shade400,
                width: 2,
              ),
              boxShadow: [
                if (!isOccupied)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(2, 2),
                  ),
              ],
            ),
            child: Center(
              child: seat.status == SeatStatus.free
                  ? const Icon(Icons.event_seat, color: Colors.grey)
                  : Text(
                seat.status == SeatStatus.male ? 'M' : 'Ж',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          if (label != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(label, style: const TextStyle(fontSize: 12)),
            ),
        ],
      ),
    );
  }
}