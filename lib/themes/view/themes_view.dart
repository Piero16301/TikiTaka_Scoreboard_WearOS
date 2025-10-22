import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:wearable_rotary/wearable_rotary.dart'
    as wearable_rotary
    show rotaryEvents;
import 'package:wearable_rotary/wearable_rotary.dart' hide rotaryEvents;

class ThemesView extends StatefulWidget {
  ThemesView({super.key, @visibleForTesting Stream<RotaryEvent>? rotaryEvents})
    : rotaryEvents = rotaryEvents ?? wearable_rotary.rotaryEvents;

  final Stream<RotaryEvent> rotaryEvents;

  @override
  State<ThemesView> createState() => _ThemesViewState();
}

class _ThemesViewState extends State<ThemesView> {
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _itemKeys = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  double _calculateScale(int index) {
    if (!_scrollController.hasClients) return 1;

    final key = _itemKeys[index];
    if (key?.currentContext == null) return 1;

    final renderBox = key!.currentContext!.findRenderObject() as RenderBox?;
    if (renderBox == null) return 1;

    final position = renderBox.localToGlobal(Offset.zero);
    final itemCenter = position.dy + (renderBox.size.height / 2);
    final screenCenter = MediaQuery.of(context).size.height / 2;

    final distance = (itemCenter - screenCenter).abs();
    final maxDistance = MediaQuery.of(context).size.height / 2;

    final scale = 1.15 - (distance / maxDistance) * 0.4;

    return scale.clamp(0.75, 1.15);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SizedBox.expand(
        child: AppRotaryScrollbar(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: BlocBuilder<AppCubit, AppState>(
                builder: (context, state) {
                  final colorEntries = AppHelpers.colorMap.entries.toList();
                  for (var i = 0; i < colorEntries.length; i++) {
                    _itemKeys.putIfAbsent(i, GlobalKey.new);
                  }

                  return RadioGroup<String>(
                    groupValue: state.baseColor,
                    onChanged: (value) =>
                        context.read<AppCubit>().changeBaseColor(
                          value ?? 'INDIGO',
                        ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: ScrollText(
                            text: l10n.titleTheme.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: titleSize,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...colorEntries.asMap().entries.map(
                          (entry) {
                            final index = entry.key;
                            final colorEntry = entry.value;
                            final scale = _calculateScale(index);
                            final verticalPadding = ((1.0 - scale) * 10).clamp(
                              0.0,
                              double.infinity,
                            );

                            return Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: verticalPadding,
                              ),
                              child: Transform.scale(
                                key: _itemKeys[index],
                                scale: scale,
                                child: CardColorThemes(
                                  text: colorEntry.key,
                                  color: colorEntry.value,
                                ),
                              ),
                            );
                          },
                        ),
                        const BackButtonLanguages(),
                        const SizedBox(height: 50),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CardColorThemes extends StatelessWidget {
  const CardColorThemes({
    required this.text,
    required this.color,
    super.key,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorName = getColorName(text, l10n);

    return AppCardData(
      child: Row(
        children: [
          Radio<String>(value: text),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: ScrollText(text: colorName)),
        ],
      ),
    );
  }
}

class BackButtonLanguages extends StatelessWidget {
  const BackButtonLanguages({super.key});

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
