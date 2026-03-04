import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class MockLocalStorageService extends Mock implements LocalStorageService {}

class MockDatabaseService extends Mock implements DatabaseService {}

class MockNotificationService extends Mock implements NotificationService {}

class MockDeviceInfoService extends Mock implements DeviceInfoService {}

void main() {
  group('AppPage', () {
    setUpAll(() {
      getIt
        ..registerSingleton<LocalStorageService>(MockLocalStorageService())
        ..registerSingleton<DatabaseService>(MockDatabaseService())
        ..registerSingleton<NotificationService>(MockNotificationService())
        ..registerSingleton<DeviceInfoService>(MockDeviceInfoService());
    });

    setUp(() {
      final mockLocalStorage = getIt<LocalStorageService>();
      when(mockLocalStorage.getLanguage).thenReturn(const Locale('en'));
      when(mockLocalStorage.getBaseColor).thenReturn(Colors.pink);
      when(mockLocalStorage.getFontFamily).thenReturn('Roboto');
      when(mockLocalStorage.getEnabledLeagues).thenReturn([]);

      final mockDatabase = getIt<DatabaseService>();
      when(
        () => mockDatabase.getMatches(
          enabledLeagues: any(named: 'enabledLeagues'),
        ),
      ).thenAnswer((_) => Stream.value([]));
      when(() => mockDatabase.getConfigs(id: any(named: 'id')))
          .thenAnswer((_) => Stream.value([]));
    });

    testWidgets('renders AppView properly', (tester) async {
      await tester.pumpWidget(const AppPage());
      expect(find.byType(AppView), findsOneWidget);
    });
  });
}
