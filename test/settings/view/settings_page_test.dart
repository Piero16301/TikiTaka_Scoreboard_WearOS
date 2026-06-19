import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_wearos/settings/settings.dart';

class MockDeviceInfoService extends Mock implements DeviceInfoService {}

class MockAnalyticsService extends Mock implements AnalyticsService {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route<dynamic> {}

void main() {
  group('SettingsPage and SettingsView', () {
    late MockDeviceInfoService mockDeviceInfo;
    late MockNavigatorObserver mockObserver;

    setUpAll(() async {
      mockDeviceInfo = MockDeviceInfoService();

      if (getIt.isRegistered<DeviceInfoService>()) {
        await getIt.unregister<DeviceInfoService>();
      }
      if (getIt.isRegistered<AnalyticsService>()) {
        await getIt.unregister<AnalyticsService>();
      }
      getIt
        ..registerSingleton<DeviceInfoService>(mockDeviceInfo)
        ..registerSingleton<AnalyticsService>(MockAnalyticsService());

      registerFallbackValue(FakeRoute());
    });

    setUp(() {
      mockObserver = MockNavigatorObserver();

      final mockPackageInfo = AppPackageInfo(
        appName: 'Tiki Taka Scoreboard',
        version: '1.0.0',
        buildNumber: '10',
        updateTime: DateTime.now(),
      );
      when(() => mockDeviceInfo.packageInfo).thenReturn(mockPackageInfo);
    });

    testWidgets('renders SettingsPage and SettingsView correctly', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SettingsPage(),
        ),
      );

      expect(find.byType(SettingsPage), findsOneWidget);
      expect(find.byType(SettingsView), findsOneWidget);
      expect(find.text('Tiki Taka Scoreboard'), findsOneWidget);
      expect(find.textContaining('1.0.0 (10)'), findsOneWidget);
    });

    testWidgets('taps on ConfigurationSetting to navigate', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          navigatorObservers: [mockObserver],
          routes: {
            '/leagues': (context) => const SizedBox(),
            '/notifications': (context) => const SizedBox(),
            '/languages': (context) => const SizedBox(),
            '/themes': (context) => const SizedBox(),
            '/typography': (context) => const SizedBox(),
          },
          home: const SettingsView(),
        ),
      );

      final settings = find.byType(ConfigurationSetting);
      expect(settings, findsWidgets);

      await tester.tap(settings.first);
      await tester.pumpAndSettle();

      verify(() => mockObserver.didPush(any(), any())).called(greaterThan(0));
    });

    testWidgets('getDateOn handles same day format properly', (tester) async {
      final mockPackageInfo = AppPackageInfo(
        appName: 'Tiki Taka Scoreboard',
        version: '1.0.0',
        buildNumber: '10',
        updateTime: DateTime.now(),
      );

      when(() => mockDeviceInfo.packageInfo).thenReturn(mockPackageInfo);

      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SettingsView(),
        ),
      );

      expect(find.textContaining(RegExp(r'\d{2}:\d{2}:\d{2}')), findsOneWidget);
    });
  });
}
