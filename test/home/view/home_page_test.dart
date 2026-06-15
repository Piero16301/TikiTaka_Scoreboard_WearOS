import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/home/home.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';

class MockAppCubit extends MockCubit<AppState> implements AppCubit {}

class MockLocalStorageService extends Mock implements LocalStorageService {}

class MockDatabaseService extends Mock implements DatabaseService {}

class MockNotificationService extends Mock implements NotificationService {}

class MockDeviceInfoService extends Mock implements DeviceInfoService {}

void main() {
  group('HomePage', () {
    late MockAppCubit appCubit;

    setUpAll(() {
      getIt
        ..registerSingleton<LocalStorageService>(MockLocalStorageService())
        ..registerSingleton<DatabaseService>(MockDatabaseService())
        ..registerSingleton<NotificationService>(MockNotificationService())
        ..registerSingleton<DeviceInfoService>(MockDeviceInfoService());
    });

    setUp(() {
      appCubit = MockAppCubit();
      when(() => appCubit.state).thenReturn(const AppState());
      when(
        () => getIt<DatabaseService>()
            .getMatchesStream(enabledLeagues: any(named: 'enabledLeagues')),
      ).thenAnswer((_) => Stream.value([]));
      when(() => getIt<DatabaseService>().getConfigStream(id: any(named: 'id')))
          .thenAnswer(
        (_) => Stream.value(Config(id: '1', lastUpdate: DateTime.now())),
      );
      when(() => getIt<LocalStorageService>().getEnabledLeagues())
          .thenReturn([]);
    });

    testWidgets('renders HomePage properly', (tester) async {
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [BlocProvider<AppCubit>.value(value: appCubit)],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: HomePage(),
          ),
        ),
      );

      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(HomeView), findsOneWidget);
    });
  });
}
