import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/entities/UserEntity.dart';
import '../../../core/entities/trip.dart';
import '../../seats/Seat.dart';
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

  /// места для новой брони
  List<Seat> selectedSeats = [];

  /// места для отмены
  List<Seat> cancelSeats = [];

  int get totalPrice =>
      (selectedSeats.length * currentTrip.pricePerSeat).toInt();

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

  /// =========================
  /// БРОНИРОВАНИЕ
  /// =========================
  Future<void> _bookSelectedSeats() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final bookedCount = selectedSeats.length;
    final bookedTotal = totalPrice;

    List<Seat> updatedSeats = currentTrip.seats;

    for (final seat in selectedSeats) {
      updatedSeats = await seatController.bookSeat(
        trip: currentTrip.copyWith(seats: updatedSeats),
        seat: seat,
        userId: userId,
        sex: "male",
      );
    }

    setState(() {
      currentTrip = currentTrip.copyWith(
        seats: updatedSeats,
        freeSeats: currentTrip.freeSeats - bookedCount,
      );

      selectedSeats.clear();
    });

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Забронировано!'),
        content: Text(
          'Мест: $bookedCount\nСумма: $bookedTotal сом',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  /// =========================
  /// ОТМЕНА БРОНИ
  /// =========================
  Future<void> _cancelSelectedSeats() async {
    final userId =
        FirebaseAuth.instance.currentUser!.uid;

    final canceledCount = cancelSeats.length;

    final updatedSeats =
    currentTrip.seats.map((seat) {

      final shouldCancel = cancelSeats.any(
            (s) => s.index == seat.index,
      );

      if (shouldCancel) {
        return seat.copyWith(
          status: SeatStatus.free,

          clearUserId: true,
          clearGender: true,
        );
      }

      return seat;

    }).toList();

    final stillHasSeats = updatedSeats.any(
          (s) => s.userId == userId,
    );

    await FirebaseFirestore.instance
        .collection('trips')
        .doc(currentTrip.id)
        .update({

      'seats': updatedSeats
          .map((e) => e.toMap())
          .toList(),

      'freeSeats': FieldValue.increment(
        canceledCount,
      ),

      if (!stillHasSeats)
        'passengerIds': FieldValue.arrayRemove(
          [userId],
        ),
    });

    setState(() {

      currentTrip = currentTrip.copyWith(
        seats: updatedSeats,
        freeSeats:
        currentTrip.freeSeats + canceledCount,
      );

      cancelSeats.clear();
    });

    showDialog(
      context: context,
      builder: (_) => AlertDialog(

        title: const Text(
          'Бронь отменена',
        ),

        content: Text(
          'Освобождено мест: $canceledCount',
        ),

        actions: [

          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),

        ],
      ),
    );
  }

  void _showPassengerProfile(UserEntity user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),

      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [

              CircleAvatar(
                radius: 40,

                backgroundImage: user.photoUrl != null
                    ? NetworkImage(user.photoUrl!)
                    : null,

                child: user.photoUrl == null
                    ? const Icon(Icons.person, size: 40)
                    : null,
              ),

              const SizedBox(height: 16),

              Text(
                [
                  user.surname,
                  user.name,
                  user.patronymic,
                ]
                    .where((e) => e != null && e.isNotEmpty)
                    .join(' '),

                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                user.phoneNumber ??
                    'Телефон не указан',
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [

                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),

                  const SizedBox(width: 6),

                  Text(
                    user.rating.toStringAsFixed(1),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  child: const Text('Закрыть'),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final dateFormat =
    DateFormat('dd.MM.yyyy HH:mm');

    final price =
    currentTrip.pricePerSeat
        .toStringAsFixed(0);

    final isArchived =
    currentTrip.departureTime
        .isBefore(DateTime.now());

    final currentUserId =
        FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${currentTrip.from} → ${currentTrip.to}',
        ),
      ),

      body: FutureBuilder<UserEntity?>(
        future: _getDriver(),

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final driver = snapshot.data;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                /// 👤 DRIVER
                if (driver != null)
                  Row(
                    children: [

                      CircleAvatar(
                        radius: 22,

                        backgroundImage:
                        driver.photoUrl != null
                            ? NetworkImage(
                          driver.photoUrl!,
                        )
                            : null,

                        child:
                        driver.photoUrl == null
                            ? const Icon(Icons.person)
                            : null,
                      ),

                      const SizedBox(width: 10),

                      Text(
                        [
                          driver.surname,
                          driver.name,
                          driver.patronymic,
                        ]
                            .where((e) =>
                        e != null &&
                            e.isNotEmpty)
                            .join(' '),

                        style: const TextStyle(
                          fontWeight:
                          FontWeight.bold,
                        ),
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

                    const Icon(
                      Icons.calendar_today,
                    ),

                    const SizedBox(width: 8),

                    Text(
                      dateFormat.format(
                        currentTrip.departureTime,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [

                    const Icon(
                      Icons.event_seat,
                    ),

                    const SizedBox(width: 8),

                    Text(
                      'Свободных мест: ${currentTrip.freeSeats}',
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// 🪑 МЕСТА
                SeatSelector(

                  seats:
                  currentTrip.seats.map((seat) {

                    final selectedForBooking =
                    selectedSeats.any(
                          (s) =>
                      s.index ==
                          seat.index,
                    );

                    final selectedForCancel =
                    cancelSeats.any(
                          (s) =>
                      s.index ==
                          seat.index,
                    );

                    /// выбраны для брони
                    if (selectedForBooking) {
                      return seat.copyWith(
                        status:
                        SeatStatus.selected,
                      );
                    }

                    /// выбраны для отмены
                    if (selectedForCancel) {
                      return seat.copyWith(
                        status:
                        SeatStatus.withChild,
                      );
                    }

                    return seat;

                  }).toList(),

                  readOnly: isArchived,
                  layout: currentTrip.layout,

                  onSeatSelected: (seat) {

                    final isMySeat =
                        seat.userId ==
                            currentUserId;

                    setState(() {

                      /// МОИ МЕСТА
                      if (isMySeat) {

                        final exists =
                        cancelSeats.any(
                              (s) =>
                          s.index ==
                              seat.index,
                        );

                        if (exists) {

                          cancelSeats.removeWhere(
                                (s) =>
                            s.index ==
                                seat.index,
                          );

                        } else {

                          cancelSeats.add(seat);
                        }
                      }

                      /// СВОБОДНЫЕ
                      else if (
                      seat.status ==
                          SeatStatus.free) {

                        final exists =
                        selectedSeats.any(
                              (s) =>
                          s.index ==
                              seat.index,
                        );

                        if (exists) {

                          selectedSeats.removeWhere(
                                (s) =>
                            s.index ==
                                seat.index,
                          );

                        } else {

                          selectedSeats.add(seat);
                        }
                      }
                    });
                  },

                  onOccupiedSeatTap:
                      (seat) async {

                    final userId = seat.userId;

                    if (userId == null) return;

                    final doc =
                    await FirebaseFirestore
                        .instance
                        .collection('users')
                        .doc(userId)
                        .get();

                    if (!doc.exists) return;

                    final user =
                    UserEntity.fromMap(
                      doc.data()!,
                      doc.id,
                    );

                    _showPassengerProfile(user);
                  },
                ),

                /// 💰 СУММА
                if (selectedSeats.isNotEmpty)
                  Container(

                    padding:
                    const EdgeInsets.all(12),

                    margin:
                    const EdgeInsets.only(
                      top: 16,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,

                      borderRadius:
                      BorderRadius.circular(
                        12,
                      ),
                    ),

                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        Text(
                          'Выбрано мест: ${selectedSeats.length}',
                        ),

                        const SizedBox(height: 6),

                        Text(
                          'Итого: $totalPrice сом',

                          style:
                          const TextStyle(
                            fontSize: 18,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 24),

                /// ✅ БРОНЬ
                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(

                    onPressed:
                    selectedSeats.isEmpty
                        ? null
                        : () async {
                      await _bookSelectedSeats();
                    },

                    child: const Text(
                      'Забронировать',
                    ),
                  ),
                ),

                /// ❌ ОТМЕНА
                if (cancelSeats.isNotEmpty)
                  Padding(
                    padding:
                    const EdgeInsets.only(
                      top: 12,
                    ),

                    child: SizedBox(
                      width: double.infinity,

                      child: ElevatedButton(

                        style:
                        ElevatedButton
                            .styleFrom(
                          backgroundColor:
                          Colors.red,
                        ),

                        onPressed: () async {
                          await _cancelSelectedSeats();
                        },

                        child: const Text(
                          'Отменить бронь',
                        ),
                      ),
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