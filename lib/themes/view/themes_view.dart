import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rotary_scrollbar/rotary_scrollbar.dart';
import 'package:tiki_taka/app/app.dart';
import 'package:tiki_taka/l10n/l10n.dart';
import 'package:wearable_rotary/wearable_rotary.dart' as wearable_rotary
    show rotaryEvents;
import 'package:wearable_rotary/wearable_rotary.dart' hide rotaryEvents;

class ThemesView extends StatefulWidget {
  ThemesView({
    super.key,
    @visibleForTesting Stream<RotaryEvent>? rotaryEvents,
  }) : rotaryEvents = rotaryEvents ?? wearable_rotary.rotaryEvents;

  final Stream<RotaryEvent> rotaryEvents;

  @override
  State<ThemesView> createState() => _ThemesViewState();
}

class _ThemesViewState extends State<ThemesView> {
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
                    text: l10n.titleTheme.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: titleSize,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CardThemes(
                    isDark: false,
                    text: l10n.lightTheme,
                    icon: Icons.light_mode,
                  ),
                  CardThemes(
                    isDark: true,
                    text: l10n.darkTheme,
                    icon: Icons.dark_mode,
                  ),
                  const BackButtonLanguages(),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CardThemes extends StatelessWidget {
  const CardThemes({
    required this.isDark,
    required this.text,
    required this.icon,
    super.key,
  });

  final bool isDark;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        child: Row(
          children: [
            BlocBuilder<AppCubit, AppState>(
              builder: (context, state) => Radio<bool>(
                value: isDark,
                groupValue: state.darkMode,
                onChanged: (v) =>
                    context.read<AppCubit>().changeTheme(darkMode: v ?? true),
              ),
            ),
            Icon(icon),
            const SizedBox(width: 10),
            Expanded(child: ScrollText(text: text)),
          ],
        ),
      ),
    );
  }
}

class BackButtonLanguages extends StatelessWidget {
  const BackButtonLanguages({super.key});

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
