import 'package:flutter/material.dart';
import 'package:tiki_taka_scoreboard_wearos/notifications/notifications.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  static const String routeName = '/notifications';

  @override
  Widget build(BuildContext context) {
    return const NotificationsView();
  }
}
