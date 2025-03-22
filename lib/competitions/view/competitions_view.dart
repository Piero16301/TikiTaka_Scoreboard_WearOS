import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rotary_scrollbar/rotary_scrollbar.dart';
import 'package:tiki_taka/app/app.dart';
import 'package:tiki_taka/competitions/competitions.dart';
import 'package:tiki_taka/l10n/l10n.dart';
import 'package:user_api/user_api.dart';
import 'package:wearable_rotary/wearable_rotary.dart' as wearable_rotary
    show rotaryEvents;
import 'package:wearable_rotary/wearable_rotary.dart' hide rotaryEvents;

class CompetitionsView extends StatefulWidget {
  CompetitionsView({
    super.key,
    @visibleForTesting Stream<RotaryEvent>? rotaryEvents,
  }) : rotaryEvents = rotaryEvents ?? wearable_rotary.rotaryEvents;

  final Stream<RotaryEvent> rotaryEvents;

  @override
  State<CompetitionsView> createState() => _CompetitionsViewState();
}

class _CompetitionsViewState extends State<CompetitionsView> {
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

    return BlocBuilder<CompetitionsCubit, CompetitionsState>(
      builder: (context, state) {
        switch (state.status) {
          case CompetitionsStatus.initial:
            return const SizedBox.shrink();
          case CompetitionsStatus.loading:
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
          case CompetitionsStatus.success:
            if (state.leagues.isEmpty) {
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
                          const SizedBox(height: 10),
                          Text(
                            l10n.titleLeagues.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...state.leagues.map(
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
          case CompetitionsStatus.failure:
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
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<CompetitionsCubit>().loadLeagues(),
                          child: Text(
                            l10n.retryLeagues,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
        }
      },
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              const SizedBox(width: 10),
              BlocBuilder<CompetitionsCubit, CompetitionsState>(
                builder: (context, state) {
                  final enabled = state.enabled[league.code] ?? false;
                  return SizedBox(
                    width: 40,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Switch(
                        padding: EdgeInsets.zero,
                        value: enabled,
                        onChanged: (value) {
                          context.read<CompetitionsCubit>().toggleLeague(
                                league: league.code,
                                enabled: value,
                              );
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              CrestImage(crest: league.emblem),
              const SizedBox(width: 10),
              Expanded(child: ScrollText(text: league.name)),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class BackButtonCompetitions extends StatelessWidget {
  const BackButtonCompetitions({super.key});

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
