import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka_scoreboard_wearos/match/match.dart';
import 'package:user_repository/user_repository.dart';

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
      create: (_) =>
          MatchCubit(context.read<UserRepository>())..initCollections(matchId),
      child: MatchView(),
    );
  }
}
