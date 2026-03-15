import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_project_2/features/trips/find_trip/domain/entities/trip.dart';

class TripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback? onTap;

  const TripCard({
    super.key,
    required this.trip,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');
    final price = trip.pricePerSeat?.toStringAsFixed(0) ?? '?';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      '${trip.from} → ${trip.to}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '$price сом',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Text(
                    dateFormat.format(trip.departureTime),
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.event_seat,
                        size: 18,
                        color: trip.freeSeats > 0 ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${trip.freeSeats} мест свободно',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: trip.freeSeats > 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  if (trip.stops != null && trip.stops!.isNotEmpty)
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 18, color: Colors.grey[600]),
                        const SizedBox(width: 6),
                        Text(
                          '${trip.stops!.length} остановок',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                ],
              ),
              // Место для будущих улучшений: предпочтения, рейтинг, фото водителя и т.д.
            ],
          ),
        ),
      ),
    );
  }
}