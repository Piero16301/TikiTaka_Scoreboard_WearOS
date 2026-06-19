import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';

class ThemesView extends StatefulWidget {
  const ThemesView({super.key});

  @override
  State<ThemesView> createState() => _ThemesViewState();
}

class _ThemesViewState extends State<ThemesView> {
  final ScrollController _scrollController = ScrollController(
    keepScrollOffset: false,
  );

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = ColorHelper.colorMap.entries;

    return AppScaffold.scrollable(
      controller: _scrollController,
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) => RadioGroup<Color>(
          groupValue: state.baseColor,
          onChanged: (v) {},
          child: Column(
            children: [
              const SizedBox(height: AppVariables.topScaffoldSpacing),
              AppTitleText(title: l10n.titleTheme),
              for (final (index, color) in colors.indexed) ...[
                CardThemes(
                  value: color.value,
                  label: color.key,
                ),
                if (index < colors.length - 1)
                  const SizedBox(height: AppVariables.listSpacing),
              ],
              const SizedBox(height: AppVariables.bottomScaffoldSpacing),
            ],
          ),
        ),
      ),
    );
  }
}

class CardThemes extends StatelessWidget {
  const CardThemes({
    required this.value,
    required this.label,
    super.key,
  });

  final Color value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorName = AppFunctions.getColorName(label, l10n);

    return AppCardAction(
      onPressed: () =>
          context.read<AppCubit>().changeBaseColor(baseColor: value),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
        child: Row(
          spacing: 5,
          children: [
            SizedBox.square(
              dimension: 20,
              child: IgnorePointer(
                child: Radio<Color>(value: value),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: value,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Expanded(child: Text(colorName)),
          ],
        ),
      ),
    );
  }
}
