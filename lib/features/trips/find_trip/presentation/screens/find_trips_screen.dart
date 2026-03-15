import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';
import 'package:flutter_project_2/features/trips/find_trip/data/repositories/trip_repository_impl.dart';
import 'package:flutter_project_2/features/trips/find_trip/domain/usecases/search_trips_usecase.dart';
import 'package:flutter_project_2/features/trips/find_trip/data/datasources/trip_remote_datasource.dart';
import 'package:flutter_project_2/features/trips/find_trip/domain/entities/trip.dart';
import 'package:flutter_project_2/features/trips/find_trip/presentation/widgets/trip_card.dart';

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

    final hasFilters = from.isNotEmpty || to.isNotEmpty || date != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск поездок'),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      backgroundColor: const Color.fromRGBO(255, 200, 40, 1),
      body: Column(
        children: [
          // Фильтры
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
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
                      context: context,
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
                      readOnly: true,
                      controller: TextEditingController(
                        text: date != null
                            ? DateFormat('dd.MM.yyyy').format(date)
                            : '',
                      ),
                      decoration: _inputDecoration('Дата (опционально)'),
                    ),
                  ),
                ),
                if (hasFilters)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () {
                        ref.read(searchFromProvider.notifier).state = '';
                        ref.read(searchToProvider.notifier).state = '';
                        ref.read(searchDateProvider.notifier).state = null;
                      },
                      icon: const Icon(Icons.clear, size: 18),
                      label: const Text('Очистить'),
                    ),
                  ),
              ],
            ),
          ),

          // Список поездок
          Expanded(
            child: tripsAsync.when(
              data: (trips) => trips.isEmpty
                  ? const Center(
                child: Text(
                  'Поездки не найдены\nПопробуйте изменить фильтры',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: trips.length,
                itemBuilder: (context, index) {
                  final trip = trips[index];
                  return TripCard(
                    trip: trip,
                    onTap: () {
                      // TODO: переход на экран деталей поездки
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Открыта поездка ${trip.from} → ${trip.to}')),
                      );
                    },
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Ошибка: $err')),
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
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}