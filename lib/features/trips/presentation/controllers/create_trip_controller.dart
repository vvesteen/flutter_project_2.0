import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/entities/car_seat_layout.dart';
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

  void addStop() {
    model.stops.add('');
    notifyListeners();
  }

  void removeStop(int index) {
    model.stops.removeAt(index);
    notifyListeners();
  }

  void updatePreference(String key, bool value) {
    model.preferences[key] = value;
    notifyListeners();
  }

  // 👇 ВОТ СЮДА ВСТАВЛЯЕШЬ
  void setLayout(CarSeatLayout layout) {
    model.layout = layout;
    notifyListeners();
  }
  String? validateTrip() {
    if (model.from == null || model.from!.trim().isEmpty) {
      return 'Введите пункт отправления';
    }

    if (model.to == null || model.to!.trim().isEmpty) {
      return 'Введите пункт назначения';
    }

    if (model.departureTime.isBefore(DateTime.now())) {
      return 'Дата не может быть в прошлом';
    }

    if (model.freeSeats <= 0) {
      return 'Количество мест должно быть больше 0';
    }

    if (model.pricePerSeat == null) {
      return 'Введите цену';
    }

    if (model.pricePerSeat! < 0) {
      return 'Цена не может быть отрицательной';
    }

    if (model.description != null &&
        model.description!.length > 150) {
      return 'Слишком длинное описание. Сократите текст';
    }

    return null;
  }

  // 🚀 публикация
  Future<void> publishTrip(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      errorMessage = 'Пользователь не авторизован';
      notifyListeners();
      return;
    }

    // === Проверки для тестов ===
    if (model.from == null || model.from!.trim().isEmpty) {
      errorMessage = 'Введите пункт отправления';
    } else if (model.to == null || model.to!.trim().isEmpty) {
      errorMessage = 'Введите пункт назначения';
    } else if (model.departureTime.isBefore(DateTime.now())) {
      errorMessage = 'Дата не может быть в прошлом';
    } else if (model.freeSeats <= 0) {
      errorMessage = 'Количество мест должно быть больше 0';
    } else if ((model.pricePerSeat ?? 0) < 0) {
      errorMessage = 'Цена не может быть отрицательной';
    } else if (model.description != null && model.description!.length > 150) {
      errorMessage = 'Слишком длинное описание. Сократите текст';
    }

    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage!)),
      );
      notifyListeners();
      return;
    }

    // 🟢 предотвращение двойного создания
    if (isLoading) return;
    isLoading = true;

    try {
      await repository.createTrip(model, user.uid);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Поездка успешно создана')),
      );
      model = CreateTripModel();
      fromController.clear();
      toController.clear();
      descriptionController.clear();
      currentStep = 0;
    } catch (e) {
      errorMessage = 'Ошибка: $e';
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage!)));
    }

    isLoading = false;
    notifyListeners();
  }

}