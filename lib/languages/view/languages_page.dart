import 'package:material_ui/material_ui.dart';
import 'package:tiki_taka_scoreboard_wearos/languages/languages.dart';

class LanguagesPage extends StatelessWidget {
  const LanguagesPage({super.key});

  static const String routeName = '/languages';

  @override
  Widget build(BuildContext context) {
    return const LanguagesView();
  }
}
