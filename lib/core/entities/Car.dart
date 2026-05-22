class Car {
  final String id;
  final String plateNumber;
  final String brandModel;
  final int year;
  final String? fuelType;
  final String? engineVolume;
  final String? selectedSteering;


  Car({
    required this.id,
    required this.plateNumber,
    required this.brandModel,
    required this.year,
    this.fuelType,
    this.engineVolume,
    this.selectedSteering,

  });
}