import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:rotary_scrollbar/rotary_scrollbar.dart';
import 'package:tiki_taka/app/app.dart';
import 'package:tiki_taka/l10n/l10n.dart';
import 'package:tiki_taka/team/team.dart';
import 'package:user_api/user_api.dart';
import 'package:wearable_rotary/wearable_rotary.dart' as wearable_rotary
    show rotaryEvents;
import 'package:wearable_rotary/wearable_rotary.dart' hide rotaryEvents;

class TeamView extends StatefulWidget {
  TeamView({
    super.key,
    @visibleForTesting Stream<RotaryEvent>? rotaryEvents,
  }) : rotaryEvents = rotaryEvents ?? wearable_rotary.rotaryEvents;

  final Stream<RotaryEvent> rotaryEvents;

  @override
  State<TeamView> createState() => _TeamViewState();
}

class _TeamViewState extends State<TeamView> {
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
      stream: context.read<TeamCubit>().getTeam(),
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
                          text: l10n.titleTeam.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: titleSize,
                          ),
                        ),
                      ),
                      const LastUpdateTeam(isLoading: true),
                      const SizedBox(height: 10),
                      // Add shimmers
                      const BackButtonTeam(),
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
            body: SizedBox.expand(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.errorTeam,
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
                        l10n.notFoundTeam,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const BackButtonTeam(),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        final team = snapshot.data!.docs
            .map((doc) => Team.fromJson(doc.data()))
            .toList()
            .first;

        return Scaffold(
          body: SizedBox.expand(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: getTeamColors(team.clubColors),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
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
                        MainInfoTeam(team: team),
                        CoachCardTeam(coach: team.coach),
                        const SizedBox(height: 10),
                      ],
                    ),
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

class MainInfoTeam extends StatelessWidget {
  const MainInfoTeam({
    required this.team,
    super.key,
  });

  final Team team;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.6),
                blurRadius: 12,
                spreadRadius: 3,
              ),
            ],
          ),
          child: CrestImage(
            crest: team.crest,
            fit: BoxFit.cover,
            dimension: 60,
          ),
        ),
        const SizedBox(height: 5),
        ScrollText(
          text: team.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        ScrollText(
          text: '${team.shortName} (${team.tla})',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class CoachCardTeam extends StatelessWidget {
  const CoachCardTeam({
    required this.coach,
    super.key,
  });

  final Staff coach;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCardData(
      child: Column(
        children: [
          Text(
            l10n.coachTeam.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedMentoring,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ScrollText(
                      text: coach.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      coach.nationality,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      l10n.coachAgeTeam(getAge(coach.dateOfBirth)),
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  Text(
                    l10n.untilTeam,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 9,
                    ),
                  ),
                  Text(
                    getUntilContract(coach.contract.until),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  int getAge(String dateOfBirth) {
    final birthDate = DateTime.parse(dateOfBirth);
    final today = DateTime.now();
    var age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  String getUntilContract(String until) {
    final dateParts = until.split('-');
    return dateParts.first;
  }
}

class LastUpdateTeam extends StatefulWidget {
  const LastUpdateTeam({
    this.isLoading = false,
    super.key,
  });

  final bool isLoading;

  @override
  State<LastUpdateTeam> createState() => _LastUpdateTeamState();
}

class _LastUpdateTeamState extends State<LastUpdateTeam>
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
    final l10n = AppLocalizations.of(context);

    if (widget.isLoading) {
      return Text(
        l10n.updatingMatches,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      );
    }

    return StreamBuilder(
      stream: context.read<TeamCubit>().getTeamConfigs(),
      builder: (context, snapshot) {
        final configs = snapshot.data?.docs
                .map((doc) => Config.fromJson(doc.data()))
                .toList() ??
            [Config(id: teamsCollection, lastUpdate: DateTime.now())];

        if (configs.isEmpty) {
          configs.add(
            Config(id: teamsCollection, lastUpdate: DateTime.now()),
          );
        }

        final delta = DateTime.now().difference(configs.first.lastUpdate);

        return Text(
          l10n.updatedDaysAgo(delta.inDays),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        );
      },
    );
  }
}

class BackButtonTeam extends StatelessWidget {
  const BackButtonTeam({super.key});

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
