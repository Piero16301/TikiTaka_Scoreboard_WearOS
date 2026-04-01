import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class NotificationService {
  NotificationService({required NotificationRepository notificationRepository})
      : _notificationRepository = notificationRepository;

  final NotificationRepository _notificationRepository;

  Future<void> initialize() async {
    final performance = getIt<PerformanceService>();
    final trace = performance.startTrace('notification_service_initialization');
    await _notificationRepository.initialize();
    performance.stopTrace(trace);
  }

  String get token => _notificationRepository.token;

  Future<void> subscribeToTopic(String topic) async {
    await _notificationRepository.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _notificationRepository.unsubscribeFromTopic(topic);
  }
}
