import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_wearos/notifications/notifications.dart';
import 'package:tiki_taka_scoreboard_wearos/teams/teams.dart';

class MockDatabaseService extends Mock implements DatabaseService {}

class MockLeague extends Mock implements League {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route<dynamic> {}

void main() {
  group('NotificationsPage and NotificationsView', () {
    late MockDatabaseService mockDatabase;
    late MockNavigatorObserver mockObserver;

    setUpAll(() async {
      mockDatabase = MockDatabaseService();

      if (getIt.isRegistered<DatabaseService>()) {
        await getIt.unregister<DatabaseService>();
      }
      getIt.registerSingleton<DatabaseService>(mockDatabase);

      registerFallbackValue(FakeRoute());
    });

    setUp(() {
      mockObserver = MockNavigatorObserver();
    });

    testWidgets(
        'renders NotificationsPage properly and shows shimmers when loading',
        (tester) async {
      when(() => mockDatabase.getLeaguesStream())
          .thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: NotificationsPage(),
        ),
      );

      expect(find.byType(NotificationsPage), findsOneWidget);
      expect(find.byType(NotificationsView), findsOneWidget);
    });

    testWidgets('shows error state when stream emits error', (tester) async {
      when(() => mockDatabase.getLeaguesStream())
          .thenAnswer((_) => Stream.error('Error'));

      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: NotificationsView(),
        ),
      );

      await tester.pump();

      expect(find.text('Error loading notifications'), findsOneWidget);
    });

    testWidgets('shows empty state when stream emits empty list',
        (tester) async {
      when(() => mockDatabase.getLeaguesStream())
          .thenAnswer((_) => Stream.value([]));

      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: NotificationsView(),
        ),
      );

      await tester.pump();

      expect(find.text('No notifications available'), findsOneWidget);
    });

    testWidgets('shows list of leagues when stream emits data', (tester) async {
      final mockLeague = MockLeague();
      when(() => mockLeague.code).thenReturn('PL');
      when(() => mockLeague.emblem).thenReturn('emblem.png');
      when(() => mockLeague.name).thenReturn('Premier League');

      when(() => mockDatabase.getLeaguesStream())
          .thenAnswer((_) => Stream.value([mockLeague]));

      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: NotificationsView(),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.textContaining('Premier League'), findsOneWidget);
      expect(find.byType(LeagueCardNotifications), findsOneWidget);
    });

    testWidgets('navigates to TeamsPage when icon button is pressed',
        (tester) async {
      final mockLeague = MockLeague();
      when(() => mockLeague.id).thenReturn(99);
      when(() => mockLeague.code).thenReturn('PL');
      when(() => mockLeague.emblem).thenReturn('emblem.png');
      when(() => mockLeague.name).thenReturn('Premier League');

      when(() => mockDatabase.getLeaguesStream())
          .thenAnswer((_) => Stream.value([mockLeague]));

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          navigatorObservers: [mockObserver],
          routes: {
            TeamsPage.routeName: (context) => const SizedBox(),
          },
          home: const NotificationsView(),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      final iconButtonFinder = find.byType(IconButton);
      expect(iconButtonFinder, findsOneWidget);

      await tester.tap(iconButtonFinder);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      verify(() => mockObserver.didPush(any(), any())).called(greaterThan(0));
    });
  });
}
