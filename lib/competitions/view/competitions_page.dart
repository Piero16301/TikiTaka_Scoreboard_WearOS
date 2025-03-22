import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka/competitions/competitions.dart';
import 'package:user_repository/user_repository.dart';

class CompetitionsPage extends StatelessWidget {
  const CompetitionsPage({super.key});

  static const String routeName = '/competitions';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CompetitionsCubit(context.read<UserRepository>())..loadLeagues(),
      child: CompetitionsView(),
    );
  }
}
