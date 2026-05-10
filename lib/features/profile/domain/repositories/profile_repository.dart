import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/entities/UserEntity.dart';


abstract class ProfileRepository {
  Future<Either<Failure, UserEntity>> getCurrentUserProfile();
  Future<Either<Failure, void>> updateUserProfile(UserEntity user);
}