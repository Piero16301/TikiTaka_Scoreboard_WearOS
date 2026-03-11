import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/match/match.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await getIt<NotificationService>().setupFlutterNotifications();
  await getIt<NotificationService>().showNotification(message);
}

class NotificationService {
  // ignore: unreachable_from_main // used in dependencies.dart
  NotificationService({
    FirebaseMessaging? messaging,
    FlutterLocalNotificationsPlugin? localNotifications,
  })  : _messaging = messaging ?? FirebaseMessaging.instance,
        _localNotifications =
            localNotifications ?? FlutterLocalNotificationsPlugin();

  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;

  String _token = '';
  bool _isFlutterLocalNotificationsInitialized = false;

  // ignore: unreachable_from_main // used in main.dart
  Future<void> initialize() async {
    // Background message handler
    try {
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );
    } on Exception catch (e) {
      debugPrint('Error setting background message handler: $e');
    }

    // Request permission
    await _requestPermission();

    // Setup message handlers
    await _setupMessageHandlers();

    // Setup Flutter local notifications
    await setupFlutterNotifications();

    // Get FCM token
    String? token;
    try {
      token = await _messaging.getToken();
      debugPrint('FCM Token: $token');
    } on Exception catch (e) {
      debugPrint('Error getting FCM token: $e');
    }
    if (token != null) {
      _token = token;
    } else {
      return;
    }

    // Get services information
    final deviceInfo = getIt<DeviceInfoService>();
    final localStorage = getIt<LocalStorageService>();
    final database = getIt<DatabaseService>();

    final androidInfo = deviceInfo.androidInfo;
    final localLanguage = localStorage.getLanguage();

    // Setup Flutter local notifications
    database.setLocalSettingsDevice(
      token: token,
      androidInfo: androidInfo,
      localLanguage: localLanguage,
    );

    // Subscribe to AllDevices topic
    await subscribeToTopic(AppVariables.allDevicesTopic);

    // Subscribe to WearOS topic if not emulator
    if (androidInfo.isPhysicalDevice) {
      await subscribeToTopic(AppVariables.wearOSTopic);
    } else {
      debugPrint('Emulator detected, not subscribing to WearOS topic');
    }
  }

  // ignore: unreachable_from_main // used in main.dart
  String get token => _token;

  Future<void> _requestPermission() async {
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
    }
  }

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
            AndroidFlutterLocalNotificationsPlugin>()
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

  Future<void> _setupMessageHandlers() async {
    // Foreground message handler
    FirebaseMessaging.onMessage.listen(showNotification);

    // Background message handler
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleBackgroundMessage(message.data['match'] as String? ?? '');
    });

    // Opened app
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      handleBackgroundMessage(initialMessage.data['match'] as String? ?? '');
    }
  }

  @visibleForTesting
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

  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    debugPrint('Subscribed to topic: $topic');
  }

  // ignore: unreachable_from_main // used in main.dart
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    debugPrint('Unsubscribed from topic: $topic');
  }
}
