import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/match/match.dart';

abstract class NotificationRepository {
  Future<void> initialize();
  String get token;
  Future<void> register();
  Stream<String> get onRegistered;
  Stream<RemoteMessage> get onMessage;
  Stream<RemoteMessage> get onMessageOpenedApp;
  Future<RemoteMessage?> getInitialMessage();
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
  Future<void> register() async {}

  @override
  Stream<String> get onRegistered => const Stream.empty();

  @override
  Stream<RemoteMessage> get onMessage => const Stream.empty();

  @override
  Stream<RemoteMessage> get onMessageOpenedApp => const Stream.empty();

  @override
  Future<RemoteMessage?> getInitialMessage() async => null;

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
    this._crashService,
  }) : _messaging = messaging ?? FirebaseMessaging.instance;

  final FirebaseMessaging _messaging;
  final CrashService? _crashService;

  String _token = '';

  CrashService? get _crash =>
      _crashService ??
      (getIt.isRegistered<CrashService>() ? getIt<CrashService>() : null);

  @override
  Future<void> initialize() async {
    try {
      _messaging.onRegistered.listen((token) {
        _token = token;
        if (kDebugMode) {
          debugPrint('FCM Token: $token');
        }
      });
      await Future.wait([requestPermission(), register()]);
    } on Exception catch (e, stackTrace) {
      _crash?.recordError(
        e,
        stackTrace,
        reason: 'NotificationRepository initialize/register error',
      );
    }
  }

  @override
  String get token => _token;

  @override
  Future<void> register() async {
    try {
      await _messaging.register();
    } on Exception catch (e, stackTrace) {
      _crash?.recordError(
        e,
        stackTrace,
        reason: 'NotificationRepository register error',
      );
    }
  }

  @override
  Stream<String> get onRegistered => _messaging.onRegistered;

  @override
  Stream<RemoteMessage> get onMessage => FirebaseMessaging.onMessage;

  @override
  Stream<RemoteMessage> get onMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp;

  @override
  Future<RemoteMessage?> getInitialMessage() => _messaging.getInitialMessage();

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

  @override
  void handleBackgroundMessage(String message) {
    if (kDebugMode) {
      debugPrint('Handling a background message: $message');
    }
    int? matchId;
    final matchIdRegex = RegExp(r'matchId:(\d+)');
    final match = matchIdRegex.firstMatch(message);
    if (match != null) {
      matchId = int.tryParse(match.group(1)!);
    } else {
      final digits = message.replaceAll(RegExp(r'[^\d]'), '');
      if (digits.isNotEmpty && digits.length <= 9) {
        matchId = int.tryParse(digits);
      }
    }

    if (matchId != null && matchId > 0) {
      AppVariables.navigatorKey.currentState
          ?.pushNamed(MatchPage.routeName, arguments: matchId)
          .ignore();
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
