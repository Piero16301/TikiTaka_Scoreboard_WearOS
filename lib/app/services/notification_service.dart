import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
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
    this._analyticsService,
  });

  final NotificationRepository _notificationRepository;
  final DatabaseService? _databaseService;
  final DeviceInfoService? _deviceInfoService;
  final LocalStorageService? _localStorageService;
  final PerformanceService? _performanceService;
  final CrashService? _crashService;
  final AnalyticsService? _analyticsService;

  Future<void>? _initializeFuture;
  StreamSubscription<String>? _registeredSubscription;
  StreamSubscription<RemoteMessage>? _messageSubscription;
  StreamSubscription<RemoteMessage>? _messageOpenedAppSubscription;

  T? _resolve<T extends Object>(T? local) =>
      local ?? (getIt.isRegistered<T>() ? getIt<T>() : null);

  DatabaseService get _db => _resolve(_databaseService)!;
  DeviceInfoService get _deviceInfo => _resolve(_deviceInfoService)!;
  LocalStorageService get _localStorage => _resolve(_localStorageService)!;
  PerformanceService? get _perf => _resolve(_performanceService);
  CrashService? get _crash => _resolve(_crashService);
  AnalyticsService? get _analytics => _resolve(_analyticsService);

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

      // Escuchar mensajes en primer plano
      _messageSubscription = _notificationRepository.onMessage.listen((
        message,
      ) {
        if (kDebugMode) {
          debugPrint('Foreground FCM message: ${message.data}');
        }
      });

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

      // Escuchar registro de token
      _registeredSubscription = _notificationRepository.onRegistered.listen((
        newToken,
      ) {
        if (newToken.isNotEmpty) {
          unawaited(syncDeviceAndTopics(newToken));
        }
      });
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
    final trace = _perf?.startTrace('device_sync_duration');

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
    } finally {
      if (trace != null) {
        _perf?.stopTrace(trace);
      }
    }
  }

  static String teamTopic(String teamId, String languageCode) =>
      'team_${teamId}_${languageCode.toLowerCase()}';

  Future<void> syncTeamsTopics(
    List<String> enabledTeams, {
    String? languageCode,
  }) async {
    if (enabledTeams.isEmpty) return;
    final trace = _perf?.startTrace('fcm_topics_sync_duration');
    final lang =
        languageCode ?? _localStorage.getLanguage()?.languageCode ?? 'en';
    try {
      await Future.wait(
        enabledTeams.map((teamId) => subscribeToTopic(teamTopic(teamId, lang))),
      );
    } on Exception catch (e, stackTrace) {
      _crash?.recordError(
        e,
        stackTrace,
        reason: 'NotificationService syncTeamsTopics error',
      );
    } finally {
      if (trace != null) {
        _perf?.stopTrace(trace);
      }
    }
  }

  Future<void> switchLanguageTopics({
    required String oldLanguageCode,
    required String newLanguageCode,
    required List<String> enabledTeams,
  }) async {
    if (enabledTeams.isEmpty || oldLanguageCode == newLanguageCode) return;
    try {
      final unsubs = enabledTeams.map(
        (teamId) => unsubscribeFromTopic(teamTopic(teamId, oldLanguageCode)),
      );
      final subs = enabledTeams.map(
        (teamId) => subscribeToTopic(teamTopic(teamId, newLanguageCode)),
      );
      await Future.wait([...unsubs, ...subs]);
    } on Exception catch (e, stackTrace) {
      _crash?.recordError(
        e,
        stackTrace,
        reason: 'NotificationService switchLanguageTopics error',
      );
    }
  }

  Future<void> toggleTeamTopic({
    required String teamId,
    required bool enabled,
    required String languageCode,
  }) async {
    final topic = teamTopic(teamId, languageCode);
    if (enabled) {
      await subscribeToTopic(topic);
    } else {
      await unsubscribeFromTopic(topic);
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
      _analytics?.logEvent(
        name: 'notification_opened',
        parameters: {'match_id': matchId, 'source': 'fcm'},
      );
      if (callback != null) {
        callback(matchId);
      } else {
        _navigateToMatch(matchId);
      }
    }
  }

  int? _parseMatchId(String raw) {
    final directParsed = int.tryParse(raw.trim());
    if (directParsed != null) {
      return directParsed > 0 && directParsed <= 999999999
          ? directParsed
          : null;
    }

    final matchIdToken = RegExp(r'matchId:\s*(-?\d+)').firstMatch(raw);
    if (matchIdToken != null) {
      final token = matchIdToken.group(1)!;
      if (token.startsWith('-') || token.length > 9) return null;
      final id = int.tryParse(token);
      return (id != null && id > 0) ? id : null;
    }

    final firstNumber = RegExp(r'-?\d+').firstMatch(raw)?.group(0);
    if (firstNumber == null ||
        firstNumber.startsWith('-') ||
        firstNumber.length > 9) {
      return null;
    }
    final id = int.tryParse(firstNumber);
    return (id != null && id > 0) ? id : null;
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

  Stream<String> get onRegistered => _notificationRepository.onRegistered;

  Future<void> subscribeToTopic(String topic) async {
    await _notificationRepository.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _notificationRepository.unsubscribeFromTopic(topic);
  }

  Future<void> dispose() async {
    await _registeredSubscription?.cancel();
    await _messageSubscription?.cancel();
    await _messageOpenedAppSubscription?.cancel();
  }
}
