import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/errors/failure.dart'; // если используешь Failure, иначе можно убрать

class LoginController extends ChangeNotifier {
  // Контроллеры полей
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> login(BuildContext context) async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _errorMessage = 'Заполните все поля';
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      // Вызов сервиса (как в твоём примере)
      await AuthService().loginWithEmailAndPassword(
        email: email,
        password: password,
      );

      _isLoading = false;
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Вход выполнен успешно'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        // или '/enterCode', если нужно именно этот маршрут
      }
    } on FirebaseAuthException catch (e) {
      _isLoading = false;

      String msg;
      switch (e.code) {
        case 'user-not-found':
          msg = 'Пользователь не найден';
          break;
        case 'wrong-password':
          msg = 'Неверный пароль';
          break;
        case 'invalid-email':
          msg = 'Некорректный формат email';
          break;
        case 'user-disabled':
          msg = 'Аккаунт заблокирован';
          break;
        default:
          msg = e.message ?? 'Ошибка входа';
      }

      _errorMessage = msg;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Неизвестная ошибка: $e';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}