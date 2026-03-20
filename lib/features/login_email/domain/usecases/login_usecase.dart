import 'package:dartz/dartz.dart';
import '../../../../../../core/errors/failure.dart';
import 'package:flutter_project_2/features/login_email/domain/repositories/auth_repository.dart';
import '../../../../core/entities/UserEntity.dart';

class LoginWithEmailUseCase {
  final AuthRepository repository;

  LoginWithEmailUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,

  }) async {
    return await repository.loginWithEmailAndPassword(
      email: email,
      password: password,

    );
  }
}