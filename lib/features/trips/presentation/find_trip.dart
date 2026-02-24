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

  List<Map<String, dynamic>> _foundTrips = [];
  bool _isLoading = false;

  Future<void> _searchTrips() async {
    final from = _fromController.text.trim();
    final to = _toController.text.trim();

    if (from.isEmpty || to.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Укажите "Откуда" и "Куда"')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _foundTrips = [];
    });

    try {
      final ref = FirebaseDatabase.instance.ref('Trips');

      // Получаем все активные поездки
      final snapshot = await ref
          .orderByChild('status')
          .equalTo('planned')
          .get();

      if (!snapshot.exists || snapshot.value == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Поездок пока нет')),
        );
        setState(() => _isLoading = false);
        return;
      }

      final data = snapshot.value as Map<dynamic, dynamic>;
      List<Map<String, dynamic>> trips = [];

      data.forEach((key, value) {
        final trip = Map<String, dynamic>.from(value as Map);

        bool match = true;

        // Фильтр по "from" (частично, регистронезависимо)
        final tripFrom = (trip['from'] as String?)?.toLowerCase() ?? '';
        if (!tripFrom.contains(from.toLowerCase())) match = false;

        // Фильтр по "to"
        final tripTo = (trip['to'] as String?)?.toLowerCase() ?? '';
        if (!tripTo.contains(to.toLowerCase())) match = false;

        // Фильтр по дате, если выбрана
        if (_selectedDate != null && trip['departureTime'] != null) {
          final tripDateStr = trip['departureTime'] as String?;
          if (tripDateStr != null) {
            final tripDate = DateTime.tryParse(tripDateStr);
            if (tripDate != null) {
              if (tripDate.year != _selectedDate!.year ||
                  tripDate.month != _selectedDate!.month ||
                  tripDate.day != _selectedDate!.day) {
                match = false;
              }
            }
          }
        }

        // Только поездки с местами
        if (match && (trip['freeSeats'] as int? ?? 0) > 0) {
          trip['id'] = key; // сохраняем ключ
          trips.add(trip);
        }
      });

      setState(() {
        _foundTrips = trips;
      });

      if (trips.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Поездки не найдены')),
        );
      }
    } catch (e) {
      print('Ошибка при поиске: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка поиска: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Карта / баннер
              Container(
                margin: const EdgeInsets.all(10),
                width: double.infinity,
                height: 260,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(220, 220, 220, 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(Icons.map_outlined, size: 120, color: Colors.grey),
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _fromController,
                      decoration: _textFieldDecoration('Откуда'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _toController,
                      decoration: _textFieldDecoration('Куда'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      readOnly: true,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setState(() => _selectedDate = picked);
                        }
                      },
                      decoration: InputDecoration(
                        hintText: _selectedDate == null
                            ? 'Выбрать дату'
                            : DateFormat('dd.MM.yyyy').format(_selectedDate!),
                        prefixIcon: const Icon(Icons.calendar_today),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _searchTrips,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                            : const Text(
                          'Найти поездки',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Результаты
              if (_foundTrips.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Найдено: ${_foundTrips.length}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _foundTrips.length,
                        itemBuilder: (context, index) {
                          final trip = _foundTrips[index];
                          final dateStr = trip['departureTime'] as String?;
                          final date = dateStr != null ? DateTime.tryParse(dateStr) : null;

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
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
                                    Text(
                                      trip['description'],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                ],
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                // TODO: переход на детали поездки
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Открыть поездку ${trip['id']}')),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              else if (!_isLoading && _foundTrips.isEmpty && _fromController.text.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(
                    child: Text(
                      'Поездки не найдены\nПопробуйте изменить запрос',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _textFieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: const Icon(Icons.search),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }
}