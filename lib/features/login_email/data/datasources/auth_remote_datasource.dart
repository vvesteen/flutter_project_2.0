import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/entities/UserEntity.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _auth;

  AuthRemoteDataSource(this._auth);

  Future<UserEntity> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final firebaseUser = credential.user;
    if (firebaseUser == null) {
      throw Exception('Не удалось войти');
    }

    return UserEntity(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
    );
  }

// методы register, signOut, getCurrentUser и т.д.
}