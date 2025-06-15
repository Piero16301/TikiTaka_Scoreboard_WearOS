import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka/app/app.dart';
import 'package:user_repository/user_repository.dart';

part 'team_state.dart';

class TeamCubit extends Cubit<TeamState> {
  TeamCubit(this.userRepository) : super(const TeamState());

  final UserRepository userRepository;

  void initCollections(int teamId) {
    final teams = FirebaseFirestore.instance.collection(teamsCollection);
    final configs = FirebaseFirestore.instance.collection(configsCollection);
    emit(
      state.copyWith(
        teamId: teamId,
        teamsCollection: teams,
        configsCollection: configs,
      ),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? getTeam() {
    final snapshots =
        state.teamsCollection?.where('id', isEqualTo: state.teamId).snapshots();
    return snapshots;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? getTeamConfigs() {
    final snapshots = state.configsCollection
        ?.where('id', isEqualTo: teamsCollection)
        .snapshots();
    return snapshots;
  }
}
