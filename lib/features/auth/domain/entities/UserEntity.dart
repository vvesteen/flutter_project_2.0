// lib/features/auth/domain/entities/user_entity.dart

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class UserEntity {
  final String uid;
  final String? email;

  UserEntity({
    required this.uid,
    this.email,
  });

  factory UserEntity.fromFirebase(firebase_auth.User firebaseUser) {  // ← здесь firebase_auth.User
    return UserEntity(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
    );
  }
}