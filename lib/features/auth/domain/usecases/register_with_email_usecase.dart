import 'package:dartz/dartz.dart';
import '../../../../../../core/errors/failure.dart';
import '../../../../core/entities/UserEntity.dart';
import '../repositories/auth_repository.dart';

class RegisterWithEmailUseCase {
  final AuthRepository repository;

  RegisterWithEmailUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
    required String name,
    required String surname,
    required String patronymic,
    required DateTime dateOfBirth,
    required String sex,
    required String phoneNumber
  }) async {
    return await repository.registerWithEmailAndPassword(
      email: email,
      password: password,
      name: name,
      surname: surname,
      patronymic: patronymic,
      dateOfBirth: dateOfBirth,
      sex: sex,
      phoneNumber: phoneNumber
    );
  }
}