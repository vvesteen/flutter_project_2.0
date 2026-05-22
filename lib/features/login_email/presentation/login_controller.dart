import 'package:flutter/material.dart';

import '../domain/usecases/login_usecase.dart';

class LoginController extends ChangeNotifier {

  final LoginWithEmailUseCase loginUseCase;

  LoginController(this.loginUseCase);

  // Text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> login() async {

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await loginUseCase(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    result.fold(
          (failure) {
        _errorMessage = failure.message;
      },
          (user) {
        _errorMessage = null;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}