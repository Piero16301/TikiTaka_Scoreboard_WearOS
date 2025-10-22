import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/match/match.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService.instance.setupFlutterNotifications();
  await NotificationService.instance.showNotification(message);
}

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  String _token = '';
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;

  // ignore: unreachable_from_main // used in main.dart
  Future<void> initialize() async {
    // Background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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

    // Get device information
    final androidInfo = LocalSettingsService.instance.androidInfo;

    // Get device locale
    final localLanguage = await LocalSettingsService.instance
        .getLocalLanguage();

    // Get device base color
    final baseColor = await LocalSettingsService.instance.getBaseColor();

    // Setup Flutter local notifications
    await FirebaseFirestore.instance
        .collection(devicesCollection)
        .doc(token)
        .set({
          'platform': 'WEAROS',
          'token': token,
          'lastOpenAt': FieldValue.serverTimestamp(),
          'wearOSInfo': androidInfo.toJson(),
          'macOsInfo': null,
          'windowsInfo': null,
          'androidInfo': null,
          'iosInfo': null,
          'webInfo': null,
          'language': localLanguage,
          'baseColor': baseColor,
          'enabledTeams': FieldValue.arrayUnion(<String>[]),
        }, SetOptions(merge: true));

    // Subscribe to AllDevices topic
    await subscribeToTopic(allDevicesTopic);

    // Subscribe to WearOS topic if not emulator
    if (androidInfo.isPhysicalDevice) {
      await subscribeToTopic(wearOSTopic);
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
      initializationSettings,
      onDidReceiveNotificationResponse: (details) =>
          _handleBackgroundMessage(details.payload ?? ''),
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> showNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;
    if (notification != null && android != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
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
      _handleBackgroundMessage(message.data['match'] as String? ?? '');
    });

    // Opened app
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundMessage(initialMessage.data['match'] as String? ?? '');
    }
  }

  void _handleBackgroundMessage(String message) {
    debugPrint('Handling a background message: $message');
    if (message.contains('matchId')) {
      final matchId = int.parse(message.split('matchId:')[1]);
      navigatorKey.currentState
          ?.pushNamed(MatchPage.routeName, arguments: matchId)
          .ignore();
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

extension AndroidVersion on AndroidBuildVersion {
  Map<String, dynamic> toJson() {
    return {
      'codename': codename,
      'incremental': incremental,
      'previewSdkInt': previewSdkInt ?? 0,
      'release': release,
      'sdkInt': sdkInt,
      'securityPatch': securityPatch ?? '',
    };
  }
}

extension AndroidInfo on AndroidDeviceInfo {
  Map<String, dynamic> toJson() {
    return {
      'version': version.toJson(),
      'board': board,
      'bootloader': bootloader,
      'brand': brand,
      'device': device,
      'display': display,
      'fingerprint': fingerprint,
      'hardware': hardware,
      'host': host,
      'id': id,
      'manufacturer': manufacturer,
      'model': model,
      'product': product,
      'supported32BitAbis': supported32BitAbis,
      'supported64BitAbis': supported64BitAbis,
      'supportedAbis': supportedAbis,
      'tags': tags,
      'type': type,
      'isPhysicalDevice': isPhysicalDevice,
      'systemFeatures': systemFeatures,
      'isLowRamDevice': isLowRamDevice,
      'physicalRamSize': physicalRamSize,
      'availableRamSize': availableRamSize,
    };
  }
}
