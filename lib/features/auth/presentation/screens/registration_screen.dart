import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/auth_service.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/register_with_email_usecase.dart';
import '../controllers/registration_controller.dart';


class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegistrationController>(
      create: (_) => RegistrationController(
        // Создаём цепочку зависимостей вручную
        RegisterWithEmailUseCase(
          AuthRepositoryImpl(
            AuthRemoteDataSource(
              AuthService(),
            ),
          ),
        ),
      ),
      child: Consumer<RegistrationController>(
        builder: (context, controller, child) {
          return Scaffold(
            backgroundColor: const Color.fromRGBO(255, 200, 40, 1),
            body: Center(
              child: Container(
                width: 260,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(220, 220, 220, 1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),

                    const Text(
                      'Регистрация',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 20),

                    // Email
                    TextField(
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Введите email',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Пароль
                    TextField(
                      controller: controller.passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Введите пароль',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Подтверждение пароля
                    TextField(
                      controller: controller.confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Подтвердите пароль',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Ошибка
                    if (controller.errorMessage != null)
                      Text(
                        controller.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),

                    // Кнопка
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(255, 200, 40, 1),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

                      ),
                        // В RegistrationScreen, в onPressed кнопки «Продолжить»
                        onPressed: () {
                          final email = controller.emailController.text.trim();
                          final pass  = controller.passwordController.text.trim();

                          if (email.isEmpty || !email.contains('@')) {
                            // покажи ошибку
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Введите корректный email')),
                            );
                            return;
                          }

                          if (pass.length < 6) {
                            // ошибка
                            return;
                          }

                          Navigator.pushNamed(
                            context,
                            '/NameInputScreen',
                            arguments: {
                              'email': email,
                              'password': pass,
                            },
                          );
                        },
                      child: const Text(
                        'Продолжить',
                        style: TextStyle(fontWeight: FontWeight.bold, ),
                      ),
                    ),),

                    const SizedBox(height: 12),

                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/login_screen'),
                      child: const Text('Уже есть аккаунт? Войти'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}