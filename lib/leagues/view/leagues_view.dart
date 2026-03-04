import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_wearos/leagues/leagues.dart';

class LeaguesView extends StatefulWidget {
  const LeaguesView({super.key});

  @override
  State<LeaguesView> createState() => _LeaguesViewState();
}

class _LeaguesViewState extends State<LeaguesView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final database = getIt<DatabaseService>();

    return StreamBuilder<List<League>>(
      stream: database.getLeagues(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return AppScaffold.basic(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.errorLeagues,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return AppScaffold.scrollable(
            controller: _scrollController,
            child: Column(
              spacing: AppVariables.scaffoldSpacing,
              children: [
                const SizedBox(height: AppVariables.topScaffoldSpacing),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppVariables.horizontalPaddingTitle,
                  ),
                  child: ScrollText(
                    text: l10n.titleLeagues.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppVariables.titleSize,
                    ),
                  ),
                ),
                ...List.generate(
                  AppVariables.numberOfShimmers,
                  (index) => const ShimmerCardLeagues(),
                ),
                const BackButtonCompetitions(),
                const SizedBox(height: AppVariables.bottomScaffoldSpacing),
              ],
            ),
          );
        }

        if (snapshot.data!.isEmpty) {
          return AppScaffold.basic(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.emptyLeagues,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final leagues = snapshot.data!;

        return AppScaffold.scrollable(
          controller: _scrollController,
          child: Column(
            spacing: AppVariables.scaffoldSpacing,
            children: [
              const SizedBox(height: AppVariables.topScaffoldSpacing),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppVariables.horizontalPaddingTitle,
                ),
                child: ScrollText(
                  text: l10n.titleLeagues.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppVariables.titleSize,
                  ),
                ),
              ),
              ...leagues.map(
                (league) => LeagueCardCompetitions(league: league),
              ),
              const BackButtonCompetitions(),
              const SizedBox(height: AppVariables.bottomScaffoldSpacing),
            ],
          ),
        );
      },
    );
  }
}

class ShimmerCardLeagues extends StatelessWidget {
  const ShimmerCardLeagues({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppCardData(
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: FittedBox(
              fit: BoxFit.fill,
              child: Switch(
                padding: EdgeInsets.zero,
                value: false,
                onChanged: null,
              ),
            ),
          ),
          SizedBox(width: 5),
          AppSchimmer(height: 40, width: 40),
          SizedBox(width: 5),
          Expanded(child: AppSchimmer()),
        ],
      ),
    );
  }
}

class LeagueCardCompetitions extends StatelessWidget {
  const LeagueCardCompetitions({
    required this.league,
    super.key,
  });

  final League league;

  @override
  Widget build(BuildContext context) {
    return AppCardData(
      child: Row(
        spacing: 5,
        children: [
          BlocBuilder<LeaguesCubit, LeaguesState>(
            builder: (context, state) {
              final enabled = state.enabledLeagues[league.code] ?? false;
              return SizedBox(
                width: 40,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Switch(
                    padding: EdgeInsets.zero,
                    value: enabled,
                    onChanged: (value) =>
                        context.read<LeaguesCubit>().toggleLeague(
                              league: league.code,
                              enabled: value,
                            ),
                  ),
                ),
              );
            },
          ),
          CrestImage(crest: league.emblem),
          Expanded(child: ScrollText(text: league.name)),
        ],
      ),
    );
  }
}

class BackButtonCompetitions extends StatelessWidget {
  const BackButtonCompetitions({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: AppFilledButton(
            onPressed: () => Navigator.of(context).pop(),
            label: l10n.backText.toUpperCase(),
          ),
        ),
      ],
    );
  }
}
