import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'team_state.dart';

class TeamCubit extends Cubit<TeamState> {
  TeamCubit() : super(const TeamState());

  void initialize({required int teamId}) {
    emit(state.copyWith(teamId: teamId));
  }
}
