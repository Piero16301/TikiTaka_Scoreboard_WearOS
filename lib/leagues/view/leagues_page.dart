import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka_scoreboard_wearos/leagues/leagues.dart';

class LeaguesPage extends StatelessWidget {
  const LeaguesPage({super.key});

  static const String routeName = '/leagues';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LeaguesCubit()..initialize(),
      child: LeaguesView(),
    );
  }
}
