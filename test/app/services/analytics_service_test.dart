import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class MockAnalyticsRepository extends Mock implements AnalyticsRepository {}

void main() {
  group('AnalyticsService', () {
    late MockAnalyticsRepository mockRepository;
    late AnalyticsService service;

    setUp(() {
      mockRepository = MockAnalyticsRepository();
      service = AnalyticsService(analyticsRepository: mockRepository);
    });

    test('logEvent delegates to repository', () {
      when(
        () => mockRepository.logEvent(
          name: any(named: 'name'),
          parameters: any(named: 'parameters'),
        ),
      ).thenReturn(null);

      service.logEvent(name: 'test_event', parameters: {'key': 'value'});

      verify(
        () => mockRepository.logEvent(
          name: 'test_event',
          parameters: {'key': 'value'},
        ),
      ).called(1);
    });

    test('setCurrentScreen delegates to repository', () {
      when(
        () => mockRepository.setCurrentScreen(
          screenName: any(named: 'screenName'),
        ),
      ).thenReturn(null);

      service.setCurrentScreen(screenName: 'Test Screen');

      verify(
        () => mockRepository.setCurrentScreen(screenName: 'Test Screen'),
      ).called(1);
    });
  });
}
