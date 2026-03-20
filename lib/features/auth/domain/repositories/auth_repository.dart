import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/entities/UserEntity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String surname,
    required String patronymic,
    required DateTime dateOfBirth,
    required String sex,
    required String phoneNumber
  });
}