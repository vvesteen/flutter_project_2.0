import '../../../../core/entities/Car.dart';
import '../repositories/car_repository.dart';

class VerifyAndAddCarUseCase {
  final CarRepository repository;

  VerifyAndAddCarUseCase(this.repository);

  Future<bool> call({
    required String plateNumber,
    required String brandModel,
    required int year,
  }) async {
    final isVerified = await repository.verifyCar(
      plateNumber: plateNumber,
      brandModel: brandModel,
      year: year,
    );

    if (isVerified) {
      final car = Car(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        plateNumber: plateNumber.toUpperCase(),
        brandModel: brandModel,
        year: year,
      );
      await repository.saveCar(car);
      return true;
    }
    return false;
  }
}