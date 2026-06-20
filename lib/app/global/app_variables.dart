import 'package:flutter/material.dart';

class AppVariables {
  static const String appName = 'Tiki Taka';
  static const Color defaultBaseColor = Colors.green;
  static const String defaultFontFamily = 'GoogleSansFlex';
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static final RouteObserver<PageRoute<dynamic>> routeObserver =
      RouteObserver<PageRoute<dynamic>>();
  static const String appOS = 'WEAROS';

  static const int numberOfShimmers = 5;
  static const double titleSize = 16;
  static const Color defaultColor = Colors.transparent;
  static const EdgeInsetsGeometry scaffoldPadding = EdgeInsets.symmetric(
    horizontal: 15,
  );
  static const double topScaffoldSpacing = 42;
  static const double bottomScaffoldSpacing = 90;
  static const double scaffoldSpacing = 10;
  static const double horizontalPaddingTitle = 10;
  static const double titlePaddingBottom = 22;
  static const double bottomScaffoldSpacingButton = 16;
  static const double titleTextHeight = 0.8;
  static const double cardSpacing = 5;
  static const double listSpacing = 4;
  static const double listFooterSpacing = 12;

  static const teamColorsMap = <String, Color>{
    'Black': Colors.black,
    'Blue': Colors.blue,
    'Brown': Colors.brown,
    'Claret': Color(0xFF7F1734),
    'Cyan': Colors.cyan,
    'Dark Blue': Colors.indigo,
    'Gold': Color(0xFFFFD700),
    'Green': Colors.green,
    'Light Blue': Colors.lightBlue,
    'Maroon': Color(0xFF800000),
    'Navy Blue': Color(0xFF000080),
    'Orange': Colors.orange,
    'Purple': Colors.purple,
    'Red': Colors.red,
    'Royal Blue': Color(0xFF4169E1),
    'Sky Blue': Colors.lightBlueAccent,
    'Violet': Colors.deepPurple,
    'White': Colors.white,
    'Yellow': Colors.yellow,
  };

  static Map<String, String> availableFonts = getAvailableFonts();

  static Map<String, String> getAvailableFonts() {
    return {
      'Google Sans Flex': 'GoogleSansFlex',
      'Merriweather': 'Merriweather',
      'Montserrat': 'Montserrat',
      'Nunito': 'Nunito',
      'Open Sans': 'OpenSans',
      'Orbitron': 'Orbitron',
      'Playfair Display': 'PlayfairDisplay',
      'Roboto': 'Roboto',
      'Source Code Pro': 'SourceCodePro',
    };
  }

  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('es', 'ES'),
    Locale('it', 'IT'),
    Locale('fr', 'FR'),
    Locale('de', 'DE'),
    Locale('pt', 'PT'),
  ];

  // Firestore collections
  static const String matchesCollection = 'matches';
  static const String configsCollection = 'configs';
  static const String leaguesCollection = 'leagues';
  static const String standingsCollection = 'standings';
  static const String teamsCollection = 'teams';
  static const String devicesCollection = 'devices';

  // Firestore fields
  static const String utcDate = 'utcDate';
  static const String emptyLeague = '';

  // Firebase Messaging topics
  static const String allDevicesTopic = 'all-devices';
  static const String wearOSTopic = 'platform-wearos';

  // Notification types
  static const String notificationTypeGoalHome = 'GOAL_HOME';
  static const String notificationTypeGoalAway = 'GOAL_AWAY';
  static const String notificationTypeMatchStatus = 'MATCH_STATUS';
}
