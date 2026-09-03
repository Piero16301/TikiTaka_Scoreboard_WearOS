import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tiki_taka_scoreboard_wearos/match/match.dart';

class MatchPage extends StatelessWidget {
  const MatchPage({
    required this.matchId,
    super.key,
  });

  final int matchId;

  static const String routeName = '/match';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MatchCubit()..initialize(matchId: matchId),
      child: const MatchView(),
    );
  }
}
