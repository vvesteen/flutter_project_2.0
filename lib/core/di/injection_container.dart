import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

// ── Profile ────────────────────────────────────────────────────────────────
import '../../features/cars/data/datasources/tunduk_remote_datasource.dart';
import '../../features/cars/data/repositories/car_repository_impl.dart';
import '../../features/cars/domain/repositories/car_repository.dart';
import '../../features/cars/domain/usecases/VerifyAndAddCarUseCase.dart';
import '../../features/cars/presentation/controllers/add_car_controller.dart';
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

  // HTTP (для запросов на Тундук)
  sl.registerLazySingleton<http.Client>(() => http.Client());

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


  // ── Cars Feature ────────────────────────────────────────────────────────

  // Data Sources
  sl.registerLazySingleton<TundukRemoteDataSource>(
        () => TundukRemoteDataSource(),
  );

  // Repository
  sl.registerLazySingleton<CarRepository>(
        () => CarRepositoryImpl(
      remoteDataSource: sl<TundukRemoteDataSource>(),   // ← передаём зависимость
    ),
  );

  // UseCase
  sl.registerLazySingleton<VerifyAndAddCarUseCase>(
        () => VerifyAndAddCarUseCase(sl<CarRepository>()),
  );

  // Controller (ChangeNotifier)
  sl.registerFactory<AddCarController>(
        () => AddCarController(
      verifyAndAddCarUseCase: sl<VerifyAndAddCarUseCase>(),
    ),
  );




  // ── Settings Feature ─────────────────────────────────────────────────────
  //sl.registerLazySingleton<SettingsLocalDataSource>(
    //    () => SettingsLocalDataSource(),
  //);







  // Если есть другие зависимости (auth, trips и т.д.) — они тоже здесь
}
