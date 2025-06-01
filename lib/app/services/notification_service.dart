import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tiki_taka/app/app.dart';
import 'package:tiki_taka/l10n/l10n.dart';
import 'package:tiki_taka/match/match.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService.instance.setupFlutterNotifications();
  await NotificationService.instance.showNotification(message);
}

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final _messaging = FirebaseMessaging.instance;
  String _token = '';
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;

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
    final token = await _messaging.getToken();
    if (token != null) {
      _token = token;
    } else {
      return;
    }

    // Get device information
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;

    // Setup Flutter local notifications
    await FirebaseFirestore.instance
        .collection(notDevicesCollection)
        .doc(token)
        .set(
      {
        'token': token,
        'openedAt': FieldValue.serverTimestamp(),
        'osVersion': androidInfo.version.release,
        'device': androidInfo.model,
      },
      SetOptions(merge: true),
    );

    // Subscribe to AllDevices topic
    await subscribeToTopic(allDevicesTopic);

    // Subscribe to WearOS topic if not emulator
    if (androidInfo.isPhysicalDevice) {
      await subscribeToTopic(wearOSTopic);
    } else {
      debugPrint('Emulator detected, not subscribing to WearOS topic');
    }
  }

  String getToken() {
    return _token;
  }

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
      importance: Importance.max,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_logo');

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        final payload = NotificationPayload.fromJson(
          jsonDecode(details.payload ?? '{}') as Map<String, dynamic>,
        );
        _handleBackgroundMessage(payload);
      },
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> showNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;
    if ((notification != null && android != null) || message.data.isNotEmpty) {
      final payload = NotificationPayload.fromJson(message.data);
      final l10n = await LocalizationService.getLocalizations();

      await _localNotifications.show(
        notification.hashCode,
        buildNotificationTitle(l10n: l10n, payload: payload),
        buildNotificationBody(l10n: l10n, payload: payload),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            importance: Importance.max,
            priority: Priority.high,
            playSound: false,
          ),
        ),
        payload: jsonEncode(payload.toJson()),
      );
    }
  }

  Future<void> _setupMessageHandlers() async {
    // Foreground message handler
    FirebaseMessaging.onMessage.listen(showNotification);

    // Background message handler
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final payload = NotificationPayload.fromJson(message.data);
      _handleBackgroundMessage(payload);
    });

    // Opened app
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      final payload = NotificationPayload.fromJson(initialMessage.data);
      _handleBackgroundMessage(payload);
    }
  }

  void _handleBackgroundMessage(NotificationPayload payload) {
    debugPrint('Handling a background message: ${payload.type}');
    if (payload.deepLink.contains('matchId')) {
      final matchId = int.parse(
        payload.deepLink.split('matchId:')[1],
      );
      navigatorKey.currentState
          ?.pushNamed(
            MatchPage.routeName,
            arguments: matchId,
          )
          .ignore();
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    debugPrint('Subscribed to topic: $topic');
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    debugPrint('Unsubscribed from topic: $topic');
  }

  String buildNotificationTitle({
    required AppLocalizations l10n,
    required NotificationPayload payload,
  }) {
    switch (payload.type) {
      case notificationTypeGoalHome:
        return l10n.notificationTitle(payload.homeTeam.name);
      case notificationTypeGoalAway:
        return l10n.notificationTitle(payload.awayTeam.name);
      case notificationTypeMatchStatus:
        return l10n.notificationStatus(notMatchState(payload.status, l10n));
      default:
        return payload.type;
    }
  }

  String buildNotificationBody({
    required AppLocalizations l10n,
    required NotificationPayload payload,
  }) {
    switch (payload.type) {
      case notificationTypeGoalHome:
        return '${getTeamColors(payload.homeTeam.colors)} '
            '${payload.homeTeam.shortName} '
            '${getTeamScore(payload.homeTeam.score)} - '
            '${getTeamScore(payload.awayTeam.score)} '
            '${payload.awayTeam.shortName} '
            '${getTeamColors(payload.awayTeam.colors)}';
      case notificationTypeGoalAway:
        return '${getTeamColors(payload.awayTeam.colors)} '
            '${payload.awayTeam.shortName} '
            '${getTeamScore(payload.awayTeam.score)} - '
            '${getTeamScore(payload.homeTeam.score)} '
            '${payload.homeTeam.shortName} '
            '${getTeamColors(payload.homeTeam.colors)}';
      case notificationTypeMatchStatus:
        return '${getTeamColors(payload.homeTeam.colors)} '
            '${payload.homeTeam.shortName} '
            '${getTeamScore(payload.homeTeam.score)} - '
            '${getTeamScore(payload.awayTeam.score)} '
            '${payload.awayTeam.shortName} '
            '${getTeamColors(payload.awayTeam.colors)}';
      default:
        return payload.type;
    }
  }
}
