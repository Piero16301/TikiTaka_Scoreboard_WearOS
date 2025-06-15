import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

const int numberOfShimmers = 5;
const double scrollMagnitude = 10;
const Duration scrollDuration = Duration(milliseconds: 600);
const double scrollWidth = 5;
const double titleSize = 18;
const Color defaultColor = Colors.transparent;
const colorMap = <String, Color>{
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
const String matchesCollection = 'matches';
const String configsCollection = 'configs';
const String leaguesCollection = 'leagues';
const String standingsCollection = 'standings';
const String teamsCollection = 'teams';
const String notDevicesCollection = 'notification-devices';

// Firestore fields
const String utcDate = 'utcDate';
const String emptyLeague = '';

// Firebase Messaging topics
const String allDevicesTopic = 'all-devices';
const String wearOSTopic = 'platform-wearos';

// Notification types
const String notificationTypeGoalHome = 'GOAL_HOME';
const String notificationTypeGoalAway = 'GOAL_AWAY';
const String notificationTypeMatchStatus = 'MATCH_STATUS';
