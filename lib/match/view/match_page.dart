import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka/match/match.dart';
import 'package:user_api/user_api.dart';
import 'package:user_repository/user_repository.dart';

class MatchPage extends StatelessWidget {
  const MatchPage({
    required this.match,
    super.key,
  });

  final Match match;

  static const String routeName = '/match';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          MatchCubit(context.read<UserRepository>())..initCollections(match),
      child: MatchView(),
    );
  }
}
