import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

const double scrollMagnitude = 10;
const Duration scrollDuration = Duration(milliseconds: 600);
const double scrollWidth = 5;
const double titleSize = 18;

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
