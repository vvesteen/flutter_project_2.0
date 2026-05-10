import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../seats/Seat.dart';
import '../../domain/entities/create_trip_model.dart';
import '../../domain/repositories/trip_repository.dart';

class CreateTripController extends ChangeNotifier {
  final TripRepository repository;

  CreateTripController({required this.repository});

  int currentStep = 0;

  CreateTripModel model = CreateTripModel();

  final fromController = TextEditingController();
  final toController = TextEditingController();
  final descriptionController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  // 📍 обновления
  void updateFrom(String v) {
    model.from = v;
    notifyListeners();
  }

  void updateTo(String v) {
    model.to = v;
    notifyListeners();
  }

  void setDate(DateTime date) {
    model.departureTime = date;
    notifyListeners();
  }

  void setSeats(int v) {
    model.freeSeats = v;
    notifyListeners();
  }

  void setPrice(double v) {
    model.pricePerSeat = v;
    notifyListeners();
  }

  void updateDescription(String v) {
    model.description = v;
    notifyListeners();
  }

  void updatePreference(String key, bool value) {
    model.preferences[key] = value;
    notifyListeners();
  }

  void addStop() {
    model.stops.add('Остановка ${model.stops.length + 1}');
    notifyListeners();
  }

  void removeStop(int index) {
    model.stops.removeAt(index);
    notifyListeners();
  }

  // 🚀 публикация
  Future<void> publishTrip(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      errorMessage = 'Пользователь не авторизован';
      notifyListeners();
      return;
    }

    if (model.from == null ||
        model.to == null ||
        model.departureTime == null ||
        model.pricePerSeat == null) {
      errorMessage = 'Заполните обязательные поля';
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await repository.createTrip(model, user.uid);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Поездка создана'),
          backgroundColor: Colors.green,
        ),
      );

      // reset
      model = CreateTripModel();
      fromController.clear();
      toController.clear();
      descriptionController.clear();

      currentStep = 0;
    } catch (e) {
      errorMessage = 'Ошибка: $e';
    }

    isLoading = false;
    notifyListeners();
  }
  List<Seat> generateSeats(int count) {
    return List.generate(count, (index) {
      return Seat(
        index: index,
        status: SeatStatus.free,
        userId: null,
      );
    });
  }

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}