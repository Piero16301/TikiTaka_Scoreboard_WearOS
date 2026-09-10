import 'package:firebase_messaging/firebase_messaging.dart';
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
      await Future.wait([requestPermission(), getToken()]);
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
