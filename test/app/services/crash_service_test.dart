import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class MockCrashRepository extends Mock implements CrashRepository {}

void main() {
  group('CrashService', () {
    late MockCrashRepository mockRepository;
    late CrashService service;

    setUpAll(() {
      registerFallbackValue(StackTrace.current);
      registerFallbackValue(<Object>[]);
    });

    setUp(() {
      mockRepository = MockCrashRepository();
      service = CrashService(crashRepository: mockRepository);
    });

    test(
      'recordError delegates to repository with correct default parameters',
      () {
        final exception = Exception('test error');
        final stackTrace = StackTrace.current;

        when(
          () => mockRepository.recordError(
            any<Object>(),
            any<StackTrace>(),
            reason: any<dynamic>(named: 'reason'),
            information: any<Iterable<Object>>(named: 'information'),
            fatal: any<bool>(named: 'fatal'),
          ),
        ).thenReturn(null);

        service.recordError(exception, stackTrace);

        verify(
          () => mockRepository.recordError(
            exception,
            stackTrace,
            fatal: false,
          ),
        ).called(1);
      },
    );

    test('recordError delegates to repository with given parameters', () {
      final exception = Exception('test error');
      final stackTrace = StackTrace.current;

      when(
        () => mockRepository.recordError(
          any<Object>(),
          any<StackTrace>(),
          reason: any<dynamic>(named: 'reason'),
          information: any<Iterable<Object>>(named: 'information'),
          fatal: any<bool>(named: 'fatal'),
        ),
      ).thenReturn(null);

      service.recordError(
        exception,
        stackTrace,
        reason: 'test reason',
        information: ['info1', 'info2'],
        fatal: true,
      );

      verify(
        () => mockRepository.recordError(
          exception,
          stackTrace,
          reason: 'test reason',
          information: ['info1', 'info2'],
          fatal: true,
        ),
      ).called(1);
    });

    test('log delegates to repository', () {
      when(() => mockRepository.log(any<String>())).thenReturn(null);

      service.log('test message');

      verify(() => mockRepository.log('test message')).called(1);
    });

    test('setCustomKey delegates to repository', () {
      when(
        () => mockRepository.setCustomKey(any<String>(), any<Object>()),
      ).thenReturn(null);

      service.setCustomKey('key', 'value');

      verify(() => mockRepository.setCustomKey('key', 'value')).called(1);
    });
  });
}
