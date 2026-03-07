class Trip {
  final String id;
  final String from;
  final String to;
  final DateTime departureTime;
  final int freeSeats;
  final double? pricePerSeat;
  final String? description;
  final Map<String, bool>? preferences;
  final List<String>? stops;
  final String status; // 'planned', 'active', 'completed' и т.д.

  Trip({
    required this.id,
    required this.from,
    required this.to,
    required this.departureTime,
    required this.freeSeats,
    this.pricePerSeat,
    this.description,
    this.preferences,
    this.stops,
    this.status = 'planned',
  });

  // Фабрика из Map (для RTDB)
  factory Trip.fromMap(Map<dynamic, dynamic> map, String id) {
    return Trip(
      id: id,
      from: map['from'] as String? ?? '',
      to: map['to'] as String? ?? '',
      departureTime: DateTime.tryParse(map['departureTime'] as String? ?? '') ?? DateTime.now(),
      freeSeats: map['freeSeats'] as int? ?? 0,
      pricePerSeat: (map['pricePerSeat'] as num?)?.toDouble(),
      description: map['description'] as String?,
      preferences: map['preferences'] != null ? Map<String, bool>.from(map['preferences']) : null,
      stops: map['stops'] != null ? List<String>.from(map['stops']) : null,
      status: map['status'] as String? ?? 'planned',
    );
  }

  bool get hasAvailableSeats => freeSeats > 0;
}