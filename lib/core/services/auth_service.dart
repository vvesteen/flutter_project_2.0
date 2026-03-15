import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ← добавь этот импорт

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // ← добавляем

  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String surname,
    required String name,
    required String patronymic,
  }) async {
    try {
      // 1. Создаём пользователя в Authentication
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = credential.user;
      if (user == null) {
        throw Exception('Не удалось создать пользователя');
      }

      // 2. Сразу создаём / обновляем документ в Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'email': email.trim(),
        'name': name.trim(),
        'surname': surname.trim(),
        'patronymic': patronymic.trim(),
        'fullName': '${surname.trim()} ${name.trim()} ${patronymic.trim()}'.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        // можно добавить позже: 'photoUrl': '', 'phone': '', 'role': 'user' и т.д.
      }, SetOptions(merge: true)); // merge: true — безопасно, не затрёт другие поля

      // Опционально: обновляем displayName в Authentication (удобно для списков, аватарок и т.д.)
      await user.updateDisplayName('${surname.trim()} ${name.trim()}');

      // 3. Отправляем верификацию email (у тебя уже есть метод)
      await sendVerificationEmail();

      return credential;
    } on FirebaseAuthException catch (e) {
      // здесь можно обработать конкретные ошибки (weak-password, email-already-in-use и т.д.)
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendVerificationEmail() async {
    final user = _auth.currentUser;
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
      print('Ошибка отправки верификации: $e');
    }
  }

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}