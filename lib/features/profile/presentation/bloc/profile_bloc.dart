import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/entities/UserEntity.dart';

import '../../domain/usecases/get_current_user_profile.dart'; // подставь свой путь

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetCurrentUserProfile getCurrentUserProfile;

  ProfileBloc({required this.getCurrentUserProfile}) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
  }

  Future<void> _onLoadProfile(
      LoadProfile event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileLoading());

    final result = await getCurrentUserProfile();

    result.fold(
          (failure) => emit(ProfileError(failure.message ?? 'Не удалось загрузить профиль')),
          (user) => emit(ProfileLoaded(user)),
    );
  }
}