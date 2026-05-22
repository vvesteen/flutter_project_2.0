import 'package:flutter/material.dart';
import 'package:flutter_project_2/features/trips/presentation/my_trips/screens/my_trips_screen.dart';

import '../profile/presentation/screens/user_profile_page.dart';
import '../trips/presentation/create_trip/screens/create_trip_screen.dart';
import '../trips/presentation/find_trip/screens/find_trips_screen.dart';
import 'bottom_nav_bar.dart';


class HomeWithBottomNav extends StatefulWidget {
  const HomeWithBottomNav({super.key});

  @override
  State<HomeWithBottomNav> createState() => _HomeWithBottomNavState();
}

class _HomeWithBottomNavState extends State<HomeWithBottomNav> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    MyTripsScreen(),
    CreateTripScreen(),
    FindTripsScreen(),
    //const Center(child: Text("Мой профиль")),
    UserProfilePage(),
    //const Center(child: Text("Аккаунт")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
