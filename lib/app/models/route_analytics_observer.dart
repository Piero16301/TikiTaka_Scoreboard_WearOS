import 'package:material_ui/material_ui.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class RouteAnalyticsObserver extends NavigatorObserver {
  RouteAnalyticsObserver({required this.analyticsService});

  final AnalyticsService analyticsService;

  void _sendScreenView(PageRoute<dynamic> route) {
    final screenName = route.settings.name;
    if (screenName != null) {
      analyticsService.setCurrentScreen(screenName: screenName);
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute && route.settings.name != null) {
      _sendScreenView(route);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && previousRoute.settings.name != null) {
      _sendScreenView(previousRoute);
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    if (previousRoute is PageRoute && previousRoute.settings.name != null) {
      _sendScreenView(previousRoute);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute && newRoute.settings.name != null) {
      _sendScreenView(newRoute);
    }
  }

  @override
  void didChangeTop(
    Route<dynamic> topRoute,
    Route<dynamic>? previousTopRoute,
  ) {
    super.didChangeTop(topRoute, previousTopRoute);
    if (topRoute is PageRoute && topRoute.settings.name != null) {
      _sendScreenView(topRoute);
    }
  }
}
