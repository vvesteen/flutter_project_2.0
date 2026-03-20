import 'package:dartz/dartz.dart';
import 'package:flutter_project_2/core/entities/UserEntity.dart';
import '../repositories/profile_repository.dart';
import '../../../../core/errors/failure.dart';

class GetCurrentUserProfile {
  final ProfileRepository repository;

  GetCurrentUserProfile(this.repository);

  Future<Either<Failure, UserEntity>> call() {
    return repository.getCurrentUserProfile();
  }
}