import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FindTrip extends StatefulWidget {
  const FindTrip({super.key});

  @override
  State<FindTrip> createState() => _FindTripState();
}

class _FindTripState extends State<FindTrip> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  DateTime? _selectedDate;

  List<Map<String, dynamic>> _allTrips = [];     // все planned поездки
  List<Map<String, dynamic>> _filteredTrips = []; // отфильтрованные
  bool _isLoading = true;
  StreamSubscription<DatabaseEvent>? _subscription;

  @override
  void initState() {
    super.initState();
    _listenToTrips();
  }

  void _listenToTrips() {
    final ref = FirebaseDatabase.instance.ref('Trips');

    _subscription = ref
        .orderByChild('status')
        .equalTo('planned')
        .onValue
        .listen((event) {
      setState(() => _isLoading = false);

      if (!event.snapshot.exists || event.snapshot.value == null) {
        _allTrips = [];
        _filteredTrips = [];
        return;
      }

      final data = event.snapshot.value as Map<dynamic, dynamic>;
      final List<Map<String, dynamic>> trips = [];

      data.forEach((key, value) {
        final trip = Map<String, dynamic>.from(value as Map);
        trip['id'] = key;
        if ((trip['freeSeats'] as num? ?? 0) > 0) {
          trips.add(trip);
        }
      });

      // Сортировка по departureTime (предполагаем, что это ISO строка)
      trips.sort((a, b) {
        final da = a['departureTime'] as String?;
        final db = b['departureTime'] as String?;
        if (da == null || db == null) return 0;
        return DateTime.parse(da).compareTo(DateTime.parse(db));
      });

      setState(() {
        _allTrips = trips;
        _filteredTrips = _filterTrips(trips); // применяем текущие фильтры
      });
    }, onError: (error) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки: $error')),
      );
    });
  }

  List<Map<String, dynamic>> _filterTrips(List<Map<String, dynamic>> trips) {
    final from = _fromController.text.trim().toLowerCase();
    final to = _toController.text.trim().toLowerCase();

    return trips.where((trip) {
      final tripFrom = (trip['from'] as String?)?.toLowerCase() ?? '';
      final tripTo = (trip['to'] as String?)?.toLowerCase() ?? '';

      bool matchFrom = from.isEmpty || tripFrom.contains(from);
      bool matchTo = to.isEmpty || tripTo.contains(to);

      bool matchDate = true;
      if (_selectedDate != null && trip['departureTime'] != null) {
        final tripDateStr = trip['departureTime'] as String;
        final tripDate = DateTime.tryParse(tripDateStr);
        if (tripDate != null) {
          matchDate = tripDate.year == _selectedDate!.year &&
              tripDate.month == _selectedDate!.month &&
              tripDate.day == _selectedDate!.day;
        }
      }

      return matchFrom && matchTo && matchDate;
    }).toList();
  }

  void _applyFilters() {
    setState(() {
      _filteredTrips = _filterTrips(_allTrips);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск поездок'),
        backgroundColor: Colors.orange,
      ),
      backgroundColor: const Color.fromRGBO(255, 200, 40, 1),
      body: SafeArea(
        child: Column(
          children: [
            // Фильтры (верхняя панель)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                children: [
                  TextField(
                    controller: _fromController,
                    decoration: _textFieldDecoration('Откуда'),
                    onChanged: (_) => _applyFilters(),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _toController,
                    decoration: _textFieldDecoration('Куда'),
                    onChanged: (_) => _applyFilters(),
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
                      if (picked != null && mounted) {
                        setState(() {
                          _selectedDate = picked;
                          _applyFilters();
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        controller: TextEditingController(
                          text: _selectedDate == null
                              ? ''
                              : DateFormat('dd.MM.yyyy').format(_selectedDate!),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Выбрать дату (опционально)',
                          prefixIcon: const Icon(Icons.calendar_today),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Список результатов
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredTrips.isEmpty
                  ? Center(
                child: Text(
                  _allTrips.isEmpty
                      ? 'Поездок пока нет'
                      : 'По вашему запросу ничего не найдено',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _filteredTrips.length,
                itemBuilder: (context, index) {
                  final trip = _filteredTrips[index];
                  final dateStr = trip['departureTime'] as String?;
                  final date = dateStr != null ? DateTime.tryParse(dateStr) : null;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: const Icon(Icons.directions_car, color: Colors.orange, size: 40),
                      title: Text(
                        '${trip['from'] ?? '?'} → ${trip['to'] ?? '?'}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (date != null)
                            Text(DateFormat('dd.MM.yyyy HH:mm').format(date)),
                          Text('${trip['freeSeats'] ?? 0} мест • ${trip['pricePerSeat'] ?? '?'} сом'),
                          if (trip['description'] != null && (trip['description'] as String).isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                trip['description'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                            ),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                      onTap: () {
                        // TODO: Навигация на детали поездки
                        // Navigator.push(context, MaterialPageRoute(builder: (_) => TripDetailScreen(tripId: trip['id'])));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Поездка ${trip['id']} выбрана')),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _textFieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: const Icon(Icons.search),
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }
}