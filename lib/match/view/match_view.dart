import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: context.read<MatchCubit>().getMatch(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: SizedBox.expand(
              child: Center(
                child: SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: SizedBox.expand(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.errorMatches,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return Scaffold(
            body: SizedBox.expand(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.emptyMatches,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const BackButtonMatch(),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        final match = snapshot.data!.docs
            .map((doc) => Match.fromJson(doc.data()))
            .toList()
            .first;

        return Scaffold(
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
                      const SizedBox(height: 20),
                      ScrollText(
                        text: l10n.titleMatch.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: titleSize,
                        ),
                      ),
                      const LastUpdateMatch(),
                      const SizedBox(height: 10),
                      TeamsCardMatch(match: match),
                      if (match.referees.isNotEmpty)
                        RefereeCardMatch(referees: match.referees),
                      CompetitionCardMatch(match: match),
                      StandingsMatch(match: match),
                      const BackButtonMatch(),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class LastUpdateMatch extends StatefulWidget {
  const LastUpdateMatch({super.key});

  @override
  State<LastUpdateMatch> createState() => _LastUpdateMatchState();
}

class _LastUpdateMatchState extends State<LastUpdateMatch>
    with WidgetsBindingObserver {
  late StreamSubscription<void> _nowSubscription;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _nowSubscription = Stream<void>.periodic(const Duration(seconds: 1))
        .listen((_) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _nowSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return StreamBuilder(
      stream: context.read<MatchCubit>().getMatchConfigs(),
      builder: (context, snapshot) {
        final configs = snapshot.data?.docs
                .map((doc) => Config.fromJson(doc.data()))
                .toList() ??
            [Config(id: matchesCollection, lastUpdate: DateTime.now())];

        if (configs.isEmpty) {
          configs.add(
            Config(id: matchesCollection, lastUpdate: DateTime.now()),
          );
        }

        final delta = DateTime.now().difference(configs.first.lastUpdate);

        return Text(
          l10n.updatedMatches(delta.inSeconds),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10,
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
              Row(
                children: [
                  const SizedBox(width: 5),
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
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const SizedBox(width: 5),
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

class RefereeCardMatch extends StatelessWidget {
  const RefereeCardMatch({
    required this.referees,
    super.key,
  });

  final List<Referee> referees;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Column(
            children: [
              Text(
                context.l10n.refereeMatch.toUpperCase(),
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
        ),
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
    final l10n = context.l10n;

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: context
          .read<MatchCubit>()
          .getStandings(leagueId: match.competition.id.toString()),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
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
        }

        if (snapshot.hasError) {
          return const SizedBox.shrink();
        }

        if (snapshot.data!.docs.isEmpty) {
          return const SizedBox.shrink();
        }

        final result = snapshot.data!.docs.map((doc) => doc.data()).toList();
        if (result.isEmpty || result.length > 1) {
          return const SizedBox.shrink();
        }

        final standingsList =
            result.first[standingsCollection] as List<dynamic>? ?? [];
        if (standingsList.isEmpty) {
          return const SizedBox.shrink();
        }

        final standings = standingsList
            .map(
              (standing) =>
                  Standing.fromJson(standing as Map<String, dynamic>? ?? {}),
            )
            .toList();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
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
                      ...standings[0].table.map(
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
                                  child: Text(
                                    standing.team.tla,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
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
      width: 21,
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
