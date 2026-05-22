import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/entities/Car.dart';
import '../../domain/repositories/car_repository.dart';
import '../datasources/tunduk_remote_datasource.dart';

class CarRepositoryImpl implements CarRepository {
  final TundukRemoteDataSource remoteDataSource;

  CarRepositoryImpl({required this.remoteDataSource});


  @override
  Future<bool> verifyCar({
    required String plateNumber,
    required String brandModel,
    required int year,
  }) async {
    final data = await remoteDataSource.checkVehicle(plateNumber);

    if (data == null) return false;

    final siteBrandRaw = data['markaModel']?.trim() ?? '';
    final siteYearRaw = data['year']?.trim() ?? '';

    if (siteBrandRaw.isEmpty || siteYearRaw.isEmpty) return false;

    final siteBrand = _normalize(siteBrandRaw);
    final userBrand = _normalize(brandModel);

    final yearsMatch = siteYearRaw == year.toString();

    // Лояльное сравнение бренда
    final brandMatches = siteBrand.contains(userBrand) ||
        userBrand.contains(siteBrand) ||
        siteBrand.split(' ').any((word) => userBrand.contains(word));

    return brandMatches && yearsMatch;
  }

// Вспомогательная функция
  String _normalize(String text) {
    return text
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'\s+'), ' '); // убираем лишние пробелы
  }


  @override
  Future<void> saveCar(Car car) async {
    // Сохраняем в Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('cars')
        .add({
      'plateNumber': car.plateNumber,
      'brandModel': car.brandModel,
      'year': car.year,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}