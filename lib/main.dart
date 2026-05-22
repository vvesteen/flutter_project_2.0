import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_project_2/features/trips/presentation/my_trips/screens/my_trips_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'core/di/injection_container.dart' as di;

import 'features/widgets/home_with_bottom_nav.dart';
import 'features/auth/presentation/screens/add_data_screen.dart';
import 'features/auth/presentation/screens/name_input_screen.dart';
import 'features/login_email/presentation/login_screen.dart';
import 'features/profile/presentation/screens/user_profile_page.dart';
import 'features/trips/presentation/create_trip/screens/create_trip_screen.dart';
import 'features/trips/presentation/find_trip/screens/find_trips_screen.dart';
import 'features/cars/presentation/screens/add_car_screen.dart';
import 'l10n/app_localizations.dart';
import 'registration/EnterCode.dart';
import 'features/auth/presentation/screens/registration_screen.dart';

final localeProvider = StateProvider<Locale>((ref) => const Locale('ru'));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDateFormatting('ru');

  await di.initDependencies();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      locale: locale,

      supportedLocales: const [
        Locale('ru'),
        Locale('ky'),
        Locale('en'),
      ],

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      title: 'Попутчики Кыргызстан',

      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),

      initialRoute: '/login',

      routes: {
        '/NameInputScreen': (context) => const NameInputScreen(),
        '/registration': (context) => const RegistrationScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeWithBottomNav(),
        '/findTrip': (context) => const FindTripsScreen(),
        '/createTrip': (context) => const CreateTripScreen(),
        '/profile': (context) => const UserProfilePage(),
        '/enterCode': (context) => Entercode(),
        '/additional_data': (context) => const AddDataScreen(),
        '/add_car_screen': (context) => const AddCarScreen(),
        '/my_trips': (context) => const MyTripsScreen(),
      },
    );
  }
}