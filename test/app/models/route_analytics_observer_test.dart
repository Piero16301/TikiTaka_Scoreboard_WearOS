import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class MockAnalyticsService extends Mock implements AnalyticsService {}

class StubPageRoute extends PageRoute<void> {
  StubPageRoute({this.name});

  final String? name;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Container();
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration.zero;

  @override
  RouteSettings get settings => RouteSettings(name: name);
}

void main() {
  group('RouteAnalyticsObserver', () {
    late AnalyticsService mockAnalytics;
    late RouteAnalyticsObserver observer;

    setUp(() {
      mockAnalytics = MockAnalyticsService();
      observer = RouteAnalyticsObserver(analyticsService: mockAnalytics);
    });

    test('didPush sends screen view when route has name', () {
      final route = StubPageRoute(name: 'test_screen');
      observer.didPush(route, null);
      verify(
        () => mockAnalytics.setCurrentScreen(screenName: 'test_screen'),
      ).called(1);
    });

    test('didPop sends screen view of previous route when it has a name', () {
      final route = StubPageRoute(name: 'popped_screen');
      final previousRoute = StubPageRoute(name: 'previous_screen');
      observer.didPop(route, previousRoute);
      verify(
        () => mockAnalytics.setCurrentScreen(screenName: 'previous_screen'),
      ).called(1);
    });

    test('didRemove sends screen view of the new top route', () {
      final route = StubPageRoute(name: 'removed_screen');
      final previousRoute = StubPageRoute(name: 'new_top_screen');
      observer.didRemove(route, previousRoute);
      verify(
        () => mockAnalytics.setCurrentScreen(screenName: 'new_top_screen'),
      ).called(1);
    });

    test('didReplace sends screen view of new route', () {
      final newRoute = StubPageRoute(name: 'new_route');
      final oldRoute = StubPageRoute(name: 'old_route');
      observer.didReplace(newRoute: newRoute, oldRoute: oldRoute);
      verify(
        () => mockAnalytics.setCurrentScreen(screenName: 'new_route'),
      ).called(1);
    });

    test('didChangeTop sends screen view of the new top route', () {
      final topRoute = StubPageRoute(name: 'top_route');
      observer.didChangeTop(topRoute, null);
      verify(
        () => mockAnalytics.setCurrentScreen(screenName: 'top_route'),
      ).called(1);
    });

    test('does not send screen view if route settings name is null', () {
      final route = StubPageRoute();
      observer.didPush(route, null);
      verifyNever(
        () => mockAnalytics.setCurrentScreen(
          screenName: any(named: 'screenName'),
        ),
      );
    });
  });
}
