import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String? name;
  final int? age;
  final String? gender;         // "male", "female", "other"
  final String? photoUrl;
  final String? phoneNumber;
  final bool phoneVerified;
  final bool idVerified;
  final double rating;
  final int reviewsCount;
  final int tripsAsDriver;
  final int tripsAsPassenger;
  final String? about;
  final Map<String, dynamic>? preferences;
  final String? carModel;
  final String? carYear;
  final String? carColor;
  final String? carPhotoUrl;

  UserModel({
    required this.uid,
    this.name,
    this.age,
    this.gender,
    this.photoUrl,
    this.phoneNumber,
    this.phoneVerified = false,
    this.idVerified = false,
    this.rating = 0.0,
    this.reviewsCount = 0,
    this.tripsAsDriver = 0,
    this.tripsAsPassenger = 0,
    this.about,
    this.preferences,
    this.carModel,
    this.carYear,
    this.carColor,
    this.carPhotoUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      name: map['name'] as String?,
      age: map['age'] as int?,
      gender: map['gender'] as String?,
      photoUrl: map['photoUrl'] as String?,
      phoneNumber: map['phoneNumber'] as String?,
      phoneVerified: map['phoneVerified'] ?? false,
      idVerified: map['idVerified'] ?? false,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: map['reviewsCount'] as int? ?? 0,
      tripsAsDriver: map['tripsAsDriver'] as int? ?? 0,
      tripsAsPassenger: map['tripsAsPassenger'] as int? ?? 0,
      about: map['about'] as String?,
      preferences: map['preferences'] as Map<String, dynamic>?,
      carModel: map['carModel'] as String?,
      carYear: map['carYear'] as String?,
      carColor: map['carColor'] as String?,
      carPhotoUrl: map['carPhotoUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'phoneVerified': phoneVerified,
      'idVerified': idVerified,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'tripsAsDriver': tripsAsDriver,
      'tripsAsPassenger': tripsAsPassenger,
      'about': about,
      'preferences': preferences,
      'carModel': carModel,
      'carYear': carYear,
      'carColor': carColor,
      'carPhotoUrl': carPhotoUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}