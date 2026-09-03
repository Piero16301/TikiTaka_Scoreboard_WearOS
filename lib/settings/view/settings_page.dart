import 'package:material_ui/material_ui.dart';
import 'package:tiki_taka_scoreboard_wearos/settings/settings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const String routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return const SettingsView();
  }
}
