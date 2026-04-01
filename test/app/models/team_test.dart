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

    test('props contain all fields', () {
      const team = Team(
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
      );
      expect(team.props, [
        id,
        Area.empty,
        name,
        shortName,
        tla,
        crest,
        address,
        website,
        founded,
        clubColors,
        venue,
        const <League>[],
        Staff.empty,
        const <Staff>[],
        const <Staff>[],
      ]);
    });

    test('fromJson returns correct instance', () {
      final json = {
        'id': id,
        'name': name,
        'shortName': shortName,
        'tla': tla,
        'crest': crest,
        'address': address,
        'website': website,
        'founded': founded,
        'clubColors': clubColors,
        'venue': venue,
        'area': {'id': 1, 'name': 'Spain'},
        'runningCompetitions': [
          {'id': 1, 'name': 'La Liga'},
        ],
        'coach': {'id': 1, 'name': 'Xavi'},
        'squad': [
          {'id': 1, 'name': 'Pedri'},
        ],
        'staff': [
          {'id': 2, 'name': 'Staff'},
        ],
      };

      final team = Team.fromJson(json);
      expect(team.id, id);
      expect(team.name, name);
      expect(team.area?.name, 'Spain');
      expect(team.runningCompetitions, hasLength(1));
      expect(team.coach?.name, 'Xavi');
      expect(team.squad, hasLength(1));
      expect(team.staff, hasLength(1));
    });

    test('fromJson handles null values and missing fields', () {
      final team = Team.fromJson(const {});
      expect(team.id, 0);
      expect(team.name, '');
      expect(team.address, isNull);
    });

    test('empty team has correct default values', () {
      expect(Team.empty.id, 0);
      expect(Team.empty.name, '');
      expect(Team.empty.shortName, '');
      expect(Team.empty.tla, '');
    });
  });
}
