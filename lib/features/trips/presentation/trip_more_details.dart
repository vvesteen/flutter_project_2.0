import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/entities/UserEntity.dart';
import '../../../core/entities/trip.dart';
import '../../widgets/seat_selector.dart';
import 'controllers/seat_booking_controller.dart';

class TripMoreDetails extends StatefulWidget {
  final Trip trip;

  const TripMoreDetails({
    super.key,
    required this.trip,
  });

  @override
  State<TripMoreDetails> createState() => _TripMoreDetailsState();
}

class _TripMoreDetailsState extends State<TripMoreDetails> {
  late Trip currentTrip;

  final seatController =
  SeatBookingController(FirebaseFirestore.instance);

  @override
  void initState() {
    super.initState();
    currentTrip = widget.trip;
  }

  Future<UserEntity?> _getDriver() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentTrip.driverId)
        .get();

    if (!doc.exists || doc.data() == null) return null;

    return UserEntity.fromMap(doc.data()!, doc.id);
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');
    final price = currentTrip.pricePerSeat.toStringAsFixed(0);

    return Scaffold(
      appBar: AppBar(
        title: Text('${currentTrip.from} → ${currentTrip.to}'),
      ),
      body: FutureBuilder<UserEntity?>(
        future: _getDriver(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final driver = snapshot.data;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// 👤 DRIVER
                if (driver != null)
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundImage: driver.photoUrl != null
                            ? NetworkImage(driver.photoUrl!)
                            : null,
                        child: driver.photoUrl == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        [
                          driver.surname,
                          driver.name,
                          driver.patronymic,
                        ].where((e) => e != null && e.isNotEmpty).join(' '),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                const SizedBox(height: 16),

                Text(
                  'Цена: $price сом',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 8),
                    Text(dateFormat.format(currentTrip.departureTime)),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    const Icon(Icons.event_seat),
                    const SizedBox(width: 8),
                    Text('Свободных мест: ${currentTrip.freeSeats}'),
                  ],
                ),

                const SizedBox(height: 24),

                /// 🪑 SEATS
                SeatSelector(
                  seats: currentTrip.seats,
                  onSeatSelected: (selectedSeat) async {
                    final userId = FirebaseAuth.instance.currentUser!.uid;

                    // Получаем пол пользователя
                    final userDoc = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .get();

                    final sex = userDoc.data()?['gender'] ?? userDoc.data()?['sex'] ?? 'male';

                    try {
                      final updatedSeats = await seatController.bookSeat(
                        trip: currentTrip,
                        seat: selectedSeat,
                        userId: userId,
                        sex: sex,
                      );

                      setState(() {
                        currentTrip = currentTrip.copyWith(seats: updatedSeats);
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Место забронировано')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ошибка бронирования: $e')),
                      );
                    }
                  },
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Подписаться'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}