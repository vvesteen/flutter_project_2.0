import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/services/auth_service.dart';
import 'package:dartz/dartz.dart';  // ← всегда package: для dartz

import '../../../../core/errors/failure.dart';               // 7 уровней вверх
import '../../domain/entities/UserEntity.dart';              // от data → domain
import '../../domain/repositories/auth_repository.dart';      // от data → domain
import '../datasources/auth_remote_datasource.dart';          // соседняя папка datasources

class AuthRemoteDataSource {
  final AuthService authService;

  AuthRemoteDataSource(this.authService);

  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await authService.registerWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}