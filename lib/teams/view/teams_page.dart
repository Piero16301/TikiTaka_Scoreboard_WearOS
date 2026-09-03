import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tiki_taka_scoreboard_wearos/teams/teams.dart';

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
      create: (_) => TeamsCubit()..initialize(leagueId: leagueId),
      child: const TeamsView(),
    );
  }
}
