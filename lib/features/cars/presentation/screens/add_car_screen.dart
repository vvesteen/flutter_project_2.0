import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/repositories/car_repository_impl.dart';
import '../../domain/entities/car.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({super.key});

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final Car _car = Car();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  Future<void> _saveCar() async {
    if (!_formKey.currentState!.validate() || !_car.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните все обязательные поля'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repository = CarRepositoryImpl();
      await repository.addCar(_car);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Машина успешно добавлена!'), backgroundColor: Colors.green),
      );

      Navigator.pop(context); // возвращаемся назад
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Добавить автомобиль')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Марка *'),
                onChanged: (v) => _car.carBrand = v.trim(),
                validator: (v) => v!.isEmpty ? 'Обязательное поле' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Модель *'),
                onChanged: (v) => _car.carModel = v.trim(),
                validator: (v) => v!.isEmpty ? 'Обязательное поле' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Цвет *'),
                onChanged: (v) => _car.carColor = v.trim(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Гос. номер *'),
                onChanged: (v) => _car.carNumber = v.trim().toUpperCase(),
                validator: (v) => v!.isEmpty ? 'Обязательное поле' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Год выпуска *'),
                keyboardType: TextInputType.number,
                onChanged: (v) => _car.carYearOfProduce = v.trim(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Количество мест *',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) => _car.numberOfSeats = int.tryParse(v) ?? 0,
                validator: (String? v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Обязательное поле';
                  }
                  final seats = int.tryParse(v.trim());
                  if (seats == null || seats < 1) {
                    return 'Минимум 1 место';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveCar,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Сохранить автомобиль'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}