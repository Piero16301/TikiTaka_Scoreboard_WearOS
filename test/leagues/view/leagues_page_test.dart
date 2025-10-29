import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/leagues/leagues.dart';

void main() {
  group('LeaguesPage', () {
    test('has correct route name', () {
      expect(LeaguesPage.routeName, '/leagues');
    });
  });
}
