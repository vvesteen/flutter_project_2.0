import 'package:dartz/dartz.dart';
import '../../../../core/entities/UserEntity.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/entities/UserEntity.dart';


abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> loginWithEmailAndPassword({
    required String email,
    required String password,

  });
}