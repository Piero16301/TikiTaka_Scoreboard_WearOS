import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

const double scrollMagnitude = 10;
const Duration scrollDuration = Duration(milliseconds: 600);
const double scrollWidth = 5;
const double titleSize = 18;
const String defaultColorIcon = '⚪';
const colorMap = <String, String>{
  'Black': '⚫',
  'Blue': '🔵',
  'White': '⚪',
  'Gold': '🟡',
  'Red': '🔴',
  'Green': '🟢',
  'Yellow': '🟡',
  'Orange': '🟠',
  'Maroon': '🟤',
};
const String defaultScoreIcon = '0️⃣';
const scoreMap = <int, String>{
  0: '0️⃣',
  1: '1️⃣',
  2: '2️⃣',
  3: '3️⃣',
  4: '4️⃣',
  5: '5️⃣',
  6: '6️⃣',
  7: '7️⃣',
  8: '8️⃣',
  9: '9️⃣',
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
