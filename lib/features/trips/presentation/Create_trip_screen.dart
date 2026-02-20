import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../models/Trip.dart';

class CreateTripScreen extends StatefulWidget {

  const CreateTripScreen({super.key});



  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  int _currentStep = 0;
  final Trip _trip = Trip();

  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }



  Future<void> _publishTrip() async {
    if (!_trip.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Заполните все обязательные поля'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final dio = Dio();
      final response = await dio.post(
        'https://flutterapp2-3bb3d-default-rtdb.europe-west1.firebasedatabase.app/Trips.json',
        data: _trip.toMap(),
      );

      if (response.statusCode == 200) {
        print('Успех: ${response.data}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Поездка успешно опубликована!'),
            backgroundColor: Colors.green,
          ),
        );

        // Очистка формы после успеха (рекомендую)
        _fromController.clear();
        _toController.clear();
        _descriptionController.clear();
        setState(() {
          _trip.from = null;
          _trip.to = null;
          _trip.departureTime = null;
          _trip.pricePerSeat = null;
          _trip.description = null;
          _trip.stops.clear();
          _currentStep = 0;
        });

        // Navigator.pop(context); // ← раскомментируй, если хочешь закрывать экран
      } else {
        throw Exception('HTTP ошибка: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Ошибка при сохранении:');
      print(e);
      print(stackTrace);

      String message = 'Не удалось сохранить поездку';

      if (e.toString().contains('permission_denied')) {
        message = 'Нет прав на запись — проверьте правила Realtime Database';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<Step> _getSteps(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy, HH:mm', 'ru');

    return [
      // Шаг 1 – Маршрут
      Step(
        title: const Text('Маршрут'),
        content: Column(
          children: [
            TextFormField(
              controller: _fromController,
              decoration: const InputDecoration(
                labelText: 'Откуда *',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
              onChanged: (v) => _trip.from = v.trim(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _toController,
              decoration: const InputDecoration(
                labelText: 'Куда *',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
              onChanged: (v) => _trip.to = v.trim(),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _trip.stops.add('Остановка ${_trip.stops.length + 1}');
                });
              },
              icon: const Icon(Icons.add_location_alt),
              label: const Text('Добавить остановку'),
            ),
            if (_trip.stops.isNotEmpty) ...[
              const SizedBox(height: 8),
              ..._trip.stops.asMap().entries.map((e) {
                final idx = e.key;
                final stop = e.value;
                return ListTile(
                  title: Text(stop),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => setState(() => _trip.stops.removeAt(idx)),
                  ),
                );
              }),
            ],
          ],
        ),
      ),

      // Шаг 2 – Дата и время
      Step(
        title: const Text('Дата и время'),
        content: Column(
          children: [
            ListTile(
              title: Text(
                _trip.departureTime == null
                    ? 'Выберите дату и время *'
                    : dateFormat.format(_trip.departureTime!),
                style: TextStyle(
                  color: _trip.departureTime == null ? Colors.grey : null,
                ),
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final now = DateTime.now();
                final date = await showDatePicker(
                  context: context,
                  initialDate: now.add(const Duration(days: 1)),
                  firstDate: now,
                  lastDate: now.add(const Duration(days: 365)),
                );
                if (date == null) return;

                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(now),
                );
                if (time == null) return;

                setState(() {
                  _trip.departureTime = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    time.hour,
                    time.minute,
                  );
                });
              },
            ),
          ],
        ),
      ),

      // Шаг 3 – Места и цена
      Step(
        title: const Text('Места и цена'),
        content: Column(
          children: [
            DropdownButtonFormField<int>(
              value: _trip.freeSeats,
              decoration: const InputDecoration(labelText: 'Свободных мест'),
              items: List.generate(8, (i) => i + 1)
                  .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                  .toList(),
              onChanged: (v) => setState(() => _trip.freeSeats = v ?? 1),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _trip.pricePerSeat?.toStringAsFixed(0),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Цена за место (сом) *',
                suffixText: 'сом',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) {
                final price = double.tryParse(v.replaceAll(' ', ''));
                if (price != null && price > 0) {
                  _trip.pricePerSeat = price;
                }
              },
            ),
          ],
        ),
      ),

      // Шаг 4 – Дополнительно
      Step(
        title: const Text('Дополнительно'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Предпочтения:', style: TextStyle(fontWeight: FontWeight.w500)),
            SwitchListTile(
              title: const Text('Курение в машине'),
              value: _trip.preferences['smoking'] ?? false,
              onChanged: (v) => setState(() => _trip.preferences['smoking'] = v),
            ),
            SwitchListTile(
              title: const Text('Разговорчивый водитель'),
              value: _trip.preferences['talkative'] ?? true,
              onChanged: (v) => setState(() => _trip.preferences['talkative'] = v),
            ),
            SwitchListTile(
              title: const Text('Музыка в салоне'),
              value: _trip.preferences['music'] ?? true,
              onChanged: (v) => setState(() => _trip.preferences['music'] = v),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Комментарий, детали, багаж...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              onChanged: (v) => _trip.description = v.trim().isEmpty ? null : v.trim(),
            ),
          ],
        ),
      ),

      // Шаг 5 – Предпросмотр
      Step(
        title: const Text('Проверка'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_trip.from ?? "—"} → ${_trip.to ?? "—"}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _trip.departureTime != null
                          ? dateFormat.format(_trip.departureTime!)
                          : 'Дата не выбрана',
                    ),
                    const SizedBox(height: 8),
                    Text('Мест: ${_trip.freeSeats}   •   ${_trip.pricePerSeat?.toStringAsFixed(0) ?? "?"} сом/чел'),
                    if (_trip.description?.isNotEmpty ?? false) ...[
                      const SizedBox(height: 12),
                      Text('Комментарий:\n${_trip.description}'),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              ElevatedButton.icon(
                icon: const Icon(Icons.cloud_upload),
                label: const Text('Опубликовать поездку'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                ),
                onPressed: _publishTrip,
              ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Создать поездку'),
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < _getSteps(context).length - 1) {
            setState(() => _currentStep++);
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          } else {
            Navigator.pop(context);
          }
        },
        controlsBuilder: (context, details) {
          final isLast = _currentStep == _getSteps(context).length - 1;

          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: [
                if (_currentStep > 0)
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Назад'),
                  ),
                const Spacer(),
                if (!isLast)
                  FilledButton(
                    onPressed: details.onStepContinue,
                    child: const Text('Далее'),
                  ),
              ],
            ),
          );
        },
        steps: _getSteps(context),
      ),
    );
  }
}