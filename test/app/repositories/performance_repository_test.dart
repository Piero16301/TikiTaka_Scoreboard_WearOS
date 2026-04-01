import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class MockFirebasePerformance extends Mock implements FirebasePerformance {}
class MockTrace extends Mock implements Trace {}

void main() {
  group('FirebasePerformanceRepository', () {
    late MockFirebasePerformance mockPerformance;
    late FirebasePerformanceRepository repository;
    late MockTrace mockTrace;

    setUp(() {
      mockPerformance = MockFirebasePerformance();
      repository = FirebasePerformanceRepository(performance: mockPerformance);
      mockTrace = MockTrace();
    });

    test('startTrace creates, starts and returns a trace', () {
      when(() => mockPerformance.newTrace(any())).thenReturn(mockTrace);
      when(() => mockTrace.start()).thenAnswer((_) async {});

      final result = repository.startTrace('test_trace');

      expect(result, equals(mockTrace));
      verify(() => mockPerformance.newTrace('test_trace')).called(1);
      verify(() => mockTrace.start()).called(1);
    });

    test('stopTrace calls stop on the given trace', () {
      when(() => mockTrace.stop()).thenAnswer((_) async {});

      repository.stopTrace(mockTrace);

      verify(() => mockTrace.stop()).called(1);
    });
  });

  group('MockPerformanceRepository throws UnimplementedError', () {
    test('startTrace throws exception', () {
      final mockRepo = MockPerformanceRepository();
      expect(() => mockRepo.startTrace('test'), throwsUnimplementedError);
    });

    test('stopTrace throws exception', () {
      final mockRepo = MockPerformanceRepository();
      expect(() => mockRepo.stopTrace(MockTrace()), throwsUnimplementedError);
    });
  });
}
