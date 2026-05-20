import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

part 'leagues_state.dart';

class LeaguesCubit extends Cubit<LeaguesState> {
  LeaguesCubit() : super(const LeaguesState());

  final LocalStorageService localStorage = getIt<LocalStorageService>();

  void initialize() {
    final enabledLeagues = localStorage.getEnabledLeagues() ?? [];
    emit(
      state.copyWith(
        enabledLeagues: Map.fromEntries(
          enabledLeagues.map((league) => MapEntry(league, true)),
        ),
      ),
    );
  }

  void toggleLeague({required String league}) {
    final enabled = !(state.enabledLeagues[league] ?? false);
    try {
      localStorage.saveEnabledLeague(league: league, enabled: enabled);
      emit(
        state.copyWith(
          enabledLeagues: Map<String, bool>.from(state.enabledLeagues)
            ..[league] = enabled,
        ),
      );
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
