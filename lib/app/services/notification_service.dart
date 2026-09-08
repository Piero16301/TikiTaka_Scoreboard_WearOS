import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/match/match.dart';

class NotificationService {
  NotificationService({
    required this._notificationRepository,
    this._databaseService,
    this._deviceInfoService,
    this._localStorageService,
    this._performanceService,
    this._crashService,
  });

  final NotificationRepository _notificationRepository;
  final DatabaseService? _databaseService;
  final DeviceInfoService? _deviceInfoService;
  final LocalStorageService? _localStorageService;
  final PerformanceService? _performanceService;
  final CrashService? _crashService;

  Future<void>? _initializeFuture;
  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<RemoteMessage>? _messageSubscription;
  StreamSubscription<RemoteMessage>? _messageOpenedAppSubscription;

  DatabaseService get _db =>
      _databaseService ??
      (getIt.isRegistered<DatabaseService>()
          ? getIt<DatabaseService>()
          : null)!;

  DeviceInfoService get _deviceInfo =>
      _deviceInfoService ??
      (getIt.isRegistered<DeviceInfoService>()
          ? getIt<DeviceInfoService>()
          : null)!;

  LocalStorageService get _localStorage =>
      _localStorageService ??
      (getIt.isRegistered<LocalStorageService>()
          ? getIt<LocalStorageService>()
          : null)!;

  PerformanceService? get _perf =>
      _performanceService ??
      (getIt.isRegistered<PerformanceService>()
          ? getIt<PerformanceService>()
          : null);

  CrashService? get _crash =>
      _crashService ??
      (getIt.isRegistered<CrashService>() ? getIt<CrashService>() : null);

  Future<void> initialize({
    void Function(int matchId)? onMatchNotificationOpened,
  }) {
    return _initializeFuture ??= _initialize(
      onMatchNotificationOpened: onMatchNotificationOpened,
    );
  }

  Future<void> _initialize({
    void Function(int matchId)? onMatchNotificationOpened,
  }) async {
    final trace = _perf?.startTrace('notification_service_initialization');

    try {
      await _notificationRepository.initialize();

      // Escuchar mensajes en primer plano y mostrarlos
      _messageSubscription = _notificationRepository.onMessage.listen(
        _notificationRepository.showNotification,
      );

      // Manejar aperturas desde background
      _messageOpenedAppSubscription = _notificationRepository.onMessageOpenedApp
          .listen((message) {
            _handleMessage(message, onMatchNotificationOpened);
          });

      // Manejar apertura inicial (cold start)
      final initialMessage = await _notificationRepository.getInitialMessage();
      if (initialMessage != null) {
        _handleMessage(initialMessage, onMatchNotificationOpened);
      }

      // Sincronizar dispositivo y tópicos si hay token disponible
      final currentToken = _notificationRepository.token;
      if (currentToken.isNotEmpty) {
        await syncDeviceAndTopics(currentToken);
      }

      // Escuchar rotación de token
      _tokenRefreshSubscription = _notificationRepository.onTokenRefresh.listen(
        (newToken) {
          if (newToken.isNotEmpty) {
            unawaited(syncDeviceAndTopics(newToken));
          }
        },
      );
    } on Exception catch (e, stackTrace) {
      _crash?.recordError(
        e,
        stackTrace,
        reason: 'NotificationService initialization error',
      );
    } finally {
      if (trace != null) {
        _perf?.stopTrace(trace);
      }
    }
  }

  Future<void> syncDeviceAndTopics(String token) async {
    if (token.isEmpty) return;

    try {
      final isDbAvailable =
          _databaseService != null || getIt.isRegistered<DatabaseService>();
      final isDeviceAvailable =
          _deviceInfoService != null || getIt.isRegistered<DeviceInfoService>();
      final isStorageAvailable =
          _localStorageService != null ||
          getIt.isRegistered<LocalStorageService>();

      if (isDbAvailable && isDeviceAvailable && isStorageAvailable) {
        _db.updateDeviceSettings(
          token: token,
          deviceInfo: _deviceInfo.deviceInfo,
          language: _localStorage.getLanguage(),
        );

        final topicSubscriptions = <Future<void>>[
          subscribeToTopic(AppVariables.allDevicesTopic),
        ];

        if (_deviceInfo.deviceInfo.isPhysicalDevice ?? false) {
          topicSubscriptions.add(subscribeToTopic(AppVariables.wearOSTopic));
        } else {
          debugPrint('Running on emulator, not subscribing to WearOS topic');
        }

        await Future.wait(topicSubscriptions);
      }
    } on Exception catch (e, stackTrace) {
      _crash?.recordError(
        e,
        stackTrace,
        reason: 'NotificationService syncDeviceAndTopics error',
      );
    }
  }

  void _handleMessage(
    RemoteMessage message,
    void Function(int matchId)? callback,
  ) {
    final rawMatch = message.data['matchId'] ?? message.data['match'];
    if (rawMatch == null) return;

    final matchId = _parseMatchId(rawMatch.toString());
    if (matchId != null) {
      if (callback != null) {
        callback(matchId);
      } else {
        _navigateToMatch(matchId);
      }
    }
  }

  int? _parseMatchId(String raw) {
    final directParsed = int.tryParse(raw);
    if (directParsed != null) return directParsed;

    if (raw.contains('matchId:')) {
      final after = raw.split('matchId:')[1];
      return int.tryParse(after.replaceAll(RegExp(r'[^\d]'), ''));
    }

    final digitsOnly = raw.replaceAll(RegExp(r'[^\d]'), '');
    return int.tryParse(digitsOnly);
  }

  void _navigateToMatch(int matchId) {
    void navigate() {
      AppVariables.navigatorKey.currentState
          ?.pushNamed(MatchPage.routeName, arguments: matchId)
          .ignore();
    }

    if (AppVariables.navigatorKey.currentState != null) {
      navigate();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => navigate());
    }
  }

  String get token => _notificationRepository.token;

  Future<void> subscribeToTopic(String topic) async {
    await _notificationRepository.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _notificationRepository.unsubscribeFromTopic(topic);
  }

  Future<void> dispose() async {
    await _tokenRefreshSubscription?.cancel();
    await _messageSubscription?.cancel();
    await _messageOpenedAppSubscription?.cancel();
  }
}
