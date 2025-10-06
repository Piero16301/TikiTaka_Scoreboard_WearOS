import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka_scoreboard_wearos/team/team.dart';
import 'package:user_repository/user_repository.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({
    required this.teamId,
    super.key,
  });

  final int teamId;

  static const String routeName = '/team';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          TeamCubit(context.read<UserRepository>())..initCollections(teamId),
      child: TeamView(),
    );
  }
}
