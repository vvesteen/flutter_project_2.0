import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../controllers/add_car_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class AddCarScreen extends StatelessWidget {
  const AddCarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddCarController>(
      create: (_) => GetIt.instance<AddCarController>(),
      child: const _AddCarScreenContent(),
    );
  }
}

class _AddCarScreenContent extends StatefulWidget {
  const _AddCarScreenContent({super.key});

  @override
  State<_AddCarScreenContent> createState() => _AddCarScreenContentState();
}

class _AddCarScreenContentState extends State<_AddCarScreenContent> {
  final _plateController = TextEditingController();
  final _brandController = TextEditingController();
  final _yearController = TextEditingController();

  String? selectedSteering; // "left" или "right"

  @override
  void dispose() {
    _plateController.dispose();
    _brandController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  void _showSteeringBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Тип руля',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: const Text('Левый руль'),
                trailing: selectedSteering == 'left'
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  setState(() => selectedSteering = 'left');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Правый руль'),
                trailing: selectedSteering == 'right'
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  setState(() => selectedSteering = 'right');
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Future<void> _verifyAndAddCar() async {
    final controller = context.read<AddCarController>();

    if (_plateController.text.trim().isEmpty ||
        _brandController.text.trim().isEmpty ||
        _yearController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните все обязательные поля')),
      );
      return;
    }

    await controller.verifyAndAdd(
      plate: _plateController.text.trim(),
      brandModel: _brandController.text.trim(),
      year: int.tryParse(_yearController.text.trim()) ?? 0,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AddCarController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить автомобиль'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Проверка автомобиля через базу Тундук',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),

            // Госномер
            TextField(
              controller: _plateController,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: 'Государственный номер *',
                hintText: '07KG542ACZ',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.directions_car),
              ),
            ),
            const SizedBox(height: 16),

            // Марка и модель
            TextField(
              controller: _brandController,
              decoration: const InputDecoration(
                labelText: 'Марка и модель *',
                hintText: 'SETRA S315HD',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.branding_watermark),
              ),
            ),
            const SizedBox(height: 16),

            // Год выпуска
            TextField(
              controller: _yearController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Год выпуска *',
                hintText: '1998',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 16),

            // Выбор типа руля

// ...

        GestureDetector(
        onTap: _showSteeringBottomSheet,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(                  // ← Используй FaIcon вместо Icon
                Icons.adjust,
                size: 24,
                color: Colors.grey,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  selectedSteering == null
                      ? 'Тип руля *'
                      : selectedSteering == 'left'
                      ? 'Левый руль'
                      : 'Правый руль',
                  style: TextStyle(
                    fontSize: 16,
                    color: selectedSteering == null ? Colors.grey : Colors.black,
                  ),
                ),
              ),
              const Icon(Icons.arrow_drop_down),

            ],
          ),
        ),
      ),

            const SizedBox(height: 32),

            // Кнопка "Проверить и добавить"
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: controller.isLoading ? null : _verifyAndAddCar,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: controller.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  'Проверить и добавить',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            if (controller.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  controller.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}