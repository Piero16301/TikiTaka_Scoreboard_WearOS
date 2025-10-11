import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:user_api/user_api.dart';
import 'package:user_repository/user_repository.dart';

part 'teams_state.dart';

class TeamsCubit extends Cubit<TeamsState> {
  TeamsCubit(this.userRepository) : super(const TeamsState());

  final UserRepository userRepository;

  void initCollections(int leagueId) {
    final teams = FirebaseFirestore.instance.collection(teamsCollection);
    final devices = FirebaseFirestore.instance.collection(devicesCollection);
    emit(
      state.copyWith(
        leagueId: leagueId,
        teamsCollection: teams,
        devicesCollection: devices,
      ),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? getTeams() {
    final snapshots = state.teamsCollection
        ?.where('competition.id', isEqualTo: state.leagueId)
        .orderBy('name')
        .snapshots();
    return snapshots;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? getDevices() {
    final snapshots = state.devicesCollection
        ?.where('token', isEqualTo: NotificationService.instance.token)
        .snapshots();
    return snapshots;
  }

  void toggleTeam({
    required Team team,
    required List<String> enabledTeams,
  }) {
    // Get FCM token
    final token = NotificationService.instance.token;

    // Update the enabled teams
    if (enabledTeams.contains(team.id.toString())) {
      unawaited(
        state.devicesCollection?.doc(token).update({
          'enabledTeams': FieldValue.arrayRemove([team.id.toString()]),
        }),
      );
    } else {
      unawaited(
        state.devicesCollection?.doc(token).update({
          'enabledTeams': FieldValue.arrayUnion([team.id.toString()]),
        }),
      );
    }
  }
}
