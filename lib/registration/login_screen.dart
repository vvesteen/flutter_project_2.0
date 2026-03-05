import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {  // ← переименовал по конвенции (большая буква, без _)
  const LoginScreen({super.key});           // ← добавил const конструктор — хорошая практика

  @override
  Widget build(BuildContext context) {
    return Scaffold(                         // ← здесь return + сразу Scaffold
      backgroundColor: const Color.fromRGBO(255, 200, 40, 1), // жёлтый фон
      body: Center(
        child: Container(
          width: 260,
          height: 520,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(220, 220, 220, 1), // grey
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Логотип
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

              // Заголовок
              const Text(
                'Войти в аккаунт',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              // Подзаголовок
              const Text(
                'Для входа введите почту и пароль',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),

              const SizedBox(height: 15),

              // Поле ввода email
              TextField(
                decoration: InputDecoration(
                  hintText: 'Введите email',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),

              const SizedBox(height: 10),

              // Поле ввода пароля
              TextField(
                obscureText: true,  // ← добавил, чтобы пароль был скрыт
                decoration: InputDecoration(
                  hintText: 'Введите пароль',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),

              const SizedBox(height: 15),

              // Кнопка Войти
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(255, 200, 40, 1),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, '/enterCode', (route) => false);
                    // ↑ false лучше, чем true — полностью очищает стек, если это после логина
                  },
                  child: const Text(
                    'Войти',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Ссылка на регистрацию
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed('/registration'),
                child: const Text(
                  'Еще нет аккаунта? Регистрация',
                  textAlign: TextAlign.center,
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),

              const SizedBox(height: 8),

              // Сброс пароля
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
  }
}