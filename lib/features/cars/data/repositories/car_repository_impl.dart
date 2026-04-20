// lib/features/create_trip/data/repositories/trip_repository_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/car.dart';
import '../../domain/repositories/car_repository.dart';

class CarRepositoryImpl implements CarRepository{
  final FirebaseFirestore _firestore;

  CarRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> addCar(Car car) async {
    await _firestore.collection('Cars').add(car.toMap());
    // или .doc(customId).set(...) если нужен свой ID
  }
}