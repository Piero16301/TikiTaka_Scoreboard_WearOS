import 'package:flutter/material.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class DatabaseService {
  DatabaseService({required DatabaseRepository databaseRepository})
      : _databaseRepository = databaseRepository;

  final DatabaseRepository _databaseRepository;

  void updateDeviceSettings({
    required String token,
    AppDeviceInfo? deviceInfo,
    Locale? language,
    int? teamToModify,
    List<String>? enabledTeams,
  }) {
    _databaseRepository.updateDeviceSettings(
      token: token,
      deviceInfo: deviceInfo,
      language: language,
      teamToModify: teamToModify,
      enabledTeams: enabledTeams,
    );
  }

  Stream<Match> getMatchStream({required int matchId}) {
    return _databaseRepository.getMatchStream(matchId: matchId);
  }

  Stream<List<Match>> getMatchesStream({
    required List<String> enabledLeagues,
  }) {
    return _databaseRepository.getMatchesStream(enabledLeagues: enabledLeagues);
  }

  Stream<Config> getConfigStream({required String id}) {
    return _databaseRepository.getConfigStream(id: id);
  }

  Stream<List<League>> getLeaguesStream() {
    return _databaseRepository.getLeaguesStream();
  }

  Stream<LeagueStandings> getStandingsStream({
    required String leagueId,
  }) {
    return _databaseRepository.getStandingsStream(leagueId: leagueId);
  }

  Stream<Team> getTeamStream({required int teamId}) {
    return _databaseRepository.getTeamStream(teamId: teamId);
  }

  Stream<List<Team>> getTeamsStream({int? leagueId}) {
    return _databaseRepository.getTeamsStream(leagueId: leagueId);
  }

  Stream<Device> getDeviceStream({required String token}) {
    return _databaseRepository.getDeviceStream(token: token);
  }
}
