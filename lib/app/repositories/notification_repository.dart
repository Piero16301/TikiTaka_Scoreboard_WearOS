import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/match/match.dart';

abstract class NotificationRepository {
  Future<void> initialize();
  String get token;
  Future<void> subscribeToTopic(String topic);
  Future<void> unsubscribeFromTopic(String topic);
}

class MockNotificationRepository implements NotificationRepository {
  @override
  Future<void> initialize() async {}

  @override
  String get token => 'dummy-token';

  @override
  Future<void> subscribeToTopic(String topic) async {}

  @override
  Future<void> unsubscribeFromTopic(String topic) async {}
}

class FirebaseNotificationRepository implements NotificationRepository {
  FirebaseNotificationRepository({
    FirebaseMessaging? messaging,
    FlutterLocalNotificationsPlugin? localNotifications,
  }) : _messaging = messaging ?? FirebaseMessaging.instance,
       _localNotifications =
           localNotifications ?? FlutterLocalNotificationsPlugin();

  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;

  String _token = '';
  bool _isFlutterLocalNotificationsInitialized = false;

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    final repository =
        getIt<NotificationRepository>() as FirebaseNotificationRepository;
    await repository.setupFlutterNotifications();
    await repository.showNotification(message);
  }

  @override
  Future<void> initialize() async {
    try {
      await _messaging.getInitialMessage(); // Just to use the instance
      setupBackgroundHandler();
    } on Exception catch (e, stackTrace) {
      getIt<CrashService>().recordError(
        e,
        stackTrace,
        reason: 'NotificationRepository setupBackgroundHandler error',
      );
    }

    String? token;
    try {
      final results = await Future.wait([
        requestPermission(),
        setupMessageHandlers(),
        setupFlutterNotifications(),
        _messaging.getToken(),
      ]);

      token = results[3] as String?;
      if (token != null) debugPrint('FCM Token: $token');
    } on Exception catch (e, stackTrace) {
      getIt<CrashService>().recordError(
        e,
        stackTrace,
        reason: 'NotificationRepository initialize/getToken error',
      );
    }

    if (token != null) {
      _token = token;
    } else {
      getIt<CrashService>().recordError(
        Exception('FCM token is null'),
        StackTrace.current,
        reason: 'NotificationRepository getToken error',
      );
      return;
    }

    final deviceInfo = getIt<DeviceInfoService>();
    final localStorage = getIt<LocalStorageService>();

    final _ = getIt<DatabaseService>()
      ..updateDeviceSettings(
        token: token,
        deviceInfo: deviceInfo.deviceInfo,
        language: localStorage.getLanguage(),
      );

    final topicSubscriptions = <Future<void>>[
      subscribeToTopic(AppVariables.allDevicesTopic),
    ];

    if (deviceInfo.deviceInfo.isPhysicalDevice ?? false) {
      topicSubscriptions.add(subscribeToTopic(AppVariables.wearOSTopic));
    } else {
      debugPrint('Running on emulator, not subscribing to WearOS topic');
    }

    await Future.wait(topicSubscriptions);
  }

  @override
  String get token => _token;

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) return;

    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_logo',
    );

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _localNotifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (details) =>
          handleBackgroundMessage(details.payload ?? ''),
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> showNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;
    if (notification != null && android != null) {
      await _localNotifications.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
            playSound: false,
            icon: '@mipmap/ic_logo',
          ),
        ),
        payload: message.data['match'].toString(),
      );
    }
  }

  Future<void> requestPermission() async {
    final settings = await _messaging.requestPermission();

    switch (settings.authorizationStatus) {
      case AuthorizationStatus.authorized:
        debugPrint('User granted permission');
      case AuthorizationStatus.denied:
        debugPrint('User denied permission');
      case AuthorizationStatus.provisional:
        debugPrint('User granted provisional permission');
      case AuthorizationStatus.notDetermined:
        debugPrint('User has not yet made a choice');
      case AuthorizationStatus.deniedPermanently:
        debugPrint('User denied permission permanently');
    }
  }

  Future<void> setupMessageHandlers() async {
    FirebaseMessaging.onMessage.listen(showNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleBackgroundMessage(message.data['match'] as String? ?? '');
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      handleBackgroundMessage(initialMessage.data['match'] as String? ?? '');
    }
  }

  @visibleForTesting
  void setupBackgroundHandler() {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  void handleBackgroundMessage(String message) {
    debugPrint('Handling a background message: $message');
    if (message.contains('matchId')) {
      final matchId = int.tryParse(message.split('matchId:')[1]);
      if (matchId != null) {
        AppVariables.navigatorKey.currentState
            ?.pushNamed(MatchPage.routeName, arguments: matchId)
            .ignore();
      }
    }
  }

  @override
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      debugPrint('Subscribed to topic: $topic');
    } on Exception catch (e, stackTrace) {
      getIt<CrashService>().recordError(
        e,
        stackTrace,
        reason: 'NotificationRepository subscribeToTopic error',
      );
    }
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      debugPrint('Unsubscribed from topic: $topic');
    } on Exception catch (e, stackTrace) {
      getIt<CrashService>().recordError(
        e,
        stackTrace,
        reason: 'NotificationRepository unsubscribeFromTopic error',
      );
    }
  }
}
