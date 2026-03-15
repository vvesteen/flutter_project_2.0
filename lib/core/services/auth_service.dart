import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ────────────────────────────────
  // Регистрация (уже есть, оставляем)
  // ────────────────────────────────
  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String surname,
    required String name,
    required String patronymic,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = credential.user;
      if (user == null) {
        throw Exception('Не удалось создать пользователя');
      }

      await _firestore.collection('users').doc(user.uid).set({
        'email': email.trim(),
        'name': name.trim(),
        'surname': surname.trim(),
        'patronymic': patronymic.trim(),
        'fullName': '${surname.trim()} ${name.trim()} ${patronymic.trim()}'.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await user.updateDisplayName('${surname.trim()} ${name.trim()}');

      await sendVerificationEmail();

      return credential;
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // ────────────────────────────────
  // Вход — новый метод
  // ────────────────────────────────
  Future<UserCredential> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = credential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'lastLogin': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendVerificationEmail() async {
    final user = _auth.currentUser;
    if (user == null || user.emailVerified) return;

    try {
      await user.sendEmailVerification();
    } catch (e) {
      print('Ошибка отправки верификации: $e');
    }
  }

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}