import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

void main() {
  group('FirebaseAnalyticsRepository', () {
    late MockFirebaseAnalytics mockAnalytics;
    late FirebaseAnalyticsRepository repository;

    setUp(() {
      mockAnalytics = MockFirebaseAnalytics();
      repository = FirebaseAnalyticsRepository(analytics: mockAnalytics);
    });

    test('logEvent calls FirebaseAnalytics', () {
      when(
        () => mockAnalytics.logEvent(
          name: any(named: 'name'),
          parameters: any(named: 'parameters'),
        ),
      ).thenAnswer((_) async {});

      repository.logEvent(name: 'test_event', parameters: {'key': 'value'});

      verify(
        () => mockAnalytics.logEvent(
          name: 'test_event',
          parameters: {'key': 'value'},
        ),
      ).called(1);
    });

    test('setCurrentScreen logs screen_view event to FirebaseAnalytics', () {
      when(
        () => mockAnalytics.logEvent(
          name: 'screen_view',
          parameters: any(named: 'parameters'),
        ),
      ).thenAnswer((_) async {});

      repository.setCurrentScreen(screenName: 'Test Screen');

      verify(
        () => mockAnalytics.logEvent(
          name: 'screen_view',
          parameters: {'screen_name': 'Test Screen'},
        ),
      ).called(1);
    });
  });

  group('MockAnalyticsRepository', () {
    test('methods execute without error', () {
      final mockRepo = MockAnalyticsRepository();

      expect(
        () => mockRepo.logEvent(name: 'test', parameters: {'key': 'value'}),
        returnsNormally,
      );

      expect(
        () => mockRepo.setCurrentScreen(screenName: 'test_screen'),
        returnsNormally,
      );
    });
  });
}
