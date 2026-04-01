import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_wearos/settings/settings.dart';

class MockSettingsCubit extends MockCubit<SettingsState>
    implements SettingsCubit {}

class MockDeviceInfoService extends Mock implements DeviceInfoService {}

class MockAnalyticsService extends Mock implements AnalyticsService {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route<dynamic> {}

void main() {
  group('SettingsPage and SettingsView', () {
    late MockSettingsCubit settingsCubit;
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
      settingsCubit = MockSettingsCubit();
      mockObserver = MockNavigatorObserver();
      when(() => settingsCubit.state).thenReturn(const SettingsState());

      final mockPackageInfo = AppPackageInfo(
        appName: 'Tiki Taka Scoreboard',
        version: '1.0.0',
        buildNumber: '10',
        updateTime: DateTime.now(),
      );
      when(() => mockDeviceInfo.packageInfo).thenReturn(mockPackageInfo);
    });

    testWidgets('renders SettingsPage and SettingsView correctly',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<SettingsCubit>.value(
            value: settingsCubit,
            child: const SettingsPage(),
          ),
        ),
      );

      expect(find.byType(SettingsPage), findsOneWidget);
      expect(find.byType(SettingsView), findsOneWidget);
      expect(find.text('Tiki Taka Scoreboard'), findsOneWidget);
      expect(find.textContaining('Version: 1.0.0 (10)'), findsOneWidget);
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
          home: BlocProvider<SettingsCubit>.value(
            value: settingsCubit,
            child: const SettingsView(),
          ),
        ),
      );

      final iconButtons = find.byType(IconButton);
      expect(iconButtons, findsWidgets);

      await tester.tap(iconButtons.first);
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
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<SettingsCubit>.value(
            value: settingsCubit,
            child: const SettingsView(),
          ),
        ),
      );

      expect(find.textContaining(RegExp(r'\d{2}:\d{2}:\d{2}')), findsOneWidget);
    });
  });
}
