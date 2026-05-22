// ===============================
// CREATE TRIP SCREEN
// ПОЛНОСТЬЮ ИСПРАВЛЕННЫЙ КОД
// ===============================

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../../core/entities/car_seat_layout.dart';
import '../../controllers/create_trip_controller.dart';
import '../../../data/repositories/trip_repository_impl.dart';
import '../../../data/datasources/trip_remote_datasource.dart';

class CreateTripScreen extends StatelessWidget {
  const CreateTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CreateTripController>(
      create: (_) => CreateTripController(
        repository: TripRepositoryImpl(
          remoteDataSource: TripRemoteDataSource(),
        ),
      ),
      child: const _CreateTripScreenContent(),
    );
  }
}

class _CreateTripScreenContent extends StatelessWidget {
  const _CreateTripScreenContent({super.key});

  @override
  Widget build(BuildContext context) {

    final c = context.watch<CreateTripController>();

    final t = c.model;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Создать поездку'),
        elevation: 0,
      ),

      body: Stack(
        children: [

          SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                /// =========================
                /// МАРШРУТ
                /// =========================

                _buildSection(
                  title: '📍 Маршрут',

                  child: Column(
                    children: [

                      TextField(
                        controller: c.fromController,

                        decoration: const InputDecoration(
                          labelText: 'Откуда *',
                          prefixIcon:
                          Icon(Icons.location_on_outlined),

                          border: OutlineInputBorder(),
                        ),

                        onChanged: c.updateFrom,
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: c.toController,

                        decoration: const InputDecoration(
                          labelText: 'Куда *',
                          prefixIcon:
                          Icon(Icons.flag_outlined),

                          border: OutlineInputBorder(),
                        ),

                        onChanged: c.updateTo,
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [

                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: c.addStop,

                              icon: const Icon(Icons.add),

                              label: const Text(
                                'Добавить остановку',
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      ...t.stops.asMap().entries.map((entry) {

                        final index = entry.key;

                        final stop = entry.value;

                        return Card(
                          margin:
                          const EdgeInsets.only(top: 8),

                          child: ListTile(
                            leading: const Icon(
                              Icons.pause_circle_outline,
                            ),

                            title: Text(stop),

                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),

                              onPressed: () {
                                c.removeStop(index);
                              },
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// =========================
                /// ДАТА И ВРЕМЯ
                /// =========================

                _buildSection(
                  title: '⏰ Дата и время',

                  child: Column(
                    children: [

                      Container(
                        padding: const EdgeInsets.all(12),

                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),

                          borderRadius:
                          BorderRadius.circular(12),
                        ),

                        child: Row(
                          children: [

                            const Icon(
                              Icons.calendar_today,
                            ),

                            const SizedBox(width: 12),

                            Text(
                              DateFormat(
                                'dd.MM.yyyy HH:mm',
                              ).format(
                                t.departureTime,
                              ),

                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        height: 200,

                        child: CupertinoDatePicker(
                          mode:
                          CupertinoDatePickerMode
                              .dateAndTime,

                          initialDateTime:
                          t.departureTime.isAfter(
                            DateTime.now(),
                          )
                              ? t.departureTime
                              : DateTime.now().add(
                            const Duration(
                              minutes: 10,
                            ),
                          ),

                          minimumDate:
                          DateTime.now(),

                          maximumDate:
                          DateTime.now().add(
                            const Duration(days: 365),
                          ),

                          use24hFormat: true,

                          onDateTimeChanged:
                          c.setDate,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// =========================
                /// МЕСТА И ЦЕНА
                /// =========================

                _buildSection(
                  title: '💰 Места и цена',

                  child: Column(
                    children: [

                      Row(
                        children: [

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,

                              children: [

                                const Text(
                                  'Свободных мест *',
                                ),

                                const SizedBox(height: 8),

                                DropdownButtonFormField<int>(
                                  value: t.freeSeats,

                                  decoration:
                                  const InputDecoration(
                                    border:
                                    OutlineInputBorder(),
                                  ),

                                  items: List.generate(
                                    8,

                                        (i) => DropdownMenuItem(
                                      value: i + 1,

                                      child: Text(
                                        '${i + 1}',
                                      ),
                                    ),
                                  ),

                                  onChanged: (v) {
                                    c.setSeats(v ?? 1);
                                  },
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,

                              children: [

                                const Text(
                                  'Цена за место (сом) *',
                                ),

                                const SizedBox(height: 8),

                                TextField(
                                  keyboardType:
                                  TextInputType.number,

                                  decoration:
                                  const InputDecoration(
                                    prefixText: '₸ ',
                                    border:
                                    OutlineInputBorder(),
                                  ),

                                  onChanged: (v) {

                                    c.setPrice(
                                      double.tryParse(v) ?? 0,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      /// =========================
                      /// СХЕМА МЕСТ
                      /// =========================

                      DropdownButtonFormField<CarSeatLayout>(
                        value: t.layout,

                        decoration: const InputDecoration(
                          labelText: 'Схема мест',
                          border: OutlineInputBorder(),
                        ),

                        items: const [

                          DropdownMenuItem(
                            value:
                            CarSeatLayout.sevenSeats,

                            child: Text('7 мест'),
                          ),

                          DropdownMenuItem(
                            value:
                            CarSeatLayout.eightSeats,

                            child: Text('8 мест'),
                          ),
                        ],

                        onChanged: (value) {

                          if (value != null) {
                            c.setLayout(value);
                          }
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// =========================
                /// ОПИСАНИЕ
                /// =========================

                _buildSection(
                  title: '📝 Описание',

                  child: TextField(
                    controller:
                    c.descriptionController,

                    decoration: const InputDecoration(
                      hintText:
                      'Расскажите о поездке...',

                      border: OutlineInputBorder(),
                    ),

                    onChanged:
                    c.updateDescription,

                    maxLength: 150,

                    maxLines: 4,
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),

          /// =========================
          /// КНОПКА СОЗДАТЬ
          /// =========================

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,

            child: Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.white,

                boxShadow: [

                  BoxShadow(
                    color:
                    Colors.black.withOpacity(0.1),

                    blurRadius: 8,

                    offset: const Offset(0, -2),
                  ),
                ],
              ),

              child: ElevatedButton(

                onPressed: c.isLoading
                    ? null
                    : () => c.publishTrip(context),

                style: ElevatedButton.styleFrom(
                  padding:
                  const EdgeInsets.symmetric(
                    vertical: 16,
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),

                child: c.isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,

                  child:
                  CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
                    : const Text(
                  'Опубликовать поездку',

                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
  }) {

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        Text(
          title,

          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        child,
      ],
    );
  }
}