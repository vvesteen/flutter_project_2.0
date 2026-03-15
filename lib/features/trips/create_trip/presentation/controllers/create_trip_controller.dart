// lib/features/create_trip/presentation/controllers/create_trip_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../create_trip/domain/entities/trip.dart';
import '../../../create_trip/domain/repositories/trip_repository.dart';
import '../../../create_trip//data/repositories/trip_repository_impl.dart'; // или через DI/GetIt

class CreateTripController extends ChangeNotifier {
  final TripRepository _repository;

  CreateTripController({TripRepository? repository})
      : _repository = repository ?? TripRepositoryImpl();

  int currentStep = 0;
  final Trip trip = Trip();

  final fromController = TextEditingController();
  final toController = TextEditingController();
  final descriptionController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  void updateFrom(String value) => trip.from = value.trim();
  void updateTo(String value) => trip.to = value.trim();
  void updateDescription(String value) =>
      trip.description = value.trim().isEmpty ? null : value.trim();

  void addStop() {
    trip.stops.add('Остановка ${trip.stops.length + 1}');
    notifyListeners();
  }

  void removeStop(int index) {
    trip.stops.removeAt(index);
    notifyListeners();
  }

  void setDepartureTime(DateTime? time) {
    trip.departureTime = time;
    notifyListeners();
  }

  void setFreeSeats(int seats) {
    trip.freeSeats = seats;
    notifyListeners();
  }

  void setPricePerSeat(double? price) {
    trip.pricePerSeat = price;
    notifyListeners();
  }

  void togglePreference(String key, bool value) {
    trip.preferences[key] = value;
    notifyListeners();
  }

// Убери import 'package:dio/dio.dart';


  Future<void> publishTrip(BuildContext context) async {
    if (!trip.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните все обязательные поля'), backgroundColor: Colors.red),
      );
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance.collection('trips').add({
        ...trip.toMap(),                             // твои поля
        'userId': user?.uid ?? 'anonymous',          // кто создал
        'userEmail': user?.email,                    // опционально
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Поездка успешно опубликована!'),
          backgroundColor: Colors.green,
        ),
      );

      // очистка формы
      fromController.clear();
      toController.clear();
      descriptionController.clear();
      trip.from = null;
      trip.to = null;
      trip.departureTime = null;
      trip.pricePerSeat = null;
      trip.description = null;
      trip.stops.clear();
      currentStep = 0;

      notifyListeners();

    } catch (e) {
      errorMessage = 'Не удалось сохранить поездку: $e';
      if (e.toString().contains('permission-denied')) {
        errorMessage = 'Нет прав на запись — проверьте правила Firestore';
      }
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}