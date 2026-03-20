import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth; // ← алиас обязателен!

import '../../../../core/errors/failure.dart';
import '../../../../core/entities/UserEntity.dart';
import '../../../../core/entities/UserEntity.dart'; // ← маленькая 'u' в имени файла
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserEntity>> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String surname,
    required String patronymic,
    required DateTime dateOfBirth,
    required String sex,
    required String phoneNumber,
  }) async {
    try {
      final userCredential = await remoteDataSource.registerWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
        surname: surname,
        patronymic: patronymic,
        dateOfBirth: dateOfBirth,
        sex: sex,
        phoneNumber: phoneNumber,

      );

      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        return Left(ServerFailure(message: 'Пользователь не создан'));
      }

      final userEntity = UserEntity.fromFirebase(firebaseUser);
      return Right(userEntity);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Ошибка регистрации'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}