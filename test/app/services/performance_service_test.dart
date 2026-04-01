import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class MockPerformanceRepository extends Mock implements PerformanceRepository {}

class MockTrace extends Mock implements Trace {}

void main() {
  group('PerformanceService', () {
    late MockPerformanceRepository mockRepository;
    late PerformanceService service;

    setUpAll(() {
      registerFallbackValue(MockTrace());
    });

    setUp(() {
      mockRepository = MockPerformanceRepository();
      service = PerformanceService(performanceRepository: mockRepository);
    });

    test('startTrace delegates to repository', () {
      final mockTrace = MockTrace();
      when(() => mockRepository.startTrace(any())).thenReturn(mockTrace);

      final result = service.startTrace('test_trace');

      expect(result, mockTrace);
      verify(() => mockRepository.startTrace('test_trace')).called(1);
    });

    test('stopTrace delegates to repository', () {
      final mockTrace = MockTrace();
      when(() => mockRepository.stopTrace(any())).thenReturn(null);

      service.stopTrace(mockTrace);

      verify(() => mockRepository.stopTrace(mockTrace)).called(1);
    });
  });
}
