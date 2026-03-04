import 'package:flutter/material.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_wearos/teams/teams.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final database = getIt<DatabaseService>();

    return StreamBuilder<List<League>>(
      stream: database.getLeagues(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return AppScaffold.basic(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.errorNotifications,
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppVariables.horizontalPaddingTitle,
                  ),
                  child: ScrollText(
                    text: l10n.titleNotifications.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppVariables.titleSize,
                    ),
                  ),
                ),
                ...List.generate(
                  AppVariables.numberOfShimmers,
                  (index) => const ShimmerCardNotifications(),
                ),
                const BackButtonNotifications(),
                const SizedBox(height: AppVariables.bottomScaffoldSpacing),
              ],
            ),
          );
        }

        if (snapshot.data!.isEmpty) {
          return AppScaffold.basic(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.emptyNotifications,
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

        final leagues = snapshot.data!;

        return AppScaffold.scrollable(
          controller: _scrollController,
          child: Column(
            spacing: AppVariables.scaffoldSpacing,
            children: [
              const SizedBox(height: AppVariables.topScaffoldSpacing),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppVariables.horizontalPaddingTitle,
                ),
                child: ScrollText(
                  text: l10n.titleNotifications.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppVariables.titleSize,
                  ),
                ),
              ),
              ...leagues.map(
                (league) => LeagueCardNotifications(league: league),
              ),
              const BackButtonNotifications(),
              const SizedBox(height: AppVariables.bottomScaffoldSpacing),
            ],
          ),
        );
      },
    );
  }
}

class ShimmerCardNotifications extends StatelessWidget {
  const ShimmerCardNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppCardData(
      child: Row(
        children: [
          SizedBox(width: 10),
          AppSchimmer(height: 40, width: 40),
          SizedBox(width: 10),
          Expanded(child: AppSchimmer()),
          SizedBox(width: 10),
          SizedBox(
            width: 40,
            height: 40,
            child: IconButton(
              onPressed: null,
              icon: Icon(Icons.arrow_forward_ios),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}

class LeagueCardNotifications extends StatelessWidget {
  const LeagueCardNotifications({
    required this.league,
    super.key,
  });

  final League league;

  @override
  Widget build(BuildContext context) {
    return AppCardData(
      child: Row(
        children: [
          CrestImage(crest: league.emblem),
          const SizedBox(width: 5),
          Expanded(child: ScrollText(text: league.name)),
          const SizedBox(width: 5),
          SizedBox(
            width: 40,
            height: 40,
            child: IconButton(
              onPressed: () => Navigator.of(context).pushNamed(
                TeamsPage.routeName,
                arguments: league.id,
              ),
              icon: const Icon(Icons.arrow_forward_ios),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}

class BackButtonNotifications extends StatelessWidget {
  const BackButtonNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: AppFilledButton(
            onPressed: () => Navigator.of(context).pop(),
            label: l10n.backText.toUpperCase(),
          ),
        ),
      ],
    );
  }
}
