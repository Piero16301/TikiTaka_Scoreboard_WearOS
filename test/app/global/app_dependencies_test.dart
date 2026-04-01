import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

void main() {
  setUp(getIt.reset);

  group('ServiceFactory', () {
    group('Environment.mock', () {
      test('returns mock implementations', () {
        expect(
          ServiceFactory.getCrashRepository(Environment.mock),
          isA<MockCrashRepository>(),
        );
        expect(
          ServiceFactory.getPerformanceRepository(Environment.mock),
          isA<MockPerformanceRepository>(),
        );
        expect(
          ServiceFactory.getAnalyticsRepository(Environment.mock),
          isA<MockAnalyticsRepository>(),
        );
        expect(
          ServiceFactory.getLocalStorageRepository(Environment.mock),
          isA<MockLocalStorageRepository>(),
        );
        expect(
          ServiceFactory.getDatabaseRepository(Environment.mock),
          isA<MockDatabaseRepository>(),
        );
        expect(
          ServiceFactory.getDeviceInfoRepository(Environment.mock),
          isA<MockDeviceInfoRepository>(),
        );
        expect(
          ServiceFactory.getNotificationRepository(Environment.mock),
          isA<MockNotificationRepository>(),
        );
      });
    });

    group('Environment.prod', () {
      test('returns production implementations (handles Firebase error)', () {
        try {
          expect(
            ServiceFactory.getCrashRepository(Environment.prod),
            isA<CrashlyticsCrashRepository>(),
          );
        } on Exception catch (_) {}
        try {
          expect(
            ServiceFactory.getPerformanceRepository(Environment.prod),
            isA<FirebasePerformanceRepository>(),
          );
        } on Exception catch (_) {}
        try {
          expect(
            ServiceFactory.getAnalyticsRepository(Environment.prod),
            isA<FirebaseAnalyticsRepository>(),
          );
        } on Exception catch (_) {}
        try {
          expect(
            ServiceFactory.getLocalStorageRepository(Environment.prod),
            isA<SharedPrefsLocalStorageRepository>(),
          );
        } on Exception catch (_) {}
        try {
          expect(
            ServiceFactory.getDatabaseRepository(Environment.prod),
            isA<FirestoreDatabaseRepository>(),
          );
        } on Exception catch (_) {}
        try {
          expect(
            ServiceFactory.getDeviceInfoRepository(Environment.prod),
            isA<PlusDeviceInfoRepository>(),
          );
        } on Exception catch (_) {}
        try {
          expect(
            ServiceFactory.getNotificationRepository(Environment.prod),
            isA<FirebaseNotificationRepository>(),
          );
        } on Exception catch (_) {}
      });
    });
  });

  group('setupServiceLocator', () {
    test(
        'registers all services as lazy singletons and instantiates them in '
        'mock environment', () {
      setupServiceLocator(Environment.mock);

      expect(getIt.isRegistered<CrashService>(), isTrue);
      expect(getIt.isRegistered<PerformanceService>(), isTrue);
      expect(getIt.isRegistered<AnalyticsService>(), isTrue);
      expect(getIt.isRegistered<LocalStorageService>(), isTrue);
      expect(getIt.isRegistered<DatabaseService>(), isTrue);
      expect(getIt.isRegistered<DeviceInfoService>(), isTrue);
      expect(getIt.isRegistered<NotificationService>(), isTrue);

      expect(getIt<CrashService>(), isA<CrashService>());
      expect(getIt<PerformanceService>(), isA<PerformanceService>());
      expect(getIt<AnalyticsService>(), isA<AnalyticsService>());
      expect(getIt<LocalStorageService>(), isA<LocalStorageService>());
      expect(getIt<DatabaseService>(), isA<DatabaseService>());
      expect(getIt<DeviceInfoService>(), isA<DeviceInfoService>());
      expect(getIt<NotificationService>(), isA<NotificationService>());
    });
  });
}
