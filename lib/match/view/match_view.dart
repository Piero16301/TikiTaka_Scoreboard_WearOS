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
    _matchStream = getIt<DatabaseService>().getMatchStream(matchId: matchId);
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
            child: AppError(text: l10n.errorMatch),
          );
        }

        if (!snapshot.hasData) {
          return const AppScaffold.basic(
            child: AppLoader(),
          );
        }

        if (snapshot.data == null) {
          return AppScaffold.basic(
            child: AppEmpty(text: l10n.notFoundMatch),
          );
        }

        final match = snapshot.data!;

        return AppScaffold.scrollable(
          controller: _scrollController,
          child: Column(
            children: [
              const SizedBox(height: AppVariables.topScaffoldSpacing),
              AppTitleText(title: l10n.titleMatch),
              TeamsCardMatch(match: match),
              if (match.referees.isNotEmpty) ...[
                const SizedBox(height: AppVariables.listSpacing),
                RefereeCardMatch(referees: match.referees),
              ],
              const SizedBox(height: AppVariables.listSpacing),
              CompetitionCardMatch(match: match),
              const SizedBox(height: AppVariables.listSpacing),
              StandingsMatch(match: match),
              const SizedBox(height: AppVariables.bottomScaffoldSpacing),
            ],
          ),
        );
      },
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

    return AppCardAction(
      title: AppFunctions.getMatchState(match.status, match.utcDate!, l10n),
      content: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            spacing: 8,
            children: [
              InkWell(
                onTap: () => _onTeamPressed(context, match.homeTeam.id),
                borderRadius: BorderRadius.circular(8),
                child: CrestImage(
                  crest: match.homeTeam.crest,
                  height: 56,
                  width: 56,
                ),
              ),
              InkWell(
                onTap: () => _onTeamPressed(context, match.awayTeam.id),
                borderRadius: BorderRadius.circular(8),
                child: CrestImage(
                  crest: match.awayTeam.crest,
                  height: 56,
                  width: 56,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: Text(
                  match.homeTeam.name,
                  style: Theme.of(context).textTheme.labelMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  match.awayTeam.name,
                  style: Theme.of(context).textTheme.labelMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const Divider(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  match.score.halfTime.home.toString(),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        height: 1,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: 30,
                child: Text(
                  l10n.halfTimeAbbr,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        height: 1,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  match.score.halfTime.away.toString(),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        height: 1,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  match.score.fullTime.home.toString(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: 30,
                child: Text(
                  l10n.fullTimeAbbr,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        height: 1,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  match.score.fullTime.away.toString(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onTeamPressed(BuildContext context, int teamId) {
    getIt<AnalyticsService>().logEvent(
      name: 'team_clicked',
      parameters: {'team_id': teamId.toString()},
    );
    unawaited(
      Navigator.of(context).pushNamed(
        TeamPage.routeName,
        arguments: teamId,
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

    return AppCardAction(
      title: l10n.refereeMatch,
      content: Column(
        children: [
          ...referees.map((referee) {
            return Row(
              spacing: 8,
              children: [
                HugeIcon(
                  icon: HugeIcons.strokeRoundedWhistle,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        referee.name,
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      Text(
                        referee.nationality,
                        style: Theme.of(context).textTheme.labelSmall,
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

class CompetitionCardMatch extends StatelessWidget {
  const CompetitionCardMatch({
    required this.match,
    super.key,
  });

  final Match match;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCardAction(
      title: l10n.competitionMatch,
      content: Column(
        children: [
          Row(
            spacing: 8,
            children: [
              CrestImage(
                crest: match.area.flag,
                height: 30,
                width: 30,
                borderRadius: BorderRadius.circular(4),
              ),
              Expanded(
                child: Text(
                  match.area.name,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            spacing: 8,
            children: [
              CrestImage(
                crest: match.competition.emblem,
                height: 30,
                width: 30,
                borderRadius: BorderRadius.circular(4),
              ),
              Expanded(
                child: Text(
                  match.competition.name,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${l10n.seasonMatch} ${match.season.startDate!.year}'
            '-${match.season.endDate!.year}',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            '${l10n.matchdayMatch} ${match.matchday}',
            style: Theme.of(context).textTheme.labelSmall,
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
          return const SizedBox.shrink();
        }

        if (snapshot.data == null) {
          return const SizedBox.shrink();
        }

        final leagueStandings = snapshot.data!;
        if (leagueStandings.standings.isEmpty) {
          return const SizedBox.shrink();
        }

        if (leagueStandings.standings.length == 1) {
          return AppCardAction(
            title: l10n.standingsMatch,
            content: Column(
              spacing: 5,
              children: [
                Row(
                  children: [
                    const Expanded(child: SizedBox.shrink()),
                    SizedBox(
                      width: 25,
                      child: Text(
                        l10n.playedGamesAbbr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    SizedBox(
                      width: 25,
                      child: Text(
                        l10n.goalDifferenceAbbr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    SizedBox(
                      width: 25,
                      child: Text(
                        l10n.pointsAbbr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
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
                      borderRadius: BorderRadius.circular(8),
                      color: getRowStandingColor(row, widget.match),
                    ),
                    child: Row(
                      spacing: 5,
                      children: [
                        SizedBox(
                          width: 20,
                          child: Text(
                            row.position.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        InkWell(
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
                          borderRadius: BorderRadius.circular(4),
                          child: CrestImage(
                            crest: row.team.crest,
                            height: 25,
                            width: 25,
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            row.team.tla,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
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
                  (standing) => AppCardAction(
                    title: standing.group ?? '',
                    content: Column(
                      spacing: 5,
                      children: [
                        Row(
                          children: [
                            const Expanded(child: SizedBox.shrink()),
                            SizedBox(
                              width: 25,
                              child: Text(
                                l10n.playedGamesAbbr,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            SizedBox(
                              width: 25,
                              child: Text(
                                l10n.goalDifferenceAbbr,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            SizedBox(
                              width: 25,
                              child: Text(
                                l10n.pointsAbbr,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
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
                              borderRadius: BorderRadius.circular(8),
                              color: getRowStandingColor(row, widget.match),
                            ),
                            child: Row(
                              spacing: 5,
                              children: [
                                SizedBox(
                                  width: 20,
                                  child: Text(
                                    row.position.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                InkWell(
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
                                  borderRadius: BorderRadius.circular(4),
                                  child: CrestImage(
                                    crest: row.team.crest,
                                    height: 25,
                                    width: 25,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    row.team.tla,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
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
      child: Text(
        value.toString(),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
