import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:tiki_taka/app/app.dart';
import 'package:user_repository/user_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.userRepository) : super(const HomeState());

  final UserRepository userRepository;

  void initCollections() {
    final matches = FirebaseFirestore.instance.collection(matchesCollection);
    final configs = FirebaseFirestore.instance.collection(configsCollection);

    emit(
      state.copyWith(
        matchesCollection: matches,
        configsCollection: configs,
      ),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? getMatches() {
    // final enabledLeagues = userRepository.getEnabledLeagues();
    // final nowDate = DateTime.now();
    final enabledLeagues = ['PL', 'PD'];
    final nowDate = DateTime(2025, 03, 16);

    final snapshots = state.matchesCollection
        ?.where('competition.code', whereIn: enabledLeagues)
        .where(
          'utcDate',
          isGreaterThan: DateTime(nowDate.year, nowDate.month, nowDate.day),
        )
        .where(
          'utcDate',
          isLessThan: DateTime(nowDate.year, nowDate.month, nowDate.day + 1),
        )
        .orderBy('utcDate', descending: false)
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
