import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_project_2/core/entities/UserEntity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../../../../core/errors/failure.dart';


class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> getCurrentUserProfile() async {
    try {
      final model = await remoteDataSource.getCurrentUser();
      return Right(model);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Ошибка Firestore'));
    } catch (e) {
      return Left(CacheFailure()); // или создайте свой тип ошибки
    }
  }
}