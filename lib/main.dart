import 'package:flutter/material.dart';
import 'package:flutter_project_2/features/trips/presentation/find_trip.dart';
import 'package:flutter_project_2/registration/EnterCode.dart';
import 'package:flutter_project_2/registration/EnterName.dart';
import 'package:flutter_project_2/registration/EnterPhoneNumber.dart';
import 'features/widgets/home_with_bottom_nav.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      },
    );
  }
}