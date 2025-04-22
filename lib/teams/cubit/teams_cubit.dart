import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:tiki_taka/app/app.dart';
import 'package:user_repository/user_repository.dart';

part 'teams_state.dart';

class TeamsCubit extends Cubit<TeamsState> {
  TeamsCubit(this.userRepository) : super(const TeamsState());

  final UserRepository userRepository;

  void initCollections(int leagueId) {
    final teams = FirebaseFirestore.instance.collection(teamsCollection);
    emit(
      state.copyWith(
        leagueId: leagueId,
        teamsCollection: teams,
        enabledTeams: {},
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

  Future<void> toggleTeam({
    required String team,
    required bool enabled,
  }) async {
    try {
      emit(
        state.copyWith(
          enabledTeams: Map<String, bool>.from(state.enabledTeams)
            ..[team] = enabled,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          enabledTeams: Map<String, bool>.from(state.enabledTeams)
            ..[team] = !enabled,
        ),
      );
    }
  }
}
