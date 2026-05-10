import 'package:dartz/dartz.dart';

import '../../../../core/entities/UserEntity.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/profile_repository.dart';

class UpdateUserProfile {
  final ProfileRepository repository;

  UpdateUserProfile(this.repository);

  Future<Either<Failure, void>> call(UserEntity user) {
    return repository.updateUserProfile(user);
  }
}