part of 'profile_bloc.dart';

 class ProfileEvent {}

class LoadProfile extends ProfileEvent {

}
class UpdateProfile extends ProfileEvent {
  final UserEntity user;

  UpdateProfile(this.user);
}
// Можно добавить позже: RefreshProfile, UpdateProfile и т.д.