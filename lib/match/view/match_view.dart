import 'dart:async';

import 'package:flutter/material.dart' hide Table;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_wearos/match/match.dart';
import 'package:tiki_taka_scoreboard_wearos/team/team.dart';

class MatchView extends StatefulWidget {
  const MatchView({super.key});

  @override
  State<MatchView> createState() => _MatchViewState();
}

class _MatchViewState extends State<MatchView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final matchId = context.read<MatchCubit>().state.matchId;
    final database = getIt<DatabaseService>();

    return StreamBuilder<List<Match>>(
      stream: database.getMatch(matchId: matchId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return AppScaffold.basic(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.errorMatch,
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
                    text: l10n.titleMatch.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppVariables.titleSize,
                      height: AppVariables.titleTextHeight,
                    ),
                  ),
                ),
                const LastUpdateMatch(isLoading: true),
                const ShimmerTeamsCardMatch(),
                const ShimmerRefereeCardMatch(),
                const ShimmerCompetitionCardMatch(),
                const ShimmerStandingsMatch(),
                const BackButtonMatch(),
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
                    l10n.notFoundMatch,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const BackButtonMatch(),
                ],
              ),
            ),
          );
        }

        final match = snapshot.data!.first;

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
                  text: l10n.titleMatch.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppVariables.titleSize,
                    height: AppVariables.titleTextHeight,
                  ),
                ),
              ),
              const LastUpdateMatch(),
              TeamsCardMatch(match: match),
              if (match.referees.isNotEmpty)
                RefereeCardMatch(referees: match.referees),
              CompetitionCardMatch(match: match),
              StandingsMatch(match: match),
              const BackButtonMatch(),
              const SizedBox(height: AppVariables.bottomScaffoldSpacing),
            ],
          ),
        );
      },
    );
  }
}

class LastUpdateMatch extends StatefulWidget {
  const LastUpdateMatch({
    this.isLoading = false,
    super.key,
  });

  final bool isLoading;

  @override
  State<LastUpdateMatch> createState() => _LastUpdateMatchState();
}

class _LastUpdateMatchState extends State<LastUpdateMatch>
    with WidgetsBindingObserver {
  late StreamSubscription<void> _nowSubscription;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _nowSubscription = Stream<void>.periodic(
      const Duration(seconds: 1),
    ).listen((_) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_nowSubscription.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final database = getIt<DatabaseService>();

    if (widget.isLoading) {
      return Text(
        l10n.updatingMatches,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      );
    }

    return StreamBuilder<List<Config>>(
      stream: database.getConfigs(id: AppVariables.matchesCollection),
      builder: (context, snapshot) {
        final configs = snapshot.data ??
            [
              Config(
                id: AppVariables.matchesCollection,
                lastUpdate: DateTime.now(),
              ),
            ];

        if (configs.isEmpty) {
          configs.add(
            Config(
              id: AppVariables.matchesCollection,
              lastUpdate: DateTime.now(),
            ),
          );
        }

        final delta = DateTime.now().difference(configs.first.lastUpdate);

        return Text(
          l10n.updatedSecondsAgo(delta.inSeconds),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        );
      },
    );
  }
}

class ShimmerTeamsCardMatch extends StatelessWidget {
  const ShimmerTeamsCardMatch({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCardData(
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: SizedBox.shrink()),
              SizedBox(
                width: 20,
                child: Center(
                  child: Text(
                    l10n.halfTimeAbbr,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              SizedBox(
                width: 20,
                child: Center(
                  child: Text(
                    l10n.fullTimeAbbr,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          const Row(
            children: [
              AppSchimmer(height: 35, width: 35),
              SizedBox(width: 5),
              Expanded(child: AppSchimmer()),
              SizedBox(width: 5),
              SizedBox(
                width: 20,
                child: AppSchimmer(width: 20),
              ),
              SizedBox(width: 5),
              SizedBox(
                width: 20,
                child: AppSchimmer(width: 20),
              ),
              SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 5),
          const Row(
            children: [
              AppSchimmer(height: 35, width: 35),
              SizedBox(width: 5),
              Expanded(child: AppSchimmer()),
              SizedBox(width: 5),
              SizedBox(
                width: 20,
                child: AppSchimmer(width: 20),
              ),
              SizedBox(width: 5),
              SizedBox(
                width: 20,
                child: AppSchimmer(width: 20),
              ),
              SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 5),
          const AppSchimmer(width: 100),
        ],
      ),
    );
  }
}

class TeamsCardMatch extends StatelessWidget {
  const TeamsCardMatch({
    required this.match,
    super.key,
  });

  final Match match;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCardData(
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: SizedBox.shrink()),
              SizedBox(
                width: 20,
                child: Center(
                  child: Text(
                    l10n.halfTimeAbbr,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              SizedBox(
                width: 20,
                child: Center(
                  child: Text(
                    l10n.fullTimeAbbr,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
              TeamPage.routeName,
              arguments: match.homeTeam.id,
            ),
            child: Row(
              children: [
                CrestImage(
                  crest: match.homeTeam.crest,
                  fit: BoxFit.cover,
                  dimension: 35,
                ),
                const SizedBox(width: 5),
                Expanded(child: ScrollText(text: match.homeTeam.name)),
                const SizedBox(width: 5),
                SizedBox(
                  width: 20,
                  child: Center(
                    child: Text(
                      match.score.halfTime.home.toString(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                SizedBox(
                  width: 20,
                  child: Center(
                    child: Text(
                      match.score.fullTime.home.toString(),
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
              TeamPage.routeName,
              arguments: match.awayTeam.id,
            ),
            child: Row(
              children: [
                CrestImage(
                  crest: match.awayTeam.crest,
                  fit: BoxFit.cover,
                  dimension: 35,
                ),
                const SizedBox(width: 5),
                Expanded(child: ScrollText(text: match.awayTeam.name)),
                const SizedBox(width: 5),
                SizedBox(
                  width: 20,
                  child: Center(
                    child: Text(
                      match.score.halfTime.away.toString(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                SizedBox(
                  width: 20,
                  child: Center(
                    child: Text(
                      match.score.fullTime.away.toString(),
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            AppFunctions.getMatchState(match.status, match.utcDate!, l10n),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerRefereeCardMatch extends StatelessWidget {
  const ShimmerRefereeCardMatch({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCardData(
      child: Column(
        children: [
          Text(
            l10n.refereeMatch.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedWhistle,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSchimmer(),
                    SizedBox(height: 5),
                    AppSchimmer(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RefereeCardMatch extends StatelessWidget {
  const RefereeCardMatch({
    required this.referees,
    super.key,
  });

  final List<Referee> referees;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCardData(
      child: Column(
        children: [
          Text(
            l10n.refereeMatch.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 5),
          ...referees.map((referee) {
            return Row(
              children: [
                HugeIcon(
                  icon: HugeIcons.strokeRoundedWhistle,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ScrollText(
                        text: referee.name,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        referee.nationality,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class ShimmerCompetitionCardMatch extends StatelessWidget {
  const ShimmerCompetitionCardMatch({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCardData(
      child: Column(
        children: [
          Text(
            l10n.competitionMatch.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              AppSchimmer(height: 30, width: 30),
              SizedBox(width: 10),
              Expanded(child: AppSchimmer()),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              AppSchimmer(height: 30, width: 30),
              SizedBox(width: 10),
              Expanded(child: AppSchimmer()),
            ],
          ),
          const SizedBox(height: 10),
          const AppSchimmer(width: 100),
          const SizedBox(height: 5),
          const AppSchimmer(width: 50),
        ],
      ),
    );
  }
}

class CompetitionCardMatch extends StatelessWidget {
  const CompetitionCardMatch({
    required this.match,
    super.key,
  });

  final Match match;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCardData(
      child: Column(
        children: [
          Text(
            l10n.competitionMatch.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              CrestImage(
                crest: match.area.flag,
                fit: BoxFit.cover,
                dimension: 30,
              ),
              const SizedBox(width: 10),
              Expanded(child: ScrollText(text: match.area.name)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              CrestImage(
                crest: match.competition.emblem,
                fit: BoxFit.cover,
                dimension: 30,
              ),
              const SizedBox(width: 10),
              Expanded(child: ScrollText(text: match.competition.name)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${l10n.seasonMatch} ${match.season.startDate!.year}'
            '-${match.season.endDate!.year}',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '${l10n.matchdayMatch} ${match.matchday}',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerStandingsMatch extends StatelessWidget {
  const ShimmerStandingsMatch({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCardData(
      child: Column(
        children: [
          Text(
            l10n.standingsMatch.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 5),
          Column(
            spacing: 5,
            children: [
              Row(
                children: [
                  const Expanded(child: SizedBox.shrink()),
                  SizedBox(
                    width: 21,
                    child: Center(
                      child: Text(
                        l10n.playedGamesAbbr,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  SizedBox(
                    width: 21,
                    child: Center(
                      child: Text(
                        l10n.goalDifferenceAbbr,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  SizedBox(
                    width: 21,
                    child: Center(
                      child: Text(
                        l10n.pointsAbbr,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ...List.generate(
                AppVariables.numberOfShimmers * 4,
                (index) => Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2.5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    spacing: 5,
                    children: [
                      SizedBox(
                        width: 20,
                        child: Center(
                          child: Text(
                            (index + 1).toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const AppSchimmer(height: 25, width: 25),
                      const Expanded(child: AppSchimmer()),
                      const SizedBox(
                        width: 21,
                        child: AppSchimmer(width: 21),
                      ),
                      const SizedBox(
                        width: 21,
                        child: AppSchimmer(width: 21),
                      ),
                      const SizedBox(
                        width: 21,
                        child: AppSchimmer(width: 21),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StandingsMatch extends StatelessWidget {
  const StandingsMatch({
    required this.match,
    super.key,
  });

  final Match match;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final database = getIt<DatabaseService>();

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: database.getStandings(leagueId: match.competition.id.toString()),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const SizedBox.shrink();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ShimmerStandingsMatch();
        }

        if (snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final result = snapshot.data!;
        if (result.isEmpty || result.length > 1) {
          return const SizedBox.shrink();
        }

        final standingsList =
            result.first[AppVariables.standingsCollection] as List<dynamic>? ??
                [];
        if (standingsList.isEmpty) {
          return const SizedBox.shrink();
        }

        final standings = standingsList
            .map(
              (standing) =>
                  Standing.fromJson(standing as Map<String, dynamic>? ?? {}),
            )
            .toList();

        if (standings.length == 1) {
          return AppCardData(
            child: Column(
              children: [
                Text(
                  l10n.standingsMatch.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                Column(
                  spacing: 5,
                  children: [
                    Row(
                      children: [
                        const Expanded(child: SizedBox.shrink()),
                        SizedBox(
                          width: 25,
                          child: Center(
                            child: Text(
                              l10n.playedGamesAbbr,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                          width: 25,
                          child: Center(
                            child: Text(
                              l10n.goalDifferenceAbbr,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                          width: 25,
                          child: Center(
                            child: Text(
                              l10n.pointsAbbr,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ...standings.first.table.map(
                      (row) => Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2.5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: getRowStandingColor(row, match),
                        ),
                        child: Row(
                          spacing: 5,
                          children: [
                            SizedBox(
                              width: 20,
                              child: Center(
                                child: Text(
                                  row.position.toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            CrestImage(
                              crest: row.team.crest,
                              dimension: 25,
                            ),
                            Expanded(
                              child: Text(
                                row.team.tla,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            PointTextMatch(
                              value: row.playedGames,
                            ),
                            PointTextMatch(
                              value: row.goalDifference,
                            ),
                            PointTextMatch(
                              value: row.points,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return Column(
            spacing: AppVariables.scaffoldSpacing,
            children: standings
                .map(
                  (standing) => AppCardData(
                    child: Column(
                      children: [
                        Text(
                          standing.group.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Column(
                          spacing: 5,
                          children: [
                            Row(
                              children: [
                                const Expanded(child: SizedBox.shrink()),
                                SizedBox(
                                  width: 25,
                                  child: Center(
                                    child: Text(
                                      l10n.playedGamesAbbr,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                SizedBox(
                                  width: 25,
                                  child: Center(
                                    child: Text(
                                      l10n.goalDifferenceAbbr,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                SizedBox(
                                  width: 25,
                                  child: Center(
                                    child: Text(
                                      l10n.pointsAbbr,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ...standing.table.map(
                              (row) => Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2.5,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: getRowStandingColor(row, match),
                                ),
                                child: Row(
                                  spacing: 5,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      child: Center(
                                        child: Text(
                                          row.position.toString(),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    CrestImage(
                                      crest: row.team.crest,
                                      dimension: 25,
                                    ),
                                    Expanded(
                                      child: Text(
                                        row.team.tla,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    PointTextMatch(
                                      value: row.playedGames,
                                    ),
                                    PointTextMatch(
                                      value: row.goalDifference,
                                    ),
                                    PointTextMatch(
                                      value: row.points,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          );
        }
      },
    );
  }

  Color? getRowStandingColor(Table row, Match match) {
    if (row.team.id == match.homeTeam.id) {
      return Colors.blue.withValues(alpha: 0.2);
    } else if (row.team.id == match.awayTeam.id) {
      return Colors.red.withValues(alpha: 0.2);
    }
    return null;
  }
}

class PointTextMatch extends StatelessWidget {
  const PointTextMatch({
    required this.value,
    super.key,
  });

  final int value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 25,
      child: Center(
        child: Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class BackButtonMatch extends StatelessWidget {
  const BackButtonMatch({super.key});

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
