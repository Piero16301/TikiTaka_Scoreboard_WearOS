import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

part 'teams_state.dart';

class TeamsCubit extends Cubit<TeamsState> {
  TeamsCubit() : super(const TeamsState());

  final NotificationService notification = getIt<NotificationService>();

  void initialize({required int leagueId}) {
    emit(state.copyWith(leagueId: leagueId));
  }
}
