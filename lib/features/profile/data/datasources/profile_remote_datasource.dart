import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'package:flutter_project_2/core/entities/UserEntity.dart';

abstract class ProfileRemoteDataSource {
  Future<UserEntity> getCurrentUser();
  Future<void> updateUser(UserEntity user);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore firestore;
  final firebase_auth.FirebaseAuth auth;

  ProfileRemoteDataSourceImpl({
    required this.firestore,
    required this.auth,
  });

  @override
  Future<UserEntity> getCurrentUser() async {
    final fbUser = auth.currentUser;

    if (fbUser == null) {
      throw Exception('Пользователь не авторизован');
    }

    final docRef = firestore.collection('users').doc(fbUser.uid);
    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      throw Exception('Профиль пользователя не найден в базе данных');
    }

    final data = snapshot.data();

    if (data == null) {
      throw Exception('Данные профиля отсутствуют');
    }

    // Используем существующий фабричный метод
    return UserEntity.fromMap(data, fbUser.uid);
  }
  @override
  Future<void> updateUser(UserEntity user) async {
    final fbUser = auth.currentUser;

    if (fbUser == null) {
      throw Exception('Пользователь не авторизован');
    }

    await firestore
        .collection('users')
        .doc(fbUser.uid)
        .update(user.toMap());
  }
}