import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class UserEntity {
  final String uid;
  final String? email;
  final String? displayName;       // из Firebase (можно использовать как полное ФИО)
  final String? name;
  final String? surname;
  final String? patronymic;
  final String? photoUrl;          // опционально

  UserEntity({
    required this.uid,
    this.email,
    this.displayName,
    this.name,
    this.surname,
    this.patronymic,
    this.photoUrl,
  });

  // из Firebase Auth (только базовые данные)
  factory UserEntity.fromFirebase(firebase_auth.User firebaseUser) {
    return UserEntity(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      // name, surname, patronymic — пока null, заполним позже
    );
  }

  // когда загрузили из Firestore
  factory UserEntity.fromMap(Map<String, dynamic> map, String uid) {
    return UserEntity(
      uid: uid,
      email: map['email'] as String?,
      displayName: map['displayName'] as String?,
      name: map['name'] as String?,
      surname: map['surname'] as String?,
      patronymic: map['patronymic'] as String?,
      photoUrl: map['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'name': name,
      'surname': surname,
      'patronymic': patronymic,
      'photoUrl': photoUrl,
      // можно добавить 'updatedAt': FieldValue.serverTimestamp()
    };
  }
}