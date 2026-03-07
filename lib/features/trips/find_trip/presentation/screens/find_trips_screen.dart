

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';
import 'package:flutter_project_2/features/trips/find_trip/data/repositories/trip_repository_impl.dart';
import 'package:flutter_project_2/features/trips/find_trip/domain/usecases/search_trips_usecase.dart';
import 'package:flutter_project_2/features/trips/find_trip/data/datasources/trip_remote_datasource.dart';
import 'package:flutter_project_2/features/trips/find_trip/domain/entities/trip.dart';



final searchTripsUseCaseProvider = Provider<SearchTripsUseCase>((ref) {
  final repo = TripRepositoryImpl(TripRemoteDataSource());
  return SearchTripsUseCase(repo);
});

final searchFromProvider = StateProvider<String>((ref) => '');
final searchToProvider = StateProvider<String>((ref) => '');
final searchDateProvider = StateProvider<DateTime?>((ref) => null);

final filteredTripsProvider = StreamProvider<List<Trip>>((ref) {
  final useCase = ref.watch(searchTripsUseCaseProvider);
  final from = ref.watch(searchFromProvider);
  final to = ref.watch(searchToProvider);
  final date = ref.watch(searchDateProvider);

  return useCase(from: from, to: to, date: date);
});

class FindTripsScreen extends ConsumerWidget {
  const FindTripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final from = ref.watch(searchFromProvider);
    final to = ref.watch(searchToProvider);
    final date = ref.watch(searchDateProvider);
    final tripsAsync = ref.watch(filteredTripsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Поиск поездок'), backgroundColor: Colors.orange),
      backgroundColor: const Color.fromRGBO(255, 200, 40, 1),
      body: Column(
        children: [
          // Фильтры
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  decoration: _inputDecoration('Откуда'),
                  onChanged: (v) => ref.read(searchFromProvider.notifier).state = v,
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: _inputDecoration('Куда'),
                  onChanged: (v) => ref.read(searchToProvider.notifier).state = v,
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,  // ← обязательно добавить!
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );

                    if (picked != null && context.mounted) {
                      ref.read(searchDateProvider.notifier).state = picked;
                    }
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      controller: TextEditingController(
                        text: ref.watch(searchDateProvider) != null
                            ? DateFormat('dd.MM.yyyy').format(ref.watch(searchDateProvider)!)
                            : '',
                      ),
                      decoration: _inputDecoration('Дата (опционально)'),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: tripsAsync.when(
              data: (trips) => trips.isEmpty
                  ? const Center(child: Text('Поездки не найдены'))
                  : ListView.builder(
                itemCount: trips.length,
                itemBuilder: (ctx, i) {
                  final trip = trips[i];
                  return Card(
                    child: ListTile(
                      title: Text('${trip.from} → ${trip.to}'),
                      subtitle: Text(
                        '${DateFormat('dd.MM.yyyy HH:mm').format(trip.departureTime)}\n'
                            '${trip.freeSeats} мест • ${trip.pricePerSeat?.toStringAsFixed(0) ?? '?'} сом',
                      ),
                      onTap: () {
                        // Переход к деталям
                      },
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, st) => Center(child: Text('Ошибка: $err')),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
    );
  }
}