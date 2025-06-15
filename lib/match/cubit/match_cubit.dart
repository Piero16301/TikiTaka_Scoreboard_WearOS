import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:tiki_taka/app/app.dart';
import 'package:user_repository/user_repository.dart';

part 'match_state.dart';

class MatchCubit extends Cubit<MatchState> {
  MatchCubit(this.userRepository) : super(const MatchState());

  final UserRepository userRepository;

  void initCollections(int matchId) {
    final matches = FirebaseFirestore.instance.collection(
      matchesCollection,
    );
    final configs = FirebaseFirestore.instance.collection(
      configsCollection,
    );
    final standings = FirebaseFirestore.instance.collection(
      standingsCollection,
    );
    emit(
      state.copyWith(
        matchId: matchId,
        matchesCollection: matches,
        configsCollection: configs,
        standingsCollection: standings,
      ),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? getMatch() {
    final snapshots = state.matchesCollection
        ?.where(
          'id',
          isEqualTo: state.matchId,
        )
        .snapshots();
    return snapshots;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? getStandings({
    required String leagueId,
  }) {
    final snapshots = state.standingsCollection
        ?.where(
          'id',
          isEqualTo: leagueId,
        )
        .snapshots();
    return snapshots;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? getMatchConfigs() {
    final snapshots = state.configsCollection
        ?.where('id', isEqualTo: matchesCollection)
        .snapshots();
    return snapshots;
  }
}
