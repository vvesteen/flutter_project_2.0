import 'package:dartz/dartz.dart';
import 'package:flutter_project_2/features/profile/domain/repositories/profile_repository.dart';

import '../../../../core/entities/UserEntity.dart';
import '../../../../core/errors/failure.dart';
import '../../data/datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> getCurrentUserProfile() async {
    try {
      final model = await remoteDataSource.getCurrentUser();
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserProfile(UserEntity user) async {
    try {
      await remoteDataSource.updateUser(user);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}