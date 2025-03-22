import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_api/user_api.dart';
import 'package:user_repository/user_repository.dart';

part 'competitions_state.dart';

class CompetitionsCubit extends Cubit<CompetitionsState> {
  CompetitionsCubit(this.userRepository) : super(const CompetitionsState());

  final UserRepository userRepository;

  Future<void> loadLeagues() async {
    emit(state.copyWith(status: CompetitionsStatus.loading));
    try {
      final leagues = <League>[]..sort((a, b) => a.name.compareTo(b.name));
      final enabled = userRepository.getEnabledLeagues();
      emit(
        state.copyWith(
          status: CompetitionsStatus.success,
          leagues: leagues,
          enabled: Map.fromEntries(
            leagues.map(
              (league) => MapEntry(league.code, enabled.contains(league.code)),
            ),
          ),
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: CompetitionsStatus.failure));
    }
  }

  Future<void> toggleLeague({
    required String league,
    required bool enabled,
  }) async {
    try {
      emit(
        state.copyWith(
          enabled: Map<String, bool>.from(state.enabled)..[league] = enabled,
        ),
      );
      await userRepository.saveEnabledLeague(league: league, enabled: enabled);
    } catch (_) {
      emit(
        state.copyWith(
          enabled: Map<String, bool>.from(state.enabled)..[league] = !enabled,
        ),
      );
    }
  }
}
