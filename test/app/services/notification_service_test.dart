import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

class MockDeviceInfoService extends Mock implements DeviceInfoService {}

class MockLocalStorageService extends Mock implements LocalStorageService {}

class MockDatabaseService extends Mock implements DatabaseService {}

class MockAndroidDeviceInfo extends Mock implements AndroidDeviceInfo {}

class FakeAndroidDeviceInfo extends Fake implements AndroidDeviceInfo {}

class MockFlutterLocalNotificationsPlugin extends Mock
    implements FlutterLocalNotificationsPlugin {}

class MockAndroidFlutterLocalNotificationsPlugin extends Mock
    implements AndroidFlutterLocalNotificationsPlugin {}

void main() {
  group('NotificationService', () {
    late MockFirebaseMessaging mockMessaging;
    late MockFlutterLocalNotificationsPlugin mockLocalNotifications;
    late MockDeviceInfoService mockDeviceInfo;
    late MockLocalStorageService mockLocalStorage;
    late MockDatabaseService mockDatabase;
    late MockAndroidDeviceInfo mockAndroidInfo;
    late NotificationService notificationService;

    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();

      registerFallbackValue(const RemoteMessage());
      registerFallbackValue(
        const InitializationSettings(
          android: AndroidInitializationSettings('ic_logo'),
        ),
      );
      registerFallbackValue(FakeAndroidDeviceInfo());
      registerFallbackValue(const Locale('en', 'US'));
      registerFallbackValue(
        const AndroidNotificationChannel('id', 'name'),
      );
      registerFallbackValue(const NotificationDetails());
    });

    setUp(() async {
      mockMessaging = MockFirebaseMessaging();
      mockLocalNotifications = MockFlutterLocalNotificationsPlugin();
      mockDeviceInfo = MockDeviceInfoService();
      mockLocalStorage = MockLocalStorageService();
      mockDatabase = MockDatabaseService();
      mockAndroidInfo = MockAndroidDeviceInfo();

      when(() => mockAndroidInfo.isPhysicalDevice).thenReturn(true);
      when(() => mockDeviceInfo.androidInfo).thenReturn(mockAndroidInfo);
      when(mockLocalStorage.getLanguage).thenReturn(const Locale('en', 'US'));

      if (getIt.isRegistered<DeviceInfoService>()) {
        await getIt.unregister<DeviceInfoService>();
      }
      if (getIt.isRegistered<LocalStorageService>()) {
        getIt.unregister<LocalStorageService>();
      }
      if (getIt.isRegistered<DatabaseService>()) {
        getIt.unregister<DatabaseService>();
      }

      getIt
        ..registerSingleton<DeviceInfoService>(mockDeviceInfo)
        ..registerSingleton<LocalStorageService>(mockLocalStorage)
        ..registerSingleton<DatabaseService>(mockDatabase);

      notificationService = NotificationService(
        messaging: mockMessaging,
        localNotifications: mockLocalNotifications,
      );
    });

    test('subscribeToTopic delegates to messaging', () async {
      when(() => mockMessaging.subscribeToTopic(any()))
          .thenAnswer((_) async {});
      await notificationService.subscribeToTopic('test_topic');
      verify(() => mockMessaging.subscribeToTopic('test_topic')).called(1);
    });

    test('unsubscribeFromTopic delegates to messaging', () async {
      when(() => mockMessaging.unsubscribeFromTopic(any()))
          .thenAnswer((_) async {});
      await notificationService.unsubscribeFromTopic('test_topic');
      verify(() => mockMessaging.unsubscribeFromTopic('test_topic')).called(1);
    });

    test('token getter initially returns empty string', () {
      expect(notificationService.token, '');
    });

    test('setupFlutterNotifications initializes plugin', () async {
      final mockAndroidPlugin = MockAndroidFlutterLocalNotificationsPlugin();
      when(
        () => mockLocalNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>(),
      ).thenReturn(mockAndroidPlugin);

      when(() => mockAndroidPlugin.createNotificationChannel(any()))
          .thenAnswer((_) async {});

      when(
        () => mockLocalNotifications.initialize(
          settings: any(named: 'settings'),
          onDidReceiveNotificationResponse:
              any(named: 'onDidReceiveNotificationResponse'),
        ),
      ).thenAnswer((_) async => true);

      await notificationService.setupFlutterNotifications();

      verify(
        () => mockLocalNotifications.initialize(
          settings: any(named: 'settings'),
          onDidReceiveNotificationResponse:
              any(named: 'onDidReceiveNotificationResponse'),
        ),
      ).called(1);
    });

    test('showNotification with message shows local notification', () async {
      const message = RemoteMessage(
        notification: RemoteNotification(
          title: 'Title',
          body: 'Body',
          android: AndroidNotification(),
        ),
        data: {'match': 'matchId:123'},
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

      await notificationService.showNotification(message);

      verify(
        () => mockLocalNotifications.show(
          id: any(named: 'id'),
          title: 'Title',
          body: 'Body',
          notificationDetails: any(named: 'notificationDetails'),
          payload: 'matchId:123',
        ),
      ).called(1);
    });

    test('showNotification does nothing if notification or android is null',
        () async {
      const message = RemoteMessage();
      await notificationService.showNotification(message);
      verifyNever(
        () => mockLocalNotifications.show(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          notificationDetails: any(named: 'notificationDetails'),
          payload: any(named: 'payload'),
        ),
      );
    });

    test('handleBackgroundMessage handles matchId correctly', () {
      notificationService
        ..handleBackgroundMessage('matchId:123')
        ..handleBackgroundMessage('invalid')
        ..handleBackgroundMessage('');
    });
  });
}
