import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class MockNotificationRepository extends Mock
    implements NotificationRepository {}

class MockPerformanceService extends Mock implements PerformanceService {}

class MockTrace extends Mock implements Trace {}

void main() {
  group('NotificationService', () {
    late MockNotificationRepository mockRepository;
    late MockPerformanceService mockPerformance;
    late NotificationService notificationService;

    setUpAll(() async {
      registerFallbackValue(MockTrace());
      mockPerformance = MockPerformanceService();
      if (getIt.isRegistered<PerformanceService>()) {
        await getIt.unregister<PerformanceService>();
      }
      getIt.registerSingleton<PerformanceService>(mockPerformance);
    });

    setUp(() {
      mockRepository = MockNotificationRepository();

      when(() => mockPerformance.startTrace(any())).thenReturn(MockTrace());
      when(() => mockPerformance.stopTrace(any())).thenReturn(null);

      notificationService = NotificationService(
        notificationRepository: mockRepository,
      );
    });

    test('initialize calls repository and performance tracing', () async {
      when(() => mockRepository.initialize()).thenAnswer((_) async {});

      await notificationService.initialize();

      verify(
        () => mockPerformance.startTrace('notification_service_initialization'),
      ).called(1);
      verify(() => mockRepository.initialize()).called(1);
      verify(() => mockPerformance.stopTrace(any())).called(1);
    });

    test('subscribeToTopic delegates to repository', () async {
      when(
        () => mockRepository.subscribeToTopic(any()),
      ).thenAnswer((_) async {});
      await notificationService.subscribeToTopic('test_topic');
      verify(() => mockRepository.subscribeToTopic('test_topic')).called(1);
    });

    test('unsubscribeFromTopic delegates to repository', () async {
      when(
        () => mockRepository.unsubscribeFromTopic(any()),
      ).thenAnswer((_) async {});
      await notificationService.unsubscribeFromTopic('test_topic');
      verify(() => mockRepository.unsubscribeFromTopic('test_topic')).called(1);
    });

    test('token getter returns token from repository', () {
      when(() => mockRepository.token).thenReturn('mock_token_123');
      expect(notificationService.token, 'mock_token_123');
    });
  });
}
