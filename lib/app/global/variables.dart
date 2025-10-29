import 'package:flutter/material.dart';

class AppVariables {
  static const String appName = 'Tiki Taka';
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static const int numberOfShimmers = 5;
  static const double titleSize = 18;
  static const Color defaultColor = Colors.transparent;
  static const EdgeInsetsGeometry scaffoldPadding = EdgeInsets.symmetric(
    horizontal: 15,
  );
  static const double topScaffoldSpacing = 10;
  static const double bottomScaffoldSpacing = 40;
  static const double scaffoldSpacing = 10;
  static const double horizontalPaddingTitle = 30;
  static const double titleTextHeight = 0.8;
  static const double verticalPaddingBackButton = 10;
  static const colorMap = <String, Color>{
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
