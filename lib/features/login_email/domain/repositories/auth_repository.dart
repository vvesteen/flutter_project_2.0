import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/user_entity.dart';
import '../entities/user_entity.dart';


abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> loginWithEmailAndPassword({
    required String email,
    required String password,

  });
}