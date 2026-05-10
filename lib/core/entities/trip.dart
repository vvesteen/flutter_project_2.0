import '../../features/seats/Seat.dart';

class Trip {
  final String id;
  final String from;
  final String to;
  final DateTime departureTime;
  final int freeSeats;
  final double pricePerSeat;
  final String driverId;
  final List<String> stops;
  final Map<String, bool> preferences;
  final String? description;
  final List<Seat> seats;

  // Новые поля для геолокации
  final Map<String, dynamic>? currentLocation;
  final List<Map<String, dynamic>>? routePath;
  final bool sharingEnabled;

  Trip({
    required this.id,
    required this.from,
    required this.to,
    required this.departureTime,
    required this.freeSeats,
    required this.pricePerSeat,
    required this.driverId,
    this.stops = const [],
    this.preferences = const {},
    this.description,
    this.currentLocation,
    this.routePath,
    this.sharingEnabled = false,
    required this.seats,
  });

  Trip copyWith({
    String? id,
    String? from,
    String? to,
    DateTime? departureTime,
    int? freeSeats,
    double? pricePerSeat,
    String? driverId,
    List<String>? stops,
    Map<String, bool>? preferences,
    String? description,
    Map<String, dynamic>? currentLocation,
    List<Map<String, dynamic>>? routePath,
    bool? sharingEnabled,
    List<Seat>? seats,
  }) {
    return Trip(
      id: id ?? this.id,
      from: from ?? this.from,
      to: to ?? this.to,
      departureTime: departureTime ?? this.departureTime,
      freeSeats: freeSeats ?? this.freeSeats,
      pricePerSeat: pricePerSeat ?? this.pricePerSeat,
      driverId: driverId ?? this.driverId,
      stops: stops ?? this.stops,
      preferences: preferences ?? this.preferences,
      description: description ?? this.description,
      currentLocation: currentLocation ?? this.currentLocation,
      routePath: routePath ?? this.routePath,
      sharingEnabled: sharingEnabled ?? this.sharingEnabled,
      seats: seats ?? this.seats,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'from': from,
      'to': to,
      'departureTime': departureTime.toIso8601String(),
      'freeSeats': freeSeats,
      'pricePerSeat': pricePerSeat,
      'driverId': driverId,
      'stops': stops,
      'preferences': preferences,
      'description': description,
      'status': 'planned',                    // ← Добавь эту строку
      'currentLocation': currentLocation,
      'routePath': routePath,
      'sharingEnabled': sharingEnabled,
      'seats': seats.map((e) => e.toMap()).toList(),

    };
  }

  factory Trip.fromMap(Map<dynamic, dynamic> map, String id) {
    return Trip(
      id: id,
      from: (map['from'] ?? '') as String,
      to: (map['to'] ?? '') as String,
      departureTime: DateTime.parse(map['departureTime'] as String),
      freeSeats: (map['freeSeats'] ?? 0) as int,
      pricePerSeat: (map['pricePerSeat'] ?? 0).toDouble(),
      driverId: (map['driverId'] ?? '') as String,
      stops: map['stops'] != null ? List<String>.from(map['stops']) : [],
      preferences: map['preferences'] != null
          ? Map<String, bool>.from(map['preferences'])
          : {},
      description: map['description'] as String?,
      currentLocation: map['currentLocation'] as Map<String, dynamic>?,
      routePath: map['routePath'] != null
          ? List<Map<String, dynamic>>.from(map['routePath'])
          : null,
      sharingEnabled: (map['sharingEnabled'] ?? false) as bool,
      seats: map['seats'] != null
          ? List<Seat>.from(
        map['seats'].map((e) => Seat.fromMap(e)),
      )
          : [],
    );
  }

  bool get isSharingLocation => sharingEnabled && currentLocation != null;
  double? get currentLat => currentLocation?['lat'] as double?;
  double? get currentLng => currentLocation?['lng'] as double?;
}