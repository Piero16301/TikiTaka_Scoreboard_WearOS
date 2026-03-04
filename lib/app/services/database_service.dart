import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class DatabaseService {
  DatabaseService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  FirebaseFirestore get firestore => _firestore;

  void saveLanguage({
    required String token,
    required Locale language,
  }) {
    unawaited(
      _firestore.collection(AppVariables.devicesCollection).doc(token).set(
        {
          'language': language.toShortString,
        },
        SetOptions(merge: true),
      ),
    );
  }

  void setLocalSettingsDevice({
    required String token,
    required AndroidDeviceInfo androidInfo,
    Locale? localLanguage,
  }) {
    unawaited(
      _firestore.collection(AppVariables.devicesCollection).doc(token).set(
        {
          'platform': AppVariables.appOS,
          'token': token,
          'lastOpenAt': FieldValue.serverTimestamp(),
          'wearOSInfo': androidInfo.toJson(),
          'macOsInfo': null,
          'windowsInfo': null,
          'androidInfo': null,
          'iosInfo': null,
          'webInfo': null,
          'language': localLanguage?.toShortString ?? 'en_US',
          'enabledTeams': FieldValue.arrayUnion(<String>[]),
        },
        SetOptions(merge: true),
      ),
    );
  }

  Stream<List<Match>> getMatches({required List<String> enabledLeagues}) {
    final nowDate = DateTime.now();
    // final nowDate = DateTime(2026, 02, 28);

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

  Stream<List<Config>> getConfigs({required String id}) {
    return _firestore
        .collection(AppVariables.configsCollection)
        .where('id', isEqualTo: id)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs.map((doc) => Config.fromJson(doc.data())).toList();
      },
    );
  }

  Stream<List<League>> getLeagues() {
    return _firestore
        .collection(AppVariables.leaguesCollection)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs.map((doc) => League.fromJson(doc.data())).toList();
      },
    );
  }

  Stream<List<Match>> getMatch({required int matchId}) {
    return _firestore
        .collection(AppVariables.matchesCollection)
        .where('id', isEqualTo: matchId)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs.map((doc) => Match.fromJson(doc.data())).toList();
      },
    );
  }

  Stream<List<Map<String, dynamic>>> getStandings({
    required String leagueId,
  }) {
    return _firestore
        .collection(AppVariables.standingsCollection)
        .where('id', isEqualTo: leagueId)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs.map((doc) => doc.data()).toList();
      },
    );
  }

  Stream<List<Team>> getTeam({required int teamId}) {
    return _firestore
        .collection(AppVariables.teamsCollection)
        .where('id', isEqualTo: teamId)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs.map((doc) => Team.fromJson(doc.data())).toList();
      },
    );
  }

  Stream<List<Team>> getTeamsByLeague({required int leagueId}) {
    return _firestore
        .collection(AppVariables.teamsCollection)
        .where('competition.id', isEqualTo: leagueId)
        .orderBy('name')
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs.map((doc) => Team.fromJson(doc.data())).toList();
      },
    );
  }

  Stream<List<Map<String, dynamic>>> getDevices({required String token}) {
    return _firestore
        .collection(AppVariables.devicesCollection)
        .where('token', isEqualTo: token)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs.map((doc) => doc.data()).toList();
      },
    );
  }

  void changeEnabledTeams({
    required int teamId,
    required String token,
    required List<String> enabledTeams,
  }) {
    if (enabledTeams.contains(teamId.toString())) {
      unawaited(
        _firestore
            .collection(AppVariables.devicesCollection)
            .doc(token)
            .update({
          'enabledTeams': FieldValue.arrayRemove([teamId.toString()]),
        }),
      );
    } else {
      unawaited(
        _firestore
            .collection(AppVariables.devicesCollection)
            .doc(token)
            .update({
          'enabledTeams': FieldValue.arrayUnion([teamId.toString()]),
        }),
      );
    }
  }
}
