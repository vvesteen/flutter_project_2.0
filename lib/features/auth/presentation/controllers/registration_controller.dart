import 'package:flutter/material.dart';
import '../../../../core/services/auth_service.dart';
import '../../domain/usecases/register_with_email_usecase.dart';
import '../../../../core/errors/failure.dart';

class RegistrationController extends ChangeNotifier {
  final RegisterWithEmailUseCase registerUseCase;

  RegistrationController(this.registerUseCase);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> register(BuildContext context) async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    if (passwordController.text != confirmPasswordController.text) {
      _errorMessage = 'Пароли не совпадают';
      _isLoading = false;
      notifyListeners();
      return;
    }

    final result = await registerUseCase(
      email: emailController.text,
      password: passwordController.text,
    );

    _isLoading = false;
    notifyListeners();

    result.fold(
          (failure) {
        _errorMessage = failure.message;
        notifyListeners();
      },
          (user) async {  // ← добавь async, потому что будет await
        // Успех — отправляем письмо подтверждения
        await AuthService().sendVerificationEmail();  // ← вот сюда вставляем

        // Показываем сообщение пользователю
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Регистрация успешна! Проверьте почту и спам для подтверждения'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 5),
          ),
        );

        // Переход дальше
        Navigator.pushNamedAndRemoveUntil(context, '/enterName', (route) => false);
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}