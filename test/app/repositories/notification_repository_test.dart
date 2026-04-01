import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

class MockFlutterLocalNotificationsPlugin extends Mock
    implements FlutterLocalNotificationsPlugin {}

class MockCrashService extends Mock implements CrashService {}

class MockDeviceInfoService extends Mock implements DeviceInfoService {}

class MockLocalStorageService extends Mock implements LocalStorageService {}

class MockDatabaseService extends Mock implements DatabaseService {}

class MockAndroidFlutterLocalNotificationsPlugin extends Mock
    implements AndroidFlutterLocalNotificationsPlugin {}

class MockNotificationSettings extends Mock implements NotificationSettings {}

class FakeRemoteMessage extends Fake implements RemoteMessage {}

class FakeNotificationSettings extends Fake implements NotificationSettings {}

class FakeNotificationDetails extends Fake implements NotificationDetails {}

class FakeInitializationSettings extends Fake
    implements InitializationSettings {}

class TestFirebaseNotificationRepository
    extends FirebaseNotificationRepository {
  TestFirebaseNotificationRepository({
    super.messaging,
    super.localNotifications,
  });

  @override
  void setupBackgroundHandler() {}
}

void main() {
  group('FirebaseNotificationRepository', () {
    late MockFirebaseMessaging mockMessaging;
    late MockFlutterLocalNotificationsPlugin mockLocalNotifications;
    late MockCrashService mockCrashService;
    late MockDeviceInfoService mockDeviceInfoService;
    late MockLocalStorageService mockLocalStorageService;
    late MockDatabaseService mockDatabaseService;
    late MockAndroidFlutterLocalNotificationsPlugin mockAndroidNotifications;
    late FirebaseNotificationRepository repository;

    setUpAll(() async {
      registerFallbackValue(FakeRemoteMessage());
      registerFallbackValue(FakeNotificationSettings());
      registerFallbackValue(FakeNotificationDetails());
      registerFallbackValue(FakeInitializationSettings());
      registerFallbackValue(
        const AndroidNotificationChannel(
          'id',
          'name',
          description: 'desc',
        ),
      );
    });

    setUp(() async {
      mockMessaging = MockFirebaseMessaging();
      mockLocalNotifications = MockFlutterLocalNotificationsPlugin();
      mockCrashService = MockCrashService();
      mockDeviceInfoService = MockDeviceInfoService();
      mockLocalStorageService = MockLocalStorageService();
      mockDatabaseService = MockDatabaseService();
      mockAndroidNotifications = MockAndroidFlutterLocalNotificationsPlugin();

      if (getIt.isRegistered<CrashService>()) {
        await getIt.unregister<CrashService>();
      }
      getIt.registerSingleton<CrashService>(mockCrashService);

      if (getIt.isRegistered<DeviceInfoService>()) {
        await getIt.unregister<DeviceInfoService>();
      }
      getIt.registerSingleton<DeviceInfoService>(mockDeviceInfoService);

      if (getIt.isRegistered<LocalStorageService>()) {
        await getIt.unregister<LocalStorageService>();
      }
      getIt.registerSingleton<LocalStorageService>(mockLocalStorageService);

      if (getIt.isRegistered<DatabaseService>()) {
        await getIt.unregister<DatabaseService>();
      }
      getIt.registerSingleton<DatabaseService>(mockDatabaseService);

      repository = TestFirebaseNotificationRepository(
        messaging: mockMessaging,
        localNotifications: mockLocalNotifications,
      );

      if (getIt.isRegistered<NotificationRepository>()) {
        await getIt.unregister<NotificationRepository>();
      }
      getIt.registerSingleton<NotificationRepository>(repository);
    });

    tearDown(getIt.reset);

    test('subscribeToTopic calls FirebaseMessaging', () async {
      when(() => mockMessaging.subscribeToTopic(any()))
          .thenAnswer((_) async {});

      await repository.subscribeToTopic('test_topic');

      verify(() => mockMessaging.subscribeToTopic('test_topic')).called(1);
    });

    test('subscribeToTopic logs to CrashService on error', () async {
      final exception = Exception('subscribe error');
      when(() => mockMessaging.subscribeToTopic(any())).thenThrow(exception);

      await repository.subscribeToTopic('test_topic');

      verify(() => mockMessaging.subscribeToTopic('test_topic')).called(1);
      verify(
        () => mockCrashService.recordError(
          exception,
          any<StackTrace?>(),
          reason: 'NotificationRepository subscribeToTopic error',
        ),
      ).called(1);
    });

    test('unsubscribeFromTopic calls FirebaseMessaging', () async {
      when(() => mockMessaging.unsubscribeFromTopic(any()))
          .thenAnswer((_) async {});

      await repository.unsubscribeFromTopic('test_topic');

      verify(() => mockMessaging.unsubscribeFromTopic('test_topic')).called(1);
    });

    test('unsubscribeFromTopic logs to CrashService on error', () async {
      final exception = Exception('unsubscribe error');
      when(() => mockMessaging.unsubscribeFromTopic(any()))
          .thenThrow(exception);

      await repository.unsubscribeFromTopic('test_topic');

      verify(() => mockMessaging.unsubscribeFromTopic('test_topic')).called(1);
      verify(
        () => mockCrashService.recordError(
          exception,
          any<StackTrace?>(),
          reason: 'NotificationRepository unsubscribeFromTopic error',
        ),
      ).called(1);
    });

    test('initialize performs complete setup', () async {
      final settings = MockNotificationSettings();
      when(() => settings.authorizationStatus)
          .thenReturn(AuthorizationStatus.authorized);
      when(() => mockMessaging.requestPermission())
          .thenAnswer((_) async => settings);
      when(() => mockMessaging.getToken())
          .thenAnswer((_) async => 'fake-token');
      when(() => mockMessaging.getInitialMessage())
          .thenAnswer((_) async => null);
      when(() => mockMessaging.subscribeToTopic(any()))
          .thenAnswer((_) async {});

      when(() => mockDeviceInfoService.deviceInfo)
          .thenReturn(const AppDeviceInfo(id: 'id', isPhysicalDevice: true));
      when(() => mockLocalStorageService.getLanguage())
          .thenReturn(const Locale('es'));

      when(
        () => mockLocalNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>(),
      ).thenReturn(mockAndroidNotifications);
      when(() => mockAndroidNotifications.createNotificationChannel(any()))
          .thenAnswer((_) async {});
      when(
        () => mockLocalNotifications.initialize(
          settings: any(named: 'settings'),
          onDidReceiveNotificationResponse:
              any(named: 'onDidReceiveNotificationResponse'),
        ),
      ).thenAnswer((_) async => true);

      await repository.initialize();
      expect(repository.token, 'fake-token');
    });

    test('showNotification returnsnormally with proper message', () async {
      const message = RemoteMessage(
        notification: RemoteNotification(
          title: 'Title',
          body: 'Body',
          android: AndroidNotification(),
        ),
        data: {'match': '123'},
      );

      when(
        () => mockLocalNotifications.show(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          notificationDetails: any(named: 'notificationDetails'),
          payload: any(named: 'payload'),
        ),
      ).thenAnswer((_) async {});

      await repository.showNotification(message);
    });

    test("handleBackgroundMessage doesn't crash on simple messages", () {
      expect(
        () => repository.handleBackgroundMessage('random message'),
        returnsNormally,
      );
    });

    test('requestPermission coverage', () async {
      final settings = MockNotificationSettings();

      when(() => settings.authorizationStatus)
          .thenReturn(AuthorizationStatus.denied);
      when(() => mockMessaging.requestPermission())
          .thenAnswer((_) async => settings);
      await repository.requestPermission();

      when(() => settings.authorizationStatus)
          .thenReturn(AuthorizationStatus.provisional);
      await repository.requestPermission();

      when(() => settings.authorizationStatus)
          .thenReturn(AuthorizationStatus.notDetermined);
      await repository.requestPermission();
    });

    test('firebaseMessagingBackgroundHandler returnsnormally', () async {
      const msg = RemoteMessage(
        notification: RemoteNotification(
          title: 'T',
          body: 'B',
          android: AndroidNotification(),
        ),
        data: {'match': '123'},
      );

      when(
        () => mockLocalNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>(),
      ).thenReturn(mockAndroidNotifications);
      when(() => mockAndroidNotifications.createNotificationChannel(any()))
          .thenAnswer((_) async {});
      when(
        () => mockLocalNotifications.initialize(
          settings: any(named: 'settings'),
          onDidReceiveNotificationResponse:
              any(named: 'onDidReceiveNotificationResponse'),
        ),
      ).thenAnswer((_) async => true);
      when(
        () => mockLocalNotifications.show(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          notificationDetails: any(named: 'notificationDetails'),
          payload: any(named: 'payload'),
        ),
      ).thenAnswer((_) async {});

      await FirebaseNotificationRepository.firebaseMessagingBackgroundHandler(
        msg,
      );
    });
  });

  group('MockNotificationRepository', () {
    test('methods execute without error', () async {
      final mockRepo = MockNotificationRepository();

      expect(mockRepo.initialize(), completes);
      expect(mockRepo.token, 'dummy-token');
      await mockRepo.subscribeToTopic('topic');
      await mockRepo.unsubscribeFromTopic('topic');
    });
  });
}
