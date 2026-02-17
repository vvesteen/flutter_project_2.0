import 'package:flutter/material.dart';
import 'package:flutter_project_2/features/trips/presentation/find_trip.dart';

import 'bottom_nav_bar.dart';


class HomeWithBottomNav extends StatefulWidget {
  const HomeWithBottomNav({super.key});

  @override
  State<HomeWithBottomNav> createState() => _HomeWithBottomNavState();
}

class _HomeWithBottomNavState extends State<HomeWithBottomNav> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const Center(child: Text("Мои поездки")),
    const Center(child: Text("Добавить поездку")),
    find_trip(),
    const Center(child: Text("Мой профиль")),
    const Center(child: Text("Аккаунт")),
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
