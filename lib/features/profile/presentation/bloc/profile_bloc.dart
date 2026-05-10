import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/entities/UserEntity.dart';

import '../../domain/usecases/UpdateUserProfile.dart';
import '../../domain/usecases/get_current_user_profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetCurrentUserProfile getCurrentUserProfile;
  final UpdateUserProfile updateUserProfile;

  ProfileBloc({
    required this.getCurrentUserProfile,
    required this.updateUserProfile,
  }) : super(ProfileInitial()) {

    on<LoadProfile>(_onLoad);
    on<UpdateProfile>(_onUpdate);
  }

  Future<void> _onLoad(
      LoadProfile event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileLoading());

    final result = await getCurrentUserProfile();

    result.fold(
          (l) => emit(ProfileError(l.message ?? 'Error')),
          (r) => emit(ProfileLoaded(r)),
    );
  }

  Future<void> _onUpdate(
      UpdateProfile event,
      Emitter<ProfileState> emit,
      ) async {
    final result = await updateUserProfile(event.user);

    result.fold(
          (l) => emit(ProfileError(l.message ?? 'Update error')),
          (_) => emit(ProfileLoaded(event.user)),
    );
  }
}