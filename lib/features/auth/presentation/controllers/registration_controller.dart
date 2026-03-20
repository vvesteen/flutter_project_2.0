import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../core/services/auth_service.dart';
import '../../domain/usecases/register_with_email_usecase.dart';
import '../../../../core/entities/UserEntity.dart';

import '../../../../core/errors/failure.dart';

class RegistrationController extends ChangeNotifier {
  final RegisterWithEmailUseCase registerUseCase;

  RegistrationController(this.registerUseCase);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final patronymicController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final sexController = TextEditingController();
  final phoneNumberController = TextEditingController();




  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> register(BuildContext context, String email, String password) async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    // Проверка длины пароля (уже была на первом экране, но можно оставить)
    if (password.trim().length < 6) {
      _errorMessage = 'Пароль должен быть не короче 6 символов';
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      // ← Используем метод из AuthService (он уже сохраняет в Firestore)
      final credential = await AuthService().registerWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
        name: nameController.text.trim(),
        surname: surnameController.text.trim(),
        patronymic: patronymicController.text.trim(),
        dateOfBirth: DateTime.parse(dateOfBirthController.text),
        sex: sexController.text.trim(),
        phoneNumber: phoneNumberController.text.trim(),

      );

      // Успех
      _isLoading = false;
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Регистрация успешна! Проверьте почту и папку "Спам"'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 6),
        ),
      );

      // Переход на главный экран
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }

    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();

      String msg;
      switch (e.code) {
        case 'email-already-in-use':
          msg = 'Этот email уже зарегистрирован';
          break;
        case 'invalid-email':
          msg = 'Некорректный формат email';
          break;
        case 'weak-password':
          msg = 'Пароль слишком слабый';
          break;
        default:
          msg = e.message ?? 'Ошибка регистрации';
      }

      _errorMessage = msg;
      notifyListeners();

    } catch (e) {
      _isLoading = false;
      notifyListeners();
      _errorMessage = 'Неизвестная ошибка: $e';
      notifyListeners();
    }
  }


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    //confirmPasswordController.dispose();
    nameController.dispose();
    surnameController.dispose();
    patronymicController.dispose();
    dateOfBirthController.dispose();
    sexController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }
}