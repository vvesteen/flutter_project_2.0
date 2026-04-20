import 'package:flutter/material.dart';
import 'package:flutter_project_2/features/auth/presentation/screens/add_data_screen.dart';
import 'package:flutter_project_2/features/auth/presentation/screens/name_input_screen.dart';
import 'package:flutter_project_2/features/trips/create_trip/Create_trip_screen.dart';
import 'package:flutter_project_2/features/trips/find_trip/find_trip.dart';
import 'package:flutter_project_2/registration/EnterCode.dart';
import 'package:flutter_project_2/features/login_email/presentation/login_screen.dart';
import 'package:flutter_project_2/features/auth/presentation/screens/registration_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/di/injection_container.dart' as di;
import 'features/cars/presentation/screens/add_car_screen.dart';
import 'features/profile/presentation/screens/user_profile_page.dart';
import 'features/widgets/home_with_bottom_nav.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('ru');


  await di.initDependencies();   // или sl.init() / setupLocator() — как у тебя называется
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Попутчики Кыргызстан',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/NameInputScreen': (context) =>  NameInputScreen(),
        '/registration': (context) =>  RegistrationScreen(),
        '/login': (context) =>  LoginScreen(),
        '/home': (context) =>  HomeWithBottomNav(),
        '/findTrip': (context) => FindTrip(),
        '/createTrip': (context) =>  CreateTripScreen(),
        '/profile' : (context) => UserProfilePage(),
          '/enterCode': (context) =>  Entercode(),
        '/additional_data': (context) => AddDataScreen(),
        '/add_car_screen': (context) => AddCarScreen(),
      },
    );
  }
}

