import 'package:flutter/material.dart';

class CarPlaceholder extends StatelessWidget {
  const CarPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      color: Colors.grey.shade200,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_car_filled_rounded, size: 64, color: Colors.grey),
            SizedBox(height: 12),
            Text('Фото автомобиля отсутствует', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}