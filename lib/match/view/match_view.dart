import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rotary_scrollbar/rotary_scrollbar.dart';
import 'package:tiki_taka/app/app.dart';
import 'package:tiki_taka/l10n/l10n.dart';
import 'package:tiki_taka/match/match.dart';
import 'package:user_api/user_api.dart';
import 'package:wearable_rotary/wearable_rotary.dart' as wearable_rotary
    show rotaryEvents;
import 'package:wearable_rotary/wearable_rotary.dart' hide rotaryEvents;

class MatchView extends StatefulWidget {
  MatchView({
    super.key,
    @visibleForTesting Stream<RotaryEvent>? rotaryEvents,
  }) : rotaryEvents = rotaryEvents ?? wearable_rotary.rotaryEvents;

  final Stream<RotaryEvent> rotaryEvents;

  @override
  State<MatchView> createState() => _MatchViewState();
}

class _MatchViewState extends State<MatchView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<MatchCubit, MatchState>(
      builder: (context, state) => Scaffold(
        body: SizedBox.expand(
          child: RotaryScrollbar(
            controller: _scrollController,
            scrollAnimationCurve: Curves.easeInOut,
            scrollAnimationDuration: scrollDuration,
            scrollMagnitude: scrollMagnitude,
            width: scrollWidth,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      l10n.titleMatch.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '${l10n.updatedAtMatch} '
                      '${DateFormat('HH:mm:ss').format(
                        state.match.lastUpdated!,
                      )}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TeamsCardMatch(match: state.match),
                    CompetitionCardMatch(match: state.match),
                    const StandingsMatch(),
                    const BackButtonMatch(),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ),
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
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
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
                  const SizedBox(width: 10),
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
              Row(
                children: [
                  const SizedBox(width: 10),
                  CrestImage(crest: match.homeTeam.crest),
                  const SizedBox(width: 10),
                  Expanded(child: ScrollText(text: match.homeTeam.name)),
                  const SizedBox(width: 10),
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
                  const SizedBox(width: 10),
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
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const SizedBox(width: 10),
                  CrestImage(crest: match.awayTeam.crest),
                  const SizedBox(width: 10),
                  Expanded(child: ScrollText(text: match.awayTeam.name)),
                  const SizedBox(width: 10),
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
                  const SizedBox(width: 10),
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
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                getMatchState(match.status, match.utcDate!, l10n),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
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
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                  CrestImage(crest: match.area.flag, fit: BoxFit.cover),
                  const SizedBox(width: 10),
                  Expanded(child: ScrollText(text: match.area.name)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  CrestImage(crest: match.competition.emblem),
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
        ),
      ),
    );
  }
}

class StandingsMatch extends StatelessWidget {
  const StandingsMatch({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<MatchCubit, MatchState>(
      builder: (context, state) {
        switch (state.status) {
          case StandingsStatus.initial:
            return const SizedBox.shrink();
          case StandingsStatus.loading:
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Center(
                    child: SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
            );
          case StandingsStatus.success:
            if (state.standings.isEmpty) {
              return const SizedBox.shrink();
            }
            if (state.standings[0].table.isEmpty) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Column(
                    children: [
                      Text(
                        l10n.standingsMatch.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        spacing: 5,
                        children: [
                          Row(
                            children: [
                              const Expanded(child: SizedBox.shrink()),
                              SizedBox(
                                width: 20,
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
                                width: 20,
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
                                width: 20,
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
                          ...state.standings[0].table.map(
                            (standing) => Row(
                              spacing: 5,
                              children: [
                                SizedBox(
                                  width: 20,
                                  child: Center(
                                    child: Text(
                                      standing.position.toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                CrestImage(
                                  crest: standing.team.crest,
                                  dimension: 25,
                                ),
                                Expanded(
                                  child: ScrollText(
                                    text: standing.team.shortName,
                                  ),
                                ),
                                PointTextMatch(
                                  value: standing.playedGames,
                                ),
                                PointTextMatch(
                                  value: standing.goalDifference,
                                ),
                                PointTextMatch(
                                  value: standing.points,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          case StandingsStatus.failure:
            return const SizedBox.shrink();
        }
      },
    );
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
      width: 20,
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
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                l10n.backText.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
