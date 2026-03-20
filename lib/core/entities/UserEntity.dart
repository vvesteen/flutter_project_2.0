import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class UserEntity {
  final String uid;

  // базовые данные
  final String? email;
  final String? name;
  final String? surname;
  final String? patronymic;
  final String? photoUrl;

  final DateTime? dateOfBirth;
  final String? sex;

  // контакт
  final String? phoneNumber;
  final bool phoneVerified;

  // рейтинг
  final double rating;
  final int reviewsCount;

  // статистика поездок
  final int tripsAsDriver;
  final int tripsAsPassenger;

  // верификации
  final bool idVerified;
  final bool licenseVerified;

  // информация о пользователе
  final String? about;

  // автомобиль
  final bool isDriver;
  final String? car;
  final int? carYear;
  final String? carColor;
  final String? carSteering;
  final String? carPhotoUrl;

  const UserEntity({
    required this.uid,
    this.email,
    this.name,
    this.surname,
    this.patronymic,
    this.photoUrl,
    this.dateOfBirth,
    this.sex,
    this.phoneNumber,
    this.phoneVerified = false,
    this.rating = 0,
    this.reviewsCount = 0,
    this.tripsAsDriver = 0,
    this.tripsAsPassenger = 0,
    this.idVerified = false,
    this.licenseVerified = false,
    this.about,
    this.isDriver = false,
    this.car,
    this.carYear,
    this.carColor,
    this.carSteering,
    this.carPhotoUrl,
  });

  /// Создание из FirebaseAuth
  factory UserEntity.fromFirebase(firebase_auth.User user) {
    return UserEntity(
      uid: user.uid,
      email: user.email,
      photoUrl: user.photoURL,
    );
  }

  /// Создание из Firestore
  factory UserEntity.fromMap(Map<String, dynamic> map, String uid) {
    return UserEntity(
      uid: uid,
      email: map['email'],
      name: map['name'],
      surname: map['surname'],
      patronymic: map['patronymic'],
      photoUrl: map['photoUrl'],
      sex: map['gender'],
      phoneNumber: map['phoneNumber'],
      phoneVerified: map['phoneVerified'] ?? false,
      rating: (map['rating'] ?? 0).toDouble(),
      reviewsCount: map['reviewsCount'] ?? 0,
      tripsAsDriver: map['tripsAsDriver'] ?? 0,
      tripsAsPassenger: map['tripsAsPassenger'] ?? 0,
      idVerified: map['idVerified'] ?? false,
      licenseVerified: map['licenseVerified'] ?? false,
      about: map['about'],
      isDriver: map['isDriver'] ?? false,
      car: map['car'],
      carYear: map['carYear'],
      carColor: map['carColor'],
      carSteering: map['carSteering'],
      carPhotoUrl: map['carPhotoUrl'],
    );
  }

  /// Для сохранения в Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'surname': surname,
      'patronymic': patronymic,
      'photoUrl': photoUrl,
      'gender': sex,
      'phoneNumber': phoneNumber,
      'phoneVerified': phoneVerified,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'tripsAsDriver': tripsAsDriver,
      'tripsAsPassenger': tripsAsPassenger,
      'idVerified': idVerified,
      'licenseVerified': licenseVerified,
      'about': about,
      'isDriver': isDriver,
      'car': car,
      'carYear': carYear,
      'carColor': carColor,
      'carSteering': carSteering,
      'carPhotoUrl': carPhotoUrl,
    };
  }
}