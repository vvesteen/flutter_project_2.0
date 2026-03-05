
import 'package:flutter/material.dart';
import 'package:flutter_project_2/features/profile/presentation/profile_data.dart';
import 'package:flutter_project_2/features/trips/presentation/Create_trip_screen.dart';
import 'package:flutter_project_2/features/trips/presentation/find_trip.dart';
import 'package:flutter_project_2/registration/EnterCode.dart';
import 'package:flutter_project_2/registration/EnterName.dart';
import 'package:flutter_project_2/registration/login_screen.dart';
import 'package:flutter_project_2/features/auth/presentation/registration_screen.dart';
import 'features/widgets/home_with_bottom_nav.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart'; // если используешь Firebase
import 'firebase_options.dart';  // ← этот импорт обязателен!


// ← Добавь свой сгенерированный файл конфигурации Firebase
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


// Инициализация Firebase (если используешь)
// await Firebase.initializeApp(
//   options: DefaultFirebaseOptions.currentPlatform,
// );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,  // ← это фиксит null на web и работает везде
  );
// Очень важно для DateFormat с 'ru' (и других локалей)
  await initializeDateFormatting('ru'); // русский язык — месяцы будут «февраля», «марта» и т.д.

// Если планируешь поддерживать кыргызский язык позже:
// await initializeDateFormatting('ky'); // пока поддержка слабая, но можно попробовать

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Попутчики Кыргызстан', // можно поменять на своё
      theme: ThemeData(
        primarySwatch: Colors.green, // или другой цвет, который тебе нравится
        useMaterial3: true,
      ),
      initialRoute: '/login_screen',
      routes: {
        '/login_screen': (context) =>  LoginScreen(),
        '/registration': (context) =>  RegistrationScreen(),
        '/enterName': (context) =>  Entername(),
        '/home': (context) =>  HomeWithBottomNav(),
        '/findTrip': (context) => FindTrip(),
        '/createTrip': (context) =>  CreateTripScreen(),
        '/profile' : (context) => UserProfileScreen(),
          '/enterCode': (context) =>  Entercode(),          // ← добавь это
          // '/enterPhone': (context) => const EnterPhoneScreen(), // если есть экран

      },
    );
  }
}

