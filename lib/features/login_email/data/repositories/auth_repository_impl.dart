import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/errors/failure.dart';
import '../datasources/auth_remote_datasource.dart';
import 'package:flutter_project_2/features/login_email/domain/repositories/auth_repository.dart';
import '../../domain/entities/user_entity.dart';



class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserEntity>> loginWithEmailAndPassword({
    required String email,
    required String password,

  }) async {
    try {
      final user = await remoteDataSource.loginWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        return Left(InvalidCredentialsFailure());
      }
      return Left(ServerFailure(message: 'Ошибка сервера'));
    } catch (e) {
      return Left(UnexpectedFailure());
    }
  }
}