import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_wearos/team/team.dart';

class TeamView extends StatefulWidget {
  const TeamView({super.key});

  @override
  State<TeamView> createState() => _TeamViewState();
}

class _TeamViewState extends State<TeamView> {
  final _scrollController = ScrollController(keepScrollOffset: false);
  late final Stream<Team> _teamStream;

  @override
  void initState() {
    super.initState();
    final teamId = context.read<TeamCubit>().state.teamId;
    _teamStream = getIt<DatabaseService>().getTeamStream(teamId: teamId);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StreamBuilder<Team>(
      stream: _teamStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return AppScaffold.basic(
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
          );
        }

        if (!snapshot.hasData) {
          return AppScaffold.scrollable(
            controller: _scrollController,
            child: Column(
              spacing: AppVariables.scaffoldSpacing,
              children: [
                const SizedBox(height: AppVariables.topScaffoldSpacing),
                const ShimmerMainInfoTeam(),
                const ShimmerCoachCardTeam(),
                ShimmerCardTeam(title: l10n.competitionsTeam),
                ShimmerCardTeam(title: l10n.squadTeam),
                ShimmerCardTeam(title: l10n.staffTeam),
                ShimmerCardTeam(title: l10n.infoTeam),
                const BackButtonTeam(),
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
          );
        }

        final team = snapshot.data!;

        return AppScaffold.scrollable(
          controller: _scrollController,
          background: WavingFlagBackground(
            colors: AppFunctions.getTeamColors(team.clubColors ?? ''),
          ),
          child: Column(
            spacing: AppVariables.scaffoldSpacing,
            children: [
              const SizedBox(height: AppVariables.topScaffoldSpacing),
              MainInfoTeam(team: team),
              CoachCardTeam(coach: team.coach ?? Staff.empty),
              if (team.runningCompetitions?.isNotEmpty ?? false)
                CompetitionsCardTeam(
                  competitions: team.runningCompetitions ?? [],
                ),
              if (team.squad?.isNotEmpty ?? false)
                SquadCardTeam(
                  squad: team.squad!
                    ..sort(
                      (a, b) => AppFunctions.getStaffPositionOrder(
                        a.position,
                      ).compareTo(
                        AppFunctions.getStaffPositionOrder(
                          b.position,
                        ),
                      ),
                    ),
                ),
              if (team.staff?.isNotEmpty ?? false)
                StaffCardTeam(
                  staff: team.staff!
                    ..sort(
                      (a, b) => AppFunctions.getStaffPositionOrder(
                        a.position,
                      ).compareTo(
                        AppFunctions.getStaffPositionOrder(
                          b.position,
                        ),
                      ),
                    ),
                ),
              AdditionalInfoTeam(team: team),
              const BackButtonTeam(),
              const SizedBox(height: AppVariables.bottomScaffoldSpacing),
            ],
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
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        ScrollText(
          text: '${team.shortName} (${team.tla})',
          style: const TextStyle(fontSize: 11),
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
      content: Column(
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
      title: l10n.coachTeam.toUpperCase(),
      content: Column(
        spacing: 5,
        children: [
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
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      l10n.ageTeam(getAge(coach.dateOfBirth)),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  Text(
                    l10n.untilTeam,
                    style: const TextStyle(fontSize: 9),
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

class ShimmerCardTeam extends StatelessWidget {
  const ShimmerCardTeam({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppCardData(
      title: title.toUpperCase(),
      content: const Column(
        spacing: 5,
        children: [
          AppSchimmer(width: 100),
          AppSchimmer(width: 80),
          AppSchimmer(width: 60),
        ],
      ),
    );
  }
}

class CompetitionsCardTeam extends StatelessWidget {
  const CompetitionsCardTeam({required this.competitions, super.key});

  final List<League> competitions;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCardData(
      title: l10n.competitionsTeam.toUpperCase(),
      content: Column(
        spacing: 7.5,
        children: competitions
            .map(
              (competition) => Row(
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
                        ScrollText(
                          text: competition.name,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        Text(
                          AppFunctions.getCompetitionType(
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
      title: l10n.squadTeam.toUpperCase(),
      content: Column(
        spacing: 7.5,
        children: squad
            .map(
              (player) => Row(
                children: [
                  HugeIcon(
                    icon: AppFunctions.getStaffPositionIcon(player.position),
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
                      color: AppFunctions.getStaffPositionColor(
                        player.position,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      AppFunctions.getStaffPosition(player.position, l10n),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
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
      title: l10n.staffTeam.toUpperCase(),
      content: Column(
        spacing: 7.5,
        children: staff
            .map(
              (personal) => Row(
                children: [
                  HugeIcon(
                    icon: AppFunctions.getStaffPositionIcon(
                      personal.position,
                    ),
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
                      color: AppFunctions.getStaffPositionColor(
                        personal.position,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      AppFunctions.getStaffPosition(personal.position, l10n),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
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
      title: l10n.infoTeam.toUpperCase(),
      content: Column(
        spacing: 7.5,
        children: [
          buildInfoRow(
            icon: HugeIcons.strokeRoundedColosseum,
            title: l10n.stadiumTeam,
            value: team.venue ?? '-',
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
            value: team.address ?? '-',
            context: context,
          ),
          buildInfoRow(
            icon: HugeIcons.strokeRoundedInternet,
            title: l10n.websiteTeam,
            value: team.website ?? '-',
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
    return Row(
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
                text: value,
                style: const TextStyle(
                  fontSize: 11,
                ),
              ),
              ScrollText(
                text: title,
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
  }
}

class BackButtonTeam extends StatelessWidget {
  const BackButtonTeam({super.key});

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
