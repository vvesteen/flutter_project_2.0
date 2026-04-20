import 'package:firebase_auth/firebase_auth.dart';

class Car {
  String? carBrand;
  String? carModel;
  String? carColor;
  String? carNumber;
  String? carYearOfProduce;
  int numberOfSeats = 0;
  String? photoUrl;

  bool get isValid =>
      carBrand != null &&
          carBrand!.isNotEmpty &&
          carModel != null &&
          carModel!.isNotEmpty &&
          carColor != null &&
          carColor!.isNotEmpty &&
          carNumber != null &&
          carNumber!.isNotEmpty &&
          carYearOfProduce != null &&
          carYearOfProduce!.isNotEmpty &&
          numberOfSeats > 0 &&
          photoUrl != null &&
          photoUrl!.isNotEmpty;

  Map<String, dynamic> toMap() {
    return {
      'carBrand': carBrand,
      'carModel': carModel,
      'carColor': carColor,
      'carNumber': carNumber,
      'carYearOfProduce': carYearOfProduce,
      'numberOfSeats': numberOfSeats,
      'photoUrl': photoUrl,
      'userId': FirebaseAuth.instance.currentUser?.uid,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}