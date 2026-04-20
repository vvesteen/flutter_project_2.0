// lib/features/create_trip/domain/repositories/trip_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/car.dart';

abstract class CarRepository {
  Future<void> addCar(Car car);
}