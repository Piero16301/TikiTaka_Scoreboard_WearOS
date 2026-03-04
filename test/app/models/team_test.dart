import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

void main() {
  group('Team', () {
    const id = 1;
    const name = 'FC Barcelona';
    const shortName = 'Barça';
    const tla = 'FCB';
    const crest = 'crest.png';
    const address = 'Camp Nou';
    const website = 'fcbarcelona.com';
    const founded = 1899;
    const clubColors = 'Blue and Red';
    const venue = 'Camp Nou';

    test('supports value comparisons', () {
      expect(
        const Team(
          id: id,
          area: Area.empty,
          name: name,
          shortName: shortName,
          tla: tla,
          crest: crest,
          address: address,
          website: website,
          founded: founded,
          clubColors: clubColors,
          venue: venue,
          runningCompetitions: [],
          coach: Staff.empty,
          squad: [],
          staff: [],
        ),
        const Team(
          id: id,
          area: Area.empty,
          name: name,
          shortName: shortName,
          tla: tla,
          crest: crest,
          address: address,
          website: website,
          founded: founded,
          clubColors: clubColors,
          venue: venue,
          runningCompetitions: [],
          coach: Staff.empty,
          squad: [],
          staff: [],
        ),
      );
    });

    test('empty team has correct default values', () {
      expect(Team.empty.id, 0);
      expect(Team.empty.name, '');
      expect(Team.empty.shortName, '');
      expect(Team.empty.tla, '');
    });
  });
}
