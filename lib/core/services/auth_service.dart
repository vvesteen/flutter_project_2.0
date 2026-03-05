import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }
  Future<void> sendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('Нет текущего пользователя');
      return;
    }

    if (user.emailVerified) {
      print('Email уже подтверждён');
      return;
    }

    try {
      await user.sendEmailVerification();
      print('Письмо отправлено на ${user.email}');
    } catch (e) {
      print('Ошибка отправки: $e');
    }
  }
  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}