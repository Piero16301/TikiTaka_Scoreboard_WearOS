import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rotary_scrollbar/rotary_scrollbar.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_wearos/leagues/leagues.dart';
import 'package:user_api/user_api.dart';
import 'package:wearable_rotary/wearable_rotary.dart'
    as wearable_rotary
    show rotaryEvents;
import 'package:wearable_rotary/wearable_rotary.dart' hide rotaryEvents;

class LeaguesView extends StatefulWidget {
  LeaguesView({
    super.key,
    @visibleForTesting Stream<RotaryEvent>? rotaryEvents,
  }) : rotaryEvents = rotaryEvents ?? wearable_rotary.rotaryEvents;

  final Stream<RotaryEvent> rotaryEvents;

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

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: context.read<LeaguesCubit>().getLeagues(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            body: SizedBox.expand(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: ScrollText(
                          text: l10n.titleLeagues.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: titleSize,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...List.generate(
                        numberOfShimmers,
                        (index) => const ShimmerCardLeagues(),
                      ),
                      const BackButtonCompetitions(),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: SizedBox.expand(
              child: Padding(
                padding: const EdgeInsets.all(10),
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
                        l10n.emptyLeagues,
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

        final leagues = snapshot.data!.docs
            .map((doc) => League.fromJson(doc.data()))
            .toList();

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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: ScrollText(
                          text: l10n.titleLeagues.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: titleSize,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...leagues.map(
                        (league) => LeagueCardCompetitions(league: league),
                      ),
                      const BackButtonCompetitions(),
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
                    onChanged: (value) {
                      unawaited(
                        context.read<LeaguesCubit>().toggleLeague(
                          league: league.code,
                          enabled: value,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 5),
          CrestImage(crest: league.emblem),
          const SizedBox(width: 5),
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text(
                l10n.backText.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
