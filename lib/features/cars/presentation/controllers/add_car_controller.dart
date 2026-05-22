import 'package:flutter/material.dart';
import '../../domain/usecases/VerifyAndAddCarUseCase.dart';

class AddCarController extends ChangeNotifier {
  final VerifyAndAddCarUseCase verifyAndAddCarUseCase;

  AddCarController({required this.verifyAndAddCarUseCase});
  bool isLoading = false;
  String? errorMessage;

  Future<void> verifyAndAdd({
    required String plate,
    required String brandModel,
    required int year,
    required BuildContext context,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final success = await verifyAndAddCarUseCase.call(
        plateNumber: plate,
        brandModel: brandModel,
        year: year,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Машина успешно добавлена и подтверждена ✓')),
        );
        Navigator.pop(context, true); // возвращаем успех
      } else {
        errorMessage = 'Проверьте введенные данные машины';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage!), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      errorMessage = 'Ошибка при проверке';
    }

    isLoading = false;
    notifyListeners();
  }
}