import 'package:get_it/get_it.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  getIt
    ..registerLazySingleton<DatabaseService>(DatabaseService.new)
    ..registerLazySingleton<DeviceInfoService>(DeviceInfoService.new)
    ..registerLazySingleton<LocalStorageService>(LocalStorageService.new)
    ..registerLazySingleton<NotificationService>(NotificationService.new);
}
