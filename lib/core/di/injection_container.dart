import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

// ── Profile ────────────────────────────────────────────────────────────────
import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/UpdateUserProfile.dart';
import '../../features/profile/domain/usecases/get_current_user_profile.dart';   // ← подставь точное имя файла/usecase
import '../../features/profile/presentation/bloc/profile_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Firebase
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // ── Profile ─────────────────────────────────────────────────────────────

  // 1. Data Source
  sl.registerLazySingleton<ProfileRemoteDataSource>(
        () => ProfileRemoteDataSourceImpl(
      firestore: sl<FirebaseFirestore>(),
      auth: sl<FirebaseAuth>(),
    ),
  );

  // 2. Repository — именно эту строку ты пропустил / она сломана
  sl.registerLazySingleton<ProfileRepository>(
        () => ProfileRepositoryImpl(
      remoteDataSource: sl<ProfileRemoteDataSource>(),
    ),
  );

  // UseCases
  sl.registerLazySingleton(
        () => GetCurrentUserProfile(sl()),
  );

  sl.registerLazySingleton(
        () => UpdateUserProfile(sl()),
  );

  // Bloc
  sl.registerFactory(
        () => ProfileBloc(
      getCurrentUserProfile: sl(),
      updateUserProfile: sl(),
    ),
  );





  // Если есть другие зависимости (auth, trips и т.д.) — они тоже здесь
}
