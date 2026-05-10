import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'Мои поездки',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle),
          label: 'Создать поездку',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Поиск поездок',
        ),
      //  BottomNavigationBarItem(
        //  icon: Icon(CupertinoIcons.map_pin_ellipse),
          //label: 'Карта',
        //),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Профиль',
        ),
       // BottomNavigationBarItem(
         // icon: Icon(Icons.account_circle),
          //label: 'Аккаунт',
        //),
      ],
    );
  }
}
