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
import 'package:wearable_rotary/wearable_rotary.dart'
    as wearable_rotary
    show rotaryEvents;
import 'package:wearable_rotary/wearable_rotary.dart' hide rotaryEvents;

class TeamView extends StatefulWidget {
  TeamView({super.key, @visibleForTesting Stream<RotaryEvent>? rotaryEvents})
    : rotaryEvents = rotaryEvents ?? wearable_rotary.rotaryEvents;

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
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const ShimmerMainInfoTeam(),
                      const SizedBox(height: 5),
                      const ShimmerCoachCardTeam(),
                      ShimmerExpandableCardTeam(title: l10n.competitionsTeam),
                      ShimmerExpandableCardTeam(title: l10n.squadTeam),
                      ShimmerExpandableCardTeam(title: l10n.staffTeam),
                      ShimmerExpandableCardTeam(title: l10n.infoTeam),
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
            child: RippleBackground(
              colors: getTeamColors(team.clubColors),
              child: RotaryScrollbar(
                controller: _scrollController,
                scrollAnimationCurve: Curves.easeInOut,
                scrollAnimationDuration: scrollDuration,
                scrollMagnitude: scrollMagnitude,
                width: scrollWidth,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        MainInfoTeam(team: team),
                        CoachCardTeam(coach: team.coach),
                        if (team.runningCompetitions.isNotEmpty)
                          CompetitionsCardTeam(
                            competitions: team.runningCompetitions,
                          ),
                        if (team.squad.isNotEmpty)
                          SquadCardTeam(
                            squad: team.squad
                              ..sort(
                                (a, b) => getStaffPositionOrder(
                                  a.position,
                                ).compareTo(getStaffPositionOrder(b.position)),
                              ),
                          ),
                        if (team.staff.isNotEmpty)
                          StaffCardTeam(
                            staff: team.staff
                              ..sort(
                                (a, b) => getStaffPositionOrder(
                                  a.position,
                                ).compareTo(getStaffPositionOrder(b.position)),
                              ),
                          ),
                        AdditionalInfoTeam(team: team),
                        const BackButtonTeam(),
                        const SizedBox(height: 50),
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

class ShimmerMainInfoTeam extends StatelessWidget {
  const ShimmerMainInfoTeam({super.key});

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
          child: const AppSchimmer(height: 60, width: 60),
        ),
        const SizedBox(height: 7.5),
        const AppSchimmer(height: 20, width: 100),
        const SizedBox(height: 7.5),
        const AppSchimmer(width: 50),
      ],
    );
  }
}

class MainInfoTeam extends StatelessWidget {
  const MainInfoTeam({required this.team, super.key});

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
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        ScrollText(
          text: '${team.shortName} (${team.tla})',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
        ),
      ],
    );
  }
}

class ShimmerCoachCardTeam extends StatelessWidget {
  const ShimmerCoachCardTeam({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCardData(
      child: Column(
        children: [
          const AppSchimmer(width: 100),
          const SizedBox(height: 5),
          Row(
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedMentoring,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5,
                  children: [
                    AppSchimmer(width: 80),
                    AppSchimmer(width: 70),
                    AppSchimmer(width: 60),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Column(
                spacing: 5,
                children: [AppSchimmer(width: 30), AppSchimmer(width: 30)],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CoachCardTeam extends StatelessWidget {
  const CoachCardTeam({required this.coach, super.key});

  final Staff coach;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCardData(
      child: Column(
        children: [
          Text(
            l10n.coachTeam.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
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
                      l10n.ageTeam(getAge(coach.dateOfBirth)),
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
    if (dateOfBirth.isEmpty) return 0;

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

class ShimmerExpandableCardTeam extends StatelessWidget {
  const ShimmerExpandableCardTeam({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppCardData(
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        minTileHeight: 20,
        title: Text(
          title.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        childrenPadding: const EdgeInsets.only(top: 5),
      ),
    );
  }
}

class CompetitionsCardTeam extends StatelessWidget {
  const CompetitionsCardTeam({required this.competitions, super.key});

  final List<Competition> competitions;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCardData(
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        minTileHeight: 20,
        title: Text(
          l10n.competitionsTeam.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        childrenPadding: const EdgeInsets.only(top: 5),
        children: competitions
            .map(
              (competition) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    CrestImage(
                      crest: competition.emblem,
                      fit: BoxFit.cover,
                      dimension: 30,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ScrollText(text: competition.name),
                          Text(
                            getCompetitionType(
                              competition.type,
                              l10n,
                            ).toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class SquadCardTeam extends StatelessWidget {
  const SquadCardTeam({required this.squad, super.key});

  final List<Staff> squad;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCardData(
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        minTileHeight: 20,
        title: Text(
          l10n.squadTeam.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        childrenPadding: const EdgeInsets.only(top: 5),
        children: squad
            .map(
              (player) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    HugeIcon(
                      icon: getStaffPositionIcon(player.position),
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ScrollText(
                            text: player.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            player.nationality,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            l10n.ageTeam(getAge(player.dateOfBirth)),
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 30,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: getStaffPositionColor(player.position),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        getStaffPosition(player.position, l10n),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  int getAge(String dateOfBirth) {
    if (dateOfBirth.isEmpty) return 0;

    final birthDate = DateTime.parse(dateOfBirth);
    final today = DateTime.now();
    var age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}

class StaffCardTeam extends StatelessWidget {
  const StaffCardTeam({required this.staff, super.key});

  final List<Staff> staff;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCardData(
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        minTileHeight: 20,
        title: Text(
          l10n.staffTeam.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        childrenPadding: const EdgeInsets.only(top: 5),
        children: staff
            .map(
              (personal) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    HugeIcon(
                      icon: getStaffPositionIcon(personal.position),
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ScrollText(
                            text: personal.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            personal.nationality,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            l10n.ageTeam(getAge(personal.dateOfBirth)),
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 30,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: getStaffPositionColor(personal.position),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        getStaffPosition(personal.position, l10n),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  int getAge(String dateOfBirth) {
    if (dateOfBirth.isEmpty) return 0;

    final birthDate = DateTime.parse(dateOfBirth);
    final today = DateTime.now();
    var age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}

class AdditionalInfoTeam extends StatelessWidget {
  const AdditionalInfoTeam({required this.team, super.key});

  final Team team;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCardData(
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        minTileHeight: 20,
        title: Text(
          l10n.infoTeam.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        childrenPadding: const EdgeInsets.only(top: 5),
        children: [
          buildInfoRow(
            icon: HugeIcons.strokeRoundedColosseum,
            title: l10n.stadiumTeam,
            value: team.venue,
            context: context,
          ),
          buildInfoRow(
            icon: HugeIcons.strokeRoundedClock02,
            title: l10n.foundedTeam,
            value: team.founded.toString(),
            context: context,
          ),
          buildInfoRow(
            icon: HugeIcons.strokeRoundedLocation01,
            title: l10n.addressTeam,
            value: team.address,
            context: context,
          ),
          buildInfoRow(
            icon: HugeIcons.strokeRoundedInternet,
            title: l10n.websiteTeam,
            value: team.website,
            context: context,
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow({
    required List<List<dynamic>> icon,
    required String title,
    required String value,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        spacing: 10,
        children: [
          HugeIcon(
            icon: icon,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScrollText(
                  text: title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
                ScrollText(
                  text: value,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LastUpdateTeam extends StatefulWidget {
  const LastUpdateTeam({this.isLoading = false, super.key});

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
    _nowSubscription = Stream<void>.periodic(
      const Duration(seconds: 1),
    ).listen((_) => setState(() {}));
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
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
      );
    }

    return StreamBuilder(
      stream: context.read<TeamCubit>().getTeamConfigs(),
      builder: (context, snapshot) {
        final configs =
            snapshot.data?.docs
                .map((doc) => Config.fromJson(doc.data()))
                .toList() ??
            [Config(id: teamsCollection, lastUpdate: DateTime.now())];

        if (configs.isEmpty) {
          configs.add(Config(id: teamsCollection, lastUpdate: DateTime.now()));
        }

        final delta = DateTime.now().difference(configs.first.lastUpdate);

        return Text(
          l10n.updatedDaysAgo(delta.inDays),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
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
