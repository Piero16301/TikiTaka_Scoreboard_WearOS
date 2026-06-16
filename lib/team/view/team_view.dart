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
            child: AppError(text: l10n.errorTeam),
          );
        }

        if (!snapshot.hasData) {
          return const AppScaffold.basic(
            child: AppLoader(),
          );
        }

        if (snapshot.data == null) {
          return AppScaffold.basic(
            child: AppEmpty(text: l10n.notFoundTeam),
          );
        }

        final team = snapshot.data!;

        return AppScaffold.scrollable(
          controller: _scrollController,
          background: WavingFlagBackground(
            colors: AppFunctions.getTeamColors(team.clubColors ?? ''),
          ),
          child: Column(
            children: [
              const SizedBox(height: AppVariables.topScaffoldSpacing),
              MainInfoTeam(team: team),
              if (team.coach != null && team.coach?.id != 0) ...[
                const SizedBox(height: AppVariables.listSpacing),
                CoachCardTeam(coach: team.coach!),
              ],
              if (team.runningCompetitions != null &&
                  team.runningCompetitions!.isNotEmpty) ...[
                const SizedBox(height: AppVariables.listSpacing),
                CompetitionsCardTeam(
                  competitions: team.runningCompetitions!,
                ),
              ],
              if (team.squad?.isNotEmpty ?? false) ...[
                const SizedBox(height: AppVariables.listSpacing),
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
              ],
              const SizedBox(height: AppVariables.listSpacing),
              AdditionalInfoTeam(team: team),
              const SizedBox(height: AppVariables.bottomScaffoldSpacing),
            ],
          ),
        );
      },
    );
  }
}

class MainInfoTeam extends StatelessWidget {
  const MainInfoTeam({required this.team, super.key});

  final Team team;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.7),
                blurRadius: 16,
                spreadRadius: 2,
              ),
            ],
          ),
          child: CrestImage(
            crest: team.crest,
            height: 64,
            width: 64,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          AppFunctions.getTeamTranslatedName(team.name, l10n),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        Text(
          '${team.shortName} (${team.tla})',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class CoachCardTeam extends StatelessWidget {
  const CoachCardTeam({required this.coach, super.key});

  final Staff coach;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCardAction(
      title: l10n.coachTeam,
      content: Column(
        spacing: 5,
        children: [
          Row(
            spacing: 8,
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedMentoring,
                color: Theme.of(context).colorScheme.primary,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coach.name,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      coach.nationality,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      l10n.ageTeam(getAge(coach.dateOfBirth)),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    l10n.untilTeam,
                    style: const TextStyle(fontSize: 9),
                  ),
                  Text(
                    getUntilContract(coach.contract.until),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
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

class CompetitionsCardTeam extends StatelessWidget {
  const CompetitionsCardTeam({required this.competitions, super.key});

  final List<League> competitions;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCardAction(
      title: l10n.competitionsTeam,
      content: Column(
        spacing: 8,
        children: competitions
            .map(
              (competition) => Row(
                spacing: 8,
                children: [
                  CrestImage(
                    crest: competition.emblem,
                    height: 30,
                    width: 30,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          competition.name,
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        Text(
                          AppFunctions.getCompetitionType(
                            competition.type,
                            l10n,
                          ),
                          style: Theme.of(context).textTheme.labelSmall,
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

    return AppCardAction(
      title: l10n.squadTeam,
      content: Column(
        spacing: 8,
        children: squad
            .map(
              (player) => Row(
                spacing: 8,
                children: [
                  HugeIcon(
                    icon: AppFunctions.getStaffPositionIcon(player.position),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          player.name,
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        Text(
                          player.nationality,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        Text(
                          l10n.ageTeam(getAge(player.dateOfBirth)),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 36,
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
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onPrimaryFixed,
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

    return AppCardAction(
      title: l10n.infoTeam,
      content: Column(
        spacing: 8,
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
      spacing: 8,
      children: [
        HugeIcon(
          icon: icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
