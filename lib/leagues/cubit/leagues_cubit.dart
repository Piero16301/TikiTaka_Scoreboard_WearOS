import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:user_repository/user_repository.dart';

part 'leagues_state.dart';

class LeaguesCubit extends Cubit<LeaguesState> {
  LeaguesCubit(this.userRepository) : super(const LeaguesState());

  final UserRepository userRepository;

  void initCollections() {
    final leagues = FirebaseFirestore.instance.collection(
      AppVariables.leaguesCollection,
    );
    final enabledLeagues = userRepository.getEnabledLeagues();
    emit(
      state.copyWith(
        leaguesCollection: leagues,
        enabledLeagues: Map.fromEntries(
          enabledLeagues.map((league) => MapEntry(league, true)),
        ),
      ),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? getLeagues() {
    final snapshots = state.leaguesCollection?.snapshots();
    return snapshots;
  }

  Future<void> toggleLeague({
    required String league,
    required bool enabled,
  }) async {
    try {
      emit(
        state.copyWith(
          enabledLeagues: Map<String, bool>.from(state.enabledLeagues)
            ..[league] = enabled,
        ),
      );
      await userRepository.saveEnabledLeague(league: league, enabled: enabled);
    } on Exception {
      emit(
        state.copyWith(
          enabledLeagues: Map<String, bool>.from(state.enabledLeagues)
            ..[league] = !enabled,
        ),
      );
    }
  }
}
