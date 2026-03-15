import 'package:dartz/dartz.dart';
import '../../../../../../core/errors/failure.dart';
import '../entities/UserEntity.dart';
import '../repositories/auth_repository.dart';

class RegisterWithEmailUseCase {
  final AuthRepository repository;

  RegisterWithEmailUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
    required String name,
    required String surname,
    required String patronymic
  }) async {
    return await repository.registerWithEmailAndPassword(
      email: email,
      password: password,
      name: name,
      surname: surname,
      patronymic: patronymic,
    );
  }
}