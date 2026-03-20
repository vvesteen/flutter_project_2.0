part of 'profile_bloc.dart';

sealed class ProfileEvent {}

class LoadProfile extends ProfileEvent {}
// Можно добавить позже: RefreshProfile, UpdateProfile и т.д.