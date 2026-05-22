import '../../../../core/entities/Car.dart';

abstract class CarRepository {
  Future<bool> verifyCar({
    required String plateNumber,
    required String brandModel,
    required int year,
  });

  Future<void> saveCar(Car car);
}