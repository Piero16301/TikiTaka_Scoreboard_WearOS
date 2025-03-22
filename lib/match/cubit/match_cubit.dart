import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_api/user_api.dart';
import 'package:user_repository/user_repository.dart';

part 'match_state.dart';

class MatchCubit extends Cubit<MatchState> {
  MatchCubit(this.userRepository) : super(const MatchState());

  final UserRepository userRepository;

  Future<void> init(Match match) async {
    emit(state.copyWith(status: StandingsStatus.loading, match: match));
    try {
      final standings = <Standing>[];
      emit(
        state.copyWith(
          status: StandingsStatus.success,
          standings: standings,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: StandingsStatus.failure));
    }
  }
}
