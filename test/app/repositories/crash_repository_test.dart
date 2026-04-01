import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class MockFirebaseCrashlytics extends Mock implements FirebaseCrashlytics {}

void main() {
  group('CrashlyticsCrashRepository', () {
    late MockFirebaseCrashlytics mockCrashlytics;
    late CrashlyticsCrashRepository repository;

    setUp(() {
      mockCrashlytics = MockFirebaseCrashlytics();
      repository = CrashlyticsCrashRepository(crashlytics: mockCrashlytics);
    });

    test('log calls FirebaseCrashlytics', () {
      when(() => mockCrashlytics.log(any<String>())).thenAnswer((_) async {});

      repository.log('test message');

      verify(() => mockCrashlytics.log('test message')).called(1);
    });

    test('recordError calls FirebaseCrashlytics with formatted params', () {
      final exception = Exception('error');
      final stack = StackTrace.current;

      when(
        () => mockCrashlytics.recordError(
          any<dynamic>(),
          any<StackTrace?>(),
          reason: any<dynamic>(named: 'reason'),
          information: any<Iterable<Object>>(named: 'information'),
          fatal: any<bool>(named: 'fatal'),
        ),
      ).thenAnswer((_) async {});

      repository.recordError(
        exception,
        stack,
        reason: 'test reason',
        information: ['info'],
      );

      verify(
        () => mockCrashlytics.recordError(
          exception,
          stack,
          reason: 'test reason',
          information: ['info'],
        ),
      ).called(1);
    });

    test('recordError passes fatal flag correctly to FirebaseCrashlytics', () {
      const exception = ';(';
      final stack = StackTrace.current;

      when(
        () => mockCrashlytics.recordError(
          any<dynamic>(),
          any<StackTrace?>(),
          reason: any<dynamic>(named: 'reason'),
          information: any<Iterable<Object>>(named: 'information'),
          fatal: any<bool>(named: 'fatal'),
        ),
      ).thenAnswer((_) async {});

      repository.recordError(
        exception,
        stack,
        fatal: true,
      );

      verify(
        () => mockCrashlytics.recordError(
          exception,
          stack,
          fatal: true,
        ),
      ).called(1);
    });

    test('setCustomKey calls FirebaseCrashlytics', () {
      when(() => mockCrashlytics.setCustomKey(any<String>(), any<Object>()))
          .thenAnswer((_) async {});

      repository.setCustomKey('app_key', 'some_value');

      verify(() => mockCrashlytics.setCustomKey('app_key', 'some_value'))
          .called(1);
    });
  });

  group('MockCrashRepository', () {
    test('methods execute without error', () {
      final mockRepo = MockCrashRepository();

      expect(() => mockRepo.log('test'), returnsNormally);

      expect(
        () => mockRepo.recordError(Exception('e'), StackTrace.current),
        returnsNormally,
      );

      expect(
        () => mockRepo.setCustomKey('key', 'val'),
        returnsNormally,
      );
    });
  });
}
