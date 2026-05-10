import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../data/datasources/trip_remote_datasource.dart';
import '../../../data/repositories/trip_repository_impl.dart';
import '../../controllers/create_trip_controller.dart';


class CreateTripScreen extends StatelessWidget {
  const CreateTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateTripController(
        repository: TripRepositoryImpl(
          remoteDataSource: TripRemoteDataSource(),
        ),
      ),      child: const _CreateTripView(),
    );
  }
}

class _CreateTripView extends StatelessWidget {
  const _CreateTripView();

  @override
  Widget build(BuildContext context) {
    final c = context.watch<CreateTripController>();
    final t = c.model;


    return Scaffold(
      appBar: AppBar(title: const Text('Создать поездку')),
      body: Stepper(
        currentStep: c.currentStep,
        onStepContinue: () {
          if (c.currentStep < 4) {
            c.currentStep++;
            c.notifyListeners();
          }
        },
        onStepCancel: () {
          if (c.currentStep > 0) {
            c.currentStep--;
            c.notifyListeners();
          }
        },
        steps: [
          Step(
            title: const Text('Маршрут'),
            content: Column(
              children: [
                TextField(
                  controller: c.fromController,
                  decoration: const InputDecoration(labelText: 'Откуда'),
                  onChanged: c.updateFrom,
                ),
                TextField(
                  controller: c.toController,
                  decoration: const InputDecoration(labelText: 'Куда'),
                  onChanged: c.updateTo,
                ),
                ElevatedButton(
                  onPressed: c.addStop,
                  child: const Text('Добавить остановку'),
                ),
                ...t.stops.asMap().entries.map((e) {
                  return ListTile(
                    title: Text(e.value),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => c.removeStop(e.key),
                    ),
                  );
                }),
              ],
            ),
          ),

          Step(
            title: const Text('Дата'),
            content: ListTile(
              title: Text(DateFormat('dd.MM.yyyy HH:mm')
                  .format(t.departureTime)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  initialDate: DateTime.now(),
                );

                if (date != null) {
                  c.setDate(date);
                }
              },
            ),
          ),

          Step(
            title: const Text('Места'),
            content: Column(
              children: [
                DropdownButton<int>(
                  value: t.freeSeats,
                  items: List.generate(
                    8,
                        (i) => DropdownMenuItem(
                      value: i + 1,
                      child: Text('${i + 1}'),
                    ),
                  ),
                  onChanged: (v) => c.setSeats(v ?? 1),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Цена'),
                  onChanged: (v) =>
                      c.setPrice(double.tryParse(v) ?? 0),
                ),
              ],
            ),
          ),

          Step(
            title: const Text('Дополнительно'),
            content: Column(
              children: [
                SwitchListTile(
                  title: const Text('Курение'),
                  value: t.preferences['smoking'] ?? false,
                  onChanged: (v) =>
                      c.updatePreference('smoking', v),
                ),
                TextField(
                  controller: c.descriptionController,
                  decoration:
                  const InputDecoration(labelText: 'Описание'),
                  onChanged: c.updateDescription,
                ),
              ],
            ),
          ),

          Step(
            title: const Text('Публикация'),
            content: c.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () => c.publishTrip(context),
              child: const Text('Опубликовать'),
            ),
          ),
        ],
      ),
    );
  }
}