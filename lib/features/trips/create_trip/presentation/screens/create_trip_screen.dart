// lib/features/create_trip/presentation/screens/create_trip_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../create_trip/domain/entities/trip.dart';
import '../controllers/create_trip_controller.dart';

class CreateTripScreen extends StatelessWidget {
  const CreateTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateTripController(),
      child: Consumer<CreateTripController>(
        builder: (context, controller, child) {
          return Scaffold(
            appBar: AppBar(title: const Text('Создать поездку')),
            body: Stepper(
              type: StepperType.vertical,
              currentStep: controller.currentStep,
              onStepContinue: () {
                if (controller.currentStep < _getSteps(context, controller).length - 1) {
                  controller.currentStep++;
                  controller.notifyListeners();
                }
              },
              onStepCancel: () {
                if (controller.currentStep > 0) {
                  controller.currentStep--;
                  controller.notifyListeners();
                } else {
                  Navigator.pop(context);
                }
              },
              controlsBuilder: (context, details) {
                final isLast = controller.currentStep == _getSteps(context, controller).length - 1;
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    children: [
                      if (controller.currentStep > 0)
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
              steps: _getSteps(context, controller),
            ),
          );
        },
      ),
    );
  }

  List<Step> _getSteps(BuildContext context, CreateTripController controller) {
    final dateFormat = DateFormat('dd MMMM yyyy, HH:mm', 'ru');

    return [
      // Шаг 1 – Маршрут
      Step(
        title: const Text('Маршрут'),
        content: Column(
          children: [
            TextFormField(
              controller: controller.fromController,
              decoration: const InputDecoration(labelText: 'Откуда *', border: OutlineInputBorder()),
              textCapitalization: TextCapitalization.sentences,
              onChanged: controller.updateFrom,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.toController,
              decoration: const InputDecoration(labelText: 'Куда *', border: OutlineInputBorder()),
              textCapitalization: TextCapitalization.sentences,
              onChanged: controller.updateTo,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: controller.addStop,
              icon: const Icon(Icons.add_location_alt),
              label: const Text('Добавить остановку'),
            ),
            if (controller.trip.stops.isNotEmpty) ...[
              const SizedBox(height: 8),
              ...controller.trip.stops.asMap().entries.map((e) {
                final idx = e.key;
                final stop = e.value;
                return ListTile(
                  title: Text(stop),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => controller.removeStop(idx),
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
        content: ListTile(
          title: Text(
            controller.trip.departureTime == null
                ? 'Выберите дату и время *'
                : dateFormat.format(controller.trip.departureTime!),
            style: TextStyle(color: controller.trip.departureTime == null ? Colors.grey : null),
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

            controller.setDepartureTime(DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            ));
          },
        ),
      ),

      // Шаг 3 – Места и цена
      Step(
        title: const Text('Места и цена'),
        content: Column(
          children: [
            DropdownButtonFormField<int>(
              value: controller.trip.freeSeats,
              decoration: const InputDecoration(labelText: 'Свободных мест'),
              items: List.generate(8, (i) => i + 1)
                  .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                  .toList(),
              onChanged: (v) => controller.setFreeSeats(v ?? 1),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: controller.trip.pricePerSeat?.toStringAsFixed(0),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Цена за место (сом) *',
                suffixText: 'сом',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) {
                final price = double.tryParse(v.replaceAll(' ', ''));
                controller.setPricePerSeat(price);
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
              value: controller.trip.preferences['smoking'] ?? false,
              onChanged: (v) => controller.togglePreference('smoking', v),
            ),
            SwitchListTile(
              title: const Text('Разговорчивый водитель'),
              value: controller.trip.preferences['talkative'] ?? true,
              onChanged: (v) => controller.togglePreference('talkative', v),
            ),
            SwitchListTile(
              title: const Text('Музыка в салоне'),
              value: controller.trip.preferences['music'] ?? true,
              onChanged: (v) => controller.togglePreference('music', v),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Комментарий, детали, багаж...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              onChanged: controller.updateDescription,
            ),
          ],
        ),
      ),

      // Шаг 5 – Предпросмотр + Публикация
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
                      '${controller.trip.from ?? "—"} → ${controller.trip.to ?? "—"}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      controller.trip.departureTime != null
                          ? dateFormat.format(controller.trip.departureTime!)
                          : 'Дата не выбрана',
                    ),
                    const SizedBox(height: 8),
                    Text('Мест: ${controller.trip.freeSeats}   •   ${controller.trip.pricePerSeat?.toStringAsFixed(0) ?? "?"} сом/чел'),
                    if (controller.trip.description?.isNotEmpty ?? false) ...[
                      const SizedBox(height: 12),
                      Text('Комментарий:\n${controller.trip.description}'),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            if (controller.isLoading)
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
                onPressed: () => controller.publishTrip(context),
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
    ];
  }
}