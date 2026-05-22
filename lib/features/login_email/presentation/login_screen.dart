import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../login_email/data/datasources/auth_remote_datasource.dart';
import '../../login_email/data/repositories/auth_repository_impl.dart';
import '../domain/usecases/login_usecase.dart';
import 'login_controller.dart'; // ← добавь зависимость provider в pubspec.yaml


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginController(
        LoginWithEmailUseCase(
          AuthRepositoryImpl(
            AuthRemoteDataSource(
              FirebaseAuth.instance,
            ),
          ),
        ),
      ),
      child: Consumer<LoginController>(
        builder: (context, controller, child) {
          return Scaffold(
            backgroundColor: const Color.fromRGBO(255, 200, 40, 1),
            body: Center(
              child: Container(
                width: 260,
                height: 520,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(220, 220, 220, 1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Логотип (без изменений)
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.yellow,
                        child: const Text(
                          'Sapar',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Войти в аккаунт',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Для входа введите почту и пароль',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),

                    const SizedBox(height: 15),

                    // Поле email
                    TextField(
                      controller: controller.emailController,
                      decoration: InputDecoration(
                        hintText: 'Введите email',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 10),

                    // Поле пароль
                    TextField(
                      controller: controller.passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Введите пароль',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Кнопка + индикация загрузки
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(255, 200, 40, 1),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: controller.isLoading
                            ? null
                            : () async {

                          await controller.login();

                          if (controller.errorMessage == null && context.mounted) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/home',
                                  (route) => false,
                            );
                          }
                        },                        child: controller.isLoading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                            : const Text(
                          'Войти',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Сообщение об ошибке
                    if (controller.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          controller.errorMessage!,
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    const SizedBox(height: 8),

                    TextButton(
                      onPressed: () => Navigator.of(context).pushNamed('/registration'),
                      child: const Text(
                        'Еще нет аккаунта? Регистрация',
                        textAlign: TextAlign.center,
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Сбросить пароль',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.black54),
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