import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide Table;
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

abstract class DatabaseRepository {
  void updateDeviceSettings({
    required String token,
    AppDeviceInfo? deviceInfo,
    Locale? language,
    int? teamToModify,
    List<String>? enabledTeams,
  });
  Stream<Match> getMatchStream({required int matchId});
  Stream<List<Match>> getMatchesStream({
    required List<String> enabledLeagues,
  });
  Stream<Config> getConfigStream({required String id});
  Stream<List<League>> getLeaguesStream();
  Stream<LeagueStandings> getStandingsStream({
    required String leagueId,
  });
  Stream<Team> getTeamStream({required int teamId});
  Stream<List<Team>> getTeamsStream({int? leagueId});
  Stream<Device> getDeviceStream({required String token});
}

class MockDatabaseRepository implements DatabaseRepository {
  static const _barca = Team(
    id: 81,
    name: 'FC Barcelona',
    shortName: 'Barça',
    tla: 'FCB',
    crest: 'https://crests.football-data.org/81.png',
  );

  static const _madrid = Team(
    id: 86,
    name: 'Real Madrid CF',
    shortName: 'Real Madrid',
    tla: 'RMA',
    crest: 'https://crests.football-data.org/86.png',
  );

  static const _newcastle = Team(
    id: 67,
    name: 'Newcastle United FC',
    shortName: 'Newcastle',
    tla: 'NEW',
    crest: 'https://crests.football-data.org/67.png',
  );

  static const _villarreal = Team(
    id: 94,
    name: 'Villarreal CF',
    shortName: 'Villarreal',
    tla: 'VIL',
    crest: 'https://crests.football-data.org/94.png',
  );

  static const _atleti = Team(
    id: 78,
    name: 'Club Atlético de Madrid',
    shortName: 'Atleti',
    tla: 'ATM',
    crest: 'https://crests.football-data.org/78.png',
  );

  static const _betis = Team(
    id: 90,
    name: 'Real Betis Balompié',
    shortName: 'Betis',
    tla: 'BET',
    crest: 'https://crests.football-data.org/90.png',
  );

  static final List<Team> _teams = [
    _barca,
    _madrid,
    _newcastle,
    _villarreal,
    _atleti,
    _betis,
  ];

  static final List<League> _leagues = [
    League(
      id: 2014,
      name: 'Primera Division',
      code: 'PD',
      type: 'LEAGUE',
      emblem: 'https://crests.football-data.org/laliga.png',
      area: const Area(
        id: 2224,
        name: 'Spain',
        code: 'ESP',
        flag: 'https://crests.football-data.org/760.svg',
      ),
      plan: 'TIER_ONE',
      currentSeason: Season(
        id: 2292,
        startDate: DateTime(2024, 08, 18),
        endDate: DateTime(2025, 05, 25),
        currentMatchday: 35,
      ),
      numberOfAvailableSeasons: 95,
      lastUpdated: DateTime(2025, 05, 11),
    ),
    League(
      id: 2001,
      name: 'UEFA Champions League',
      code: 'CL',
      type: 'CUP',
      emblem: 'https://crests.football-data.org/CL.png',
      area: const Area(
        id: 2077,
        name: 'Europe',
        code: 'EUR',
        flag: 'https://crests.football-data.org/EUR.svg',
      ),
      plan: 'TIER_ONE',
      currentSeason: Season(
        id: 2454,
        startDate: DateTime(2025, 09, 16),
        endDate: DateTime(2026, 05, 30),
        currentMatchday: 8,
      ),
      numberOfAvailableSeasons: 95,
      lastUpdated: DateTime(2026, 03, 18),
    ),
  ];

  static final List<Match> _matches = [
    Match(
      area: const Area(
        id: 2224,
        name: 'Spain',
        code: 'ESP',
        flag: 'https://crests.football-data.org/760.svg',
      ),
      competition: const League(
        id: 2014,
        name: 'Primera Division',
        code: 'PD',
        type: 'LEAGUE',
        emblem: 'https://crests.football-data.org/laliga.png',
      ),
      season: Season(
        id: 2292,
        startDate: DateTime(2024, 08, 18),
        endDate: DateTime(2025, 05, 25),
        currentMatchday: 35,
      ),
      id: 498957,
      utcDate: DateTime(2025, 05, 11, 09, 15),
      status: 'FINISHED',
      matchday: 35,
      stage: 'REGULAR_SEASON',
      lastUpdated: DateTime(2025, 05, 11),
      homeTeam: _barca,
      awayTeam: _madrid,
      score: const Score(
        winner: 'HOME_TEAM',
        duration: 'REGULAR',
        fullTime: Time(home: 4, away: 3),
        halfTime: Time(home: 4, away: 2),
      ),
      odds: const Odds(
        message: 'Activate Odds-Package in User-Panel to retrieve odds.',
      ),
      referees: const [
        Referee(
          id: 206208,
          name: 'Alejandro Hernández Hernández',
          type: 'REFEREE',
          nationality: 'Spain',
        ),
      ],
    ),
    Match(
      area: const Area(
        id: 2077,
        name: 'Europe',
        code: 'EUR',
        flag: 'https://crests.football-data.org/EUR.svg',
      ),
      competition: const League(
        id: 2001,
        name: 'UEFA Champions League',
        code: 'CL',
        type: 'CUP',
        emblem: 'https://crests.football-data.org/CL.png',
      ),
      season: Season(
        id: 2454,
        startDate: DateTime(2025, 09, 16),
        endDate: DateTime(2026, 05, 30),
        currentMatchday: 8,
      ),
      id: 552080,
      utcDate: DateTime(2026, 03, 18, 12, 45),
      status: 'IN_PLAY',
      matchday: 8,
      stage: 'LAST_16',
      lastUpdated: DateTime(2026, 03, 18),
      homeTeam: _barca,
      awayTeam: _newcastle,
      score: const Score(
        winner: 'HOME_TEAM',
        duration: 'REGULAR',
        fullTime: Time(home: 7, away: 2),
        halfTime: Time(home: 3, away: 2),
      ),
      odds: const Odds(
        message: 'Activate Odds-Package in User-Panel to retrieve odds.',
      ),
      referees: const [
        Referee(
          id: 43918,
          name: 'François Letexier',
          type: 'REFEREE',
          nationality: 'France',
        ),
      ],
    ),
  ];

  static final List<Standing> _standings = [
    const Standing(
      stage: 'REGULAR_SEASON',
      type: 'TOTAL',
      table: [
        Table(
          position: 1,
          team: _barca,
          playedGames: 29,
          won: 24,
          draw: 1,
          lost: 4,
          points: 73,
          goalsFor: 78,
          goalsAgainst: 28,
          goalDifference: 50,
        ),
        Table(
          position: 2,
          team: _madrid,
          playedGames: 29,
          won: 24,
          draw: 1,
          lost: 4,
          points: 73,
          goalsFor: 78,
          goalsAgainst: 28,
          goalDifference: 50,
        ),
        Table(
          position: 3,
          team: _villarreal,
          playedGames: 29,
          won: 15,
          draw: 8,
          lost: 6,
          points: 53,
          goalsFor: 45,
          goalsAgainst: 30,
          goalDifference: 15,
        ),
        Table(
          position: 4,
          team: _atleti,
          playedGames: 29,
          won: 16,
          draw: 4,
          lost: 9,
          points: 52,
          goalsFor: 48,
          goalsAgainst: 32,
          goalDifference: 16,
        ),
        Table(
          position: 5,
          team: _betis,
          playedGames: 29,
          won: 14,
          draw: 7,
          lost: 8,
          points: 49,
          goalsFor: 40,
          goalsAgainst: 35,
          goalDifference: 5,
        ),
      ],
    ),
  ];

  @override
  void updateDeviceSettings({
    required String token,
    AppDeviceInfo? deviceInfo,
    Locale? language,
    int? teamToModify,
    List<String>? enabledTeams,
  }) {}

  @override
  Stream<Match> getMatchStream({required int matchId}) {
    return Stream.value(_matches.first);
  }

  @override
  Stream<List<Match>> getMatchesStream({
    required List<String> enabledLeagues,
  }) {
    return Stream.value(_matches);
  }

  @override
  Stream<Config> getConfigStream({required String id}) {
    return Stream.value(
      Config(
        id: id,
        lastUpdate: DateTime.now().subtract(const Duration(seconds: 30)),
      ),
    );
  }

  @override
  Stream<List<League>> getLeaguesStream() {
    return Stream.value(_leagues);
  }

  @override
  Stream<LeagueStandings> getStandingsStream({
    required String leagueId,
  }) {
    return Stream.value(
      LeagueStandings(
        leagueId: leagueId,
        standings: _standings,
      ),
    );
  }

  @override
  Stream<Team> getTeamStream({required int teamId}) {
    return Stream.value(_barca);
  }

  @override
  Stream<List<Team>> getTeamsStream({int? leagueId}) {
    return Stream.value(_teams);
  }

  @override
  Stream<Device> getDeviceStream({required String token}) {
    return Stream.value(
      Device(
        token: token,
        language: const Locale('en', 'US'),
        lastOpenAt: DateTime.now(),
        platform: Platform.wearOS,
        enabledTeams: const ['81', '86', '31', '285', '71', '78'],
      ),
    );
  }
}

class FirestoreDatabaseRepository implements DatabaseRepository {
  FirestoreDatabaseRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  void updateDeviceSettings({
    required String token,
    AppDeviceInfo? deviceInfo,
    Locale? language,
    int? teamToModify,
    List<String>? enabledTeams,
  }) {
    final data = <String, dynamic>{
      if (deviceInfo != null) ...{
        'platform': AppVariables.appOS,
        'token': token,
        'lastOpenAt': FieldValue.serverTimestamp(),
        'wearOSInfo': deviceInfo.toJson(),
      },
      if (language != null) 'language': language.toShortString,
    };

    if (data.isNotEmpty) {
      unawaited(
        _firestore
            .collection(AppVariables.devicesCollection)
            .doc(token)
            .set(data, SetOptions(mergeFields: data.keys.toList())),
      );
    }

    if (teamToModify != null) {
      if (enabledTeams!.contains(teamToModify.toString())) {
        unawaited(
          _firestore
              .collection(AppVariables.devicesCollection)
              .doc(token)
              .update({
            'enabledTeams': FieldValue.arrayRemove([teamToModify.toString()]),
          }),
        );
      } else {
        unawaited(
          _firestore
              .collection(AppVariables.devicesCollection)
              .doc(token)
              .update({
            'enabledTeams': FieldValue.arrayUnion([teamToModify.toString()]),
          }),
        );
      }
    }
  }

  @override
  Stream<Match> getMatchStream({required int matchId}) {
    return _firestore
        .collection(AppVariables.matchesCollection)
        .doc(matchId.toString())
        .snapshots()
        .map((snapshot) => Match.fromJson(snapshot.data()!));
  }

  @override
  Stream<List<Match>> getMatchesStream({
    required List<String> enabledLeagues,
  }) {
    final nowDate = DateTime.now();
    // final nowDate = DateTime(2026, 03, 18);

    return _firestore
        .collection(AppVariables.matchesCollection)
        .where(
          'competition.code',
          whereIn: (enabledLeagues.isEmpty
              ? [AppVariables.emptyLeague]
              : enabledLeagues),
        )
        .where(
          'utcDate',
          isGreaterThan: DateTime(nowDate.year, nowDate.month, nowDate.day),
        )
        .where(
          'utcDate',
          isLessThan: DateTime(nowDate.year, nowDate.month, nowDate.day + 1),
        )
        .orderBy('utcDate', descending: false)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs.map((doc) => Match.fromJson(doc.data())).toList();
      },
    );
  }

  @override
  Stream<Config> getConfigStream({required String id}) {
    return _firestore
        .collection(AppVariables.configsCollection)
        .doc(id)
        .snapshots()
        .map((snapshot) => Config.fromJson(snapshot.data()!));
  }

  @override
  Stream<List<League>> getLeaguesStream() {
    return _firestore
        .collection(AppVariables.leaguesCollection)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs.map((doc) => League.fromJson(doc.data())).toList();
      },
    );
  }

  @override
  Stream<LeagueStandings> getStandingsStream({
    required String leagueId,
  }) {
    return _firestore
        .collection(AppVariables.standingsCollection)
        .doc(leagueId)
        .snapshots()
        .map((snapshot) => LeagueStandings.fromJson(snapshot.data()!));
  }

  @override
  Stream<Team> getTeamStream({required int teamId}) {
    return _firestore
        .collection(AppVariables.teamsCollection)
        .where('id', isEqualTo: teamId)
        .snapshots()
        .map((snapshot) => Team.fromJson(snapshot.docs.first.data()));
  }

  @override
  Stream<List<Team>> getTeamsStream({int? leagueId}) {
    var query =
        _firestore.collection(AppVariables.teamsCollection).orderBy('name');

    if (leagueId != null) {
      query = query.where('competition.id', isEqualTo: leagueId);
    }

    return query.snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) => Team.fromJson(doc.data())).toList();
      },
    );
  }

  @override
  Stream<Device> getDeviceStream({required String token}) {
    return _firestore
        .collection(AppVariables.devicesCollection)
        .doc(token)
        .snapshots()
        .map((snapshot) => Device.fromJson(snapshot.data()!));
  }
}
