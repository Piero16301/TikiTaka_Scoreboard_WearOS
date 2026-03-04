import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

void main() {
  setUp(getIt.reset);

  group('dependencies.dart', () {
    test('getIt is initially empty', () {
      expect(getIt, isA<GetIt>());
    });

    test('setupServiceLocator registers services as lazy singletons', () {
      setupServiceLocator();

      expect(getIt.isRegistered<DatabaseService>(), isTrue);
      expect(getIt.isRegistered<DeviceInfoService>(), isTrue);
      expect(getIt.isRegistered<LocalStorageService>(), isTrue);
      expect(getIt.isRegistered<NotificationService>(), isTrue);
    });
  });
}
