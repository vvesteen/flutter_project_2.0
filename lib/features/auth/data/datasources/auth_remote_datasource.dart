import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/services/auth_service.dart';
import 'package:dartz/dartz.dart';  // ← всегда package: для dartz

import '../../../../core/errors/failure.dart';               // 7 уровней вверх
import '../../../../core/entities/UserEntity.dart';              // от data → domain
import '../../domain/repositories/auth_repository.dart';      // от data → domain
import '../datasources/auth_remote_datasource.dart';          // соседняя папка datasources

class AuthRemoteDataSource {
  final AuthService authService;

  AuthRemoteDataSource(this.authService);

  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String surname,
    required String patronymic,
    required DateTime dateOfBirth,
    required String sex,
    required String phoneNumber,

  }) async {
    return await authService.registerWithEmailAndPassword(
      email: email,
      password: password,
      name: name,
      surname: surname,
      patronymic: patronymic,
      dateOfBirth: dateOfBirth,
      sex: sex,
      phoneNumber: phoneNumber,


    );
  }
}