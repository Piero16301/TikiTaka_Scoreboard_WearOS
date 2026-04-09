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
  final _scrollController = ScrollController(keepScrollOffset: false);
  late final Stream<Match> _matchStream;

  @override
  void initState() {
    super.initState();
    final matchId = context.read<MatchCubit>().state.matchId;
    final database = getIt<DatabaseService>();
    _matchStream = database.getMatchStream(matchId: matchId);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StreamBuilder<Match>(
      stream: _matchStream,
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
                AppTitleText(
                  title: l10n.titleMatch.toUpperCase(),
                  hasBottomSpacing: false,
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

        if (snapshot.data == null) {
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

        final match = snapshot.data!;

        return AppScaffold.scrollable(
          controller: _scrollController,
          child: Column(
            spacing: AppVariables.scaffoldSpacing,
            children: [
              const SizedBox(height: AppVariables.topScaffoldSpacing),
              AppTitleText(
                title: l10n.titleMatch.toUpperCase(),
                hasBottomSpacing: false,
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
  late final Stream<Config> _configStream;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _nowSubscription = Stream<void>.periodic(
      const Duration(seconds: 1),
    ).listen((_) => setState(() {}));
    _configStream = getIt<DatabaseService>().getConfigStream(
      id: AppVariables.matchesCollection,
    );
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

    if (widget.isLoading) {
      return Text(
        l10n.updatingMatches,
        style: const TextStyle(
          height: 0.8,
          fontSize: 10,
        ),
      );
    }

    return StreamBuilder<Config>(
      stream: _configStream,
      builder: (context, snapshot) {
        final config = snapshot.data ??
            Config(
              id: AppVariables.matchesCollection,
              lastUpdate: DateTime.now(),
            );

        final delta = DateTime.now().difference(config.lastUpdate);

        return Text(
          l10n.updatedSecondsAgo(delta.inSeconds),
          style: const TextStyle(
            height: 0.8,
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
      content: Column(
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
      title: AppFunctions.getMatchState(match.status, match.utcDate!, l10n),
      content: Column(
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
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  getIt<AnalyticsService>().logEvent(
                    name: 'team_clicked',
                    parameters: {'team_id': match.homeTeam.id.toString()},
                  );
                  unawaited(
                    Navigator.of(context).pushNamed(
                      TeamPage.routeName,
                      arguments: match.homeTeam.id,
                    ),
                  );
                },
                child: CrestImage(
                  crest: match.homeTeam.crest,
                  fit: BoxFit.cover,
                  margin: 2.5,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: ScrollText(
                  text: match.homeTeam.name,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
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
          const SizedBox(height: 5),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  getIt<AnalyticsService>().logEvent(
                    name: 'team_clicked',
                    parameters: {'team_id': match.awayTeam.id.toString()},
                  );
                  unawaited(
                    Navigator.of(context).pushNamed(
                      TeamPage.routeName,
                      arguments: match.awayTeam.id,
                    ),
                  );
                },
                child: CrestImage(
                  crest: match.awayTeam.crest,
                  fit: BoxFit.cover,
                  margin: 2.5,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: ScrollText(
                  text: match.awayTeam.name,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
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
      title: l10n.refereeMatch.toUpperCase(),
      content: Column(
        children: [
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
      title: l10n.refereeMatch.toUpperCase(),
      content: Column(
        children: [
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
                        style: const TextStyle(fontSize: 10),
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
      title: l10n.competitionMatch.toUpperCase(),
      content: const Column(
        children: [
          Row(
            children: [
              AppSchimmer(height: 30, width: 30),
              SizedBox(width: 10),
              Expanded(child: AppSchimmer()),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              AppSchimmer(height: 30, width: 30),
              SizedBox(width: 10),
              Expanded(child: AppSchimmer()),
            ],
          ),
          SizedBox(height: 10),
          AppSchimmer(width: 100),
          SizedBox(height: 5),
          AppSchimmer(width: 50),
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
      title: l10n.competitionMatch.toUpperCase(),
      content: Column(
        children: [
          Row(
            children: [
              CrestImage(
                crest: match.area.flag,
                fit: BoxFit.cover,
                dimension: 30,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ScrollText(
                  text: match.area.name,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
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
              Expanded(
                child: ScrollText(
                  text: match.competition.name,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
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
          Text(
            '${l10n.matchdayMatch} ${match.matchday}',
            style: const TextStyle(fontSize: 11),
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
      title: l10n.standingsMatch.toUpperCase(),
      content: Column(
        children: [
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

class StandingsMatch extends StatefulWidget {
  const StandingsMatch({
    required this.match,
    super.key,
  });

  final Match match;

  @override
  State<StandingsMatch> createState() => _StandingsMatchState();
}

class _StandingsMatchState extends State<StandingsMatch> {
  late final Stream<LeagueStandings> _standingsStream;

  @override
  void initState() {
    super.initState();
    _standingsStream = getIt<DatabaseService>().getStandingsStream(
      leagueId: widget.match.competition.id.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StreamBuilder<LeagueStandings>(
      stream: _standingsStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const SizedBox.shrink();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ShimmerStandingsMatch();
        }

        if (snapshot.data == null) {
          return const SizedBox.shrink();
        }

        final leagueStandings = snapshot.data!;
        if (leagueStandings.standings.isEmpty) {
          return const SizedBox.shrink();
        }

        if (leagueStandings.standings.length == 1) {
          return AppCardData(
            title: l10n.standingsMatch.toUpperCase(),
            content: Column(
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
                ...leagueStandings.standings.first.table.map(
                  (row) => Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 2.5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: getRowStandingColor(row, widget.match),
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
                        GestureDetector(
                          onTap: () {
                            getIt<AnalyticsService>().logEvent(
                              name: 'team_clicked',
                              parameters: {'team_id': row.team.id.toString()},
                            );
                            unawaited(
                              Navigator.of(context).pushNamed(
                                TeamPage.routeName,
                                arguments: row.team.id,
                              ),
                            );
                          },
                          child: CrestImage(
                            crest: row.team.crest,
                            dimension: 25,
                            borderRadius: 7.5,
                          ),
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
          );
        } else {
          return Column(
            spacing: AppVariables.scaffoldSpacing,
            children: leagueStandings.standings
                .map(
                  (standing) => AppCardData(
                    title: standing.group?.toUpperCase() ?? '',
                    content: Column(
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
                              color: getRowStandingColor(row, widget.match),
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
                                GestureDetector(
                                  onTap: () {
                                    getIt<AnalyticsService>().logEvent(
                                      name: 'team_clicked',
                                      parameters: {
                                        'team_id': row.team.id.toString(),
                                      },
                                    );
                                    unawaited(
                                      Navigator.of(context).pushNamed(
                                        TeamPage.routeName,
                                        arguments: row.team.id,
                                      ),
                                    );
                                  },
                                  child: CrestImage(
                                    crest: row.team.crest,
                                    dimension: 25,
                                    borderRadius: 7.5,
                                  ),
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

    return Padding(
      padding: const EdgeInsets.only(
        top: AppVariables.bottomScaffoldSpacingButton,
      ),
      child: Row(
        children: [
          Expanded(
            child: AppFilledButton(
              onPressed: () => Navigator.of(context).pop(),
              label: l10n.backText,
            ),
          ),
        ],
      ),
    );
  }
}
