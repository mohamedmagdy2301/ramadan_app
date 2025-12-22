import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:ramadan_app/features/home/data/repo/prayer_time_repo_impl.dart';
import 'package:ramadan_app/features/home/presentation/view_model/prayer_times_cubit/prayer_times_cubit.dart';
import 'package:ramadan_app/features/prayer_notifications/data/datasources/prayer_notification_local_datasource.dart';
import 'package:ramadan_app/features/prayer_notifications/presentation/cubit/prayer_notification_cubit.dart';
import 'package:ramadan_app/features/prayer_notifications/services/adhan_player_service.dart';
import 'package:ramadan_app/features/prayer_notifications/services/prayer_notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => Dio());

  // Repositories
  sl.registerLazySingleton(() => PrayerTimesRepository());

  // Data Sources
  sl.registerLazySingleton<PrayerNotificationLocalDatasource>(
    () => PrayerNotificationLocalDatasourceImpl(
      sharedPreferences: sl<SharedPreferences>(),
    ),
  );

  // Services
  sl.registerLazySingleton<IPrayerNotificationService>(
    () => PrayerNotificationService.instance,
  );
  sl.registerLazySingleton<IAdhanPlayerService>(
    () => AdhanPlayerService.instance,
  );

  // Cubits
  sl.registerFactory(
    () => PrayerTimesCubit(),
  );
  sl.registerFactory(
    () => PrayerNotificationCubit(
      localDatasource: sl<PrayerNotificationLocalDatasource>(),
      notificationService: sl<IPrayerNotificationService>(),
    ),
  );
}
