import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/auth_service.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/register_with_email_usecase.dart';
import '../controllers/registration_controller.dart';


class NameInputScreen extends StatelessWidget {
  const NameInputScreen({super.key});

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
                    const SizedBox(height: 12),


                    TextField(
                      controller: controller.nameController,
                      decoration: InputDecoration(
                        hintText: 'Имя',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),

                    const SizedBox(height: 12),


                    TextField(
                      controller: controller.surnameController,
                      decoration: InputDecoration(
                        hintText: 'Фамилия',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 12),


                    TextField(
                      controller: controller.patronymicController,
                      decoration: InputDecoration(
                        hintText: 'Отчество',
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
                        // В NameInputScreen → в onPressed «Зарегистрироваться»
                        onPressed: controller.isLoading ? null : () async {
                          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

                          final email    = args?['email']    as String? ?? '';
                          final password = args?['password'] as String? ?? '';

                          if (email.isEmpty || password.isEmpty) {
                            // критическая ошибка — email/пароль потерялись
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Ошибка: данные авторизации потеряны')),
                            );
                            return;
                          }

                          controller.register(context, email, password);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(255, 200, 40, 1),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: controller.isLoading
                            ? const CircularProgressIndicator(color: Colors.black)
                            : const Text('Зарегистрироваться', style: TextStyle(fontWeight: FontWeight.bold)),

                      ),
                    ),

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