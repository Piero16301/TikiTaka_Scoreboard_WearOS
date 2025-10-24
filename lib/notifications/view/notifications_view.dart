import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_wearos/notifications/notifications.dart';
import 'package:tiki_taka_scoreboard_wearos/teams/teams.dart';
import 'package:user_api/user_api.dart';
import 'package:wearable_rotary/wearable_rotary.dart'
    as wearable_rotary
    show rotaryEvents;
import 'package:wearable_rotary/wearable_rotary.dart' hide rotaryEvents;

class NotificationsView extends StatefulWidget {
  NotificationsView({
    super.key,
    @visibleForTesting Stream<RotaryEvent>? rotaryEvents,
  }) : rotaryEvents = rotaryEvents ?? wearable_rotary.rotaryEvents;

  final Stream<RotaryEvent> rotaryEvents;

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
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
      stream: context.read<NotificationsCubit>().getLeagues(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return AppScaffold(
            controller: _scrollController,
            child: SingleChildScrollView(
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
            ),
          );
        }

        if (snapshot.hasError) {
          return AppScaffold(
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

        if (snapshot.data!.docs.isEmpty) {
          return AppScaffold(
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

        final leagues = snapshot.data!.docs
            .map((doc) => League.fromJson(doc.data()))
            .toList();

        return AppScaffold(
          controller: _scrollController,
          child: SingleChildScrollView(
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

    return ElevatedButton(
      onPressed: () => Navigator.of(context).pop(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppVariables.verticalPaddingBackButton,
            ),
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
    );
  }
}
