import 'package:flutter/material.dart';
import 'package:flutter_project_2/features/profile/presentation/profile_data.dart';
import 'package:flutter_project_2/features/trips/presentation/Create_trip_screen.dart';
import 'package:flutter_project_2/features/trips/presentation/find_trip.dart';
import 'package:flutter_project_2/registration/EnterCode.dart';
import 'package:flutter_project_2/registration/EnterName.dart';
import 'package:flutter_project_2/registration/EnterPhoneNumber.dart';
import 'features/widgets/home_with_bottom_nav.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:flutter/material.dart';
import 'package:flutter_project_2/features/trips/presentation/Create_trip_screen.dart';
import 'package:flutter_project_2/features/trips/presentation/find_trip.dart';
import 'package:flutter_project_2/registration/EnterCode.dart';
import 'package:flutter_project_2/registration/EnterName.dart';
import 'package:flutter_project_2/registration/EnterPhoneNumber.dart';
import 'package:flutter_project_2/features/widgets/home_with_bottom_nav.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart'; // если используешь Firebase

// ← Добавь свой сгенерированный файл конфигурации Firebase
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Firebase (если используешь)
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

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
      initialRoute: '/enterPhone',
      routes: {
        '/enterPhone': (context) =>  Enterphonenumber(),
        '/enterCode': (context) =>  Entercode(),
        '/enterName': (context) =>  Entername(),
        '/home': (context) =>  HomeWithBottomNav(),
        '/findTrip': (context) => find_trip(),
        '/createTrip': (context) =>  CreateTripScreen(),
        '/profile' : (context) => UserProfileScreen(),
      },
    );
  }
}

/*
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key})a;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Убрали home — теперь управляем только через initialRoute и routes
      initialRoute: '/enterPhone',   // ← с этой страницы начинается приложение

      routes: {
        '/enterPhone': (context) =>  Enterphonenumber(),   // экран ввода номера
        '/enterCode':  (context) =>  Entercode(),    // экран ввода кода
        '/enterName':  (context) => Entername(),    // экран ввода имени
        '/home':       (context) => const HomeWithBottomNav(),
        '/findTrip':   (context) =>  find_trip(),
        '/createTrip': (context) => CreateTripScreen()
      },
    );
  }
}*/