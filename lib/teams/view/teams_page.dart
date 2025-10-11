import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka_scoreboard_wearos/teams/teams.dart';
import 'package:user_repository/user_repository.dart';

class TeamsPage extends StatelessWidget {
  const TeamsPage({
    required this.leagueId,
    super.key,
  });

  final int leagueId;

  static const String routeName = '/teams';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          TeamsCubit(context.read<UserRepository>())..initCollections(leagueId),
      child: TeamsView(),
    );
  }
}
