import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/match/match.dart';

abstract class NotificationRepository {
  Future<void> initialize();
  String get token;
  Future<String?> getToken();
  Stream<String> get onTokenRefresh;
  Stream<RemoteMessage> get onMessage;
  Stream<RemoteMessage> get onMessageOpenedApp;
  Future<RemoteMessage?> getInitialMessage();
  Future<void> showNotification(RemoteMessage message);
  Future<void> subscribeToTopic(String topic);
  Future<void> unsubscribeFromTopic(String topic);
  Future<void> requestPermission();
  void handleBackgroundMessage(String message);
}

class MockNotificationRepository implements NotificationRepository {
  @override
  Future<void> initialize() async {}

  @override
  String get token => 'dummy-token';

  @override
  Future<String?> getToken() async => 'dummy-token';

  @override
  Stream<String> get onTokenRefresh => const Stream.empty();

  @override
  Stream<RemoteMessage> get onMessage => const Stream.empty();

  @override
  Stream<RemoteMessage> get onMessageOpenedApp => const Stream.empty();

  @override
  Future<RemoteMessage?> getInitialMessage() async => null;

  @override
  Future<void> showNotification(RemoteMessage message) async {}

  @override
  Future<void> subscribeToTopic(String topic) async {}

  @override
  Future<void> unsubscribeFromTopic(String topic) async {}

  @override
  Future<void> requestPermission() async {}

  @override
  void handleBackgroundMessage(String message) {}
}

class FirebaseNotificationRepository implements NotificationRepository {
  FirebaseNotificationRepository({
    FirebaseMessaging? messaging,
    FlutterLocalNotificationsPlugin? localNotifications,
    this._crashService,
  }) : _messaging = messaging ?? FirebaseMessaging.instance,
       _localNotifications =
           localNotifications ?? FlutterLocalNotificationsPlugin();

  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;
  final CrashService? _crashService;

  String _token = '';
  bool _isFlutterLocalNotificationsInitialized = false;

  CrashService? get _crash =>
      _crashService ??
      (getIt.isRegistered<CrashService>() ? getIt<CrashService>() : null);

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message, {
    FlutterLocalNotificationsPlugin? localNotifications,
  }) async {
    var plugin = localNotifications;
    if (plugin == null && getIt.isRegistered<NotificationRepository>()) {
      final repo = getIt<NotificationRepository>();
      if (repo is FirebaseNotificationRepository) {
        plugin = repo._localNotifications;
      }
    }
    plugin ??= FlutterLocalNotificationsPlugin();

    final notification = message.notification;
    final android = message.notification?.android;
    if (notification != null && android != null) {
      const channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
      );

      await plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);

      await plugin.show(
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
        payload: (message.data['match'] ?? message.data['matchId'])?.toString(),
      );
    }
  }

  @override
  Future<void> initialize() async {
    try {
      setupBackgroundHandler();
    } on Exception catch (e, stackTrace) {
      _crash?.recordError(
        e,
        stackTrace,
        reason: 'NotificationRepository setupBackgroundHandler error',
      );
    }

    try {
      await Future.wait([
        requestPermission(),
        setupFlutterNotifications(),
        getToken(),
      ]);
    } on Exception catch (e, stackTrace) {
      _crash?.recordError(
        e,
        stackTrace,
        reason: 'NotificationRepository initialize/getToken error',
      );
    }
  }

  @override
  String get token => _token;

  @override
  Future<String?> getToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        _token = token;
        debugPrint('FCM Token: $token');
      } else {
        _crash?.recordError(
          Exception('FCM token is null'),
          StackTrace.current,
          reason: 'NotificationRepository getToken error',
        );
      }
      return token;
    } on Exception catch (e, stackTrace) {
      _crash?.recordError(
        e,
        stackTrace,
        reason: 'NotificationRepository getToken error',
      );
      return null;
    }
  }

  @override
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  @override
  Stream<RemoteMessage> get onMessage => FirebaseMessaging.onMessage;

  @override
  Stream<RemoteMessage> get onMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp;

  @override
  Future<RemoteMessage?> getInitialMessage() => _messaging.getInitialMessage();

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

  @override
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
        payload: (message.data['match'] ?? message.data['matchId'])?.toString(),
      );
    }
  }

  @override
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

  @visibleForTesting
  void setupBackgroundHandler() {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  @override
  void handleBackgroundMessage(String message) {
    debugPrint('Handling a background message: $message');
    if (message.contains('matchId')) {
      final matchId = int.tryParse(message.split('matchId:')[1]);
      if (matchId != null) {
        AppVariables.navigatorKey.currentState
            ?.pushNamed(MatchPage.routeName, arguments: matchId)
            .ignore();
      }
    } else {
      final matchId = int.tryParse(message.replaceAll(RegExp(r'[^\d]'), ''));
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
      _crash?.recordError(
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
      _crash?.recordError(
        e,
        stackTrace,
        reason: 'NotificationRepository unsubscribeFromTopic error',
      );
    }
  }
}
