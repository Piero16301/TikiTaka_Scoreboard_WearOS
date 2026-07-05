import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:wear_os_scrollbar/wear_os_scrollbar.dart';

class TypographyView extends StatefulWidget {
  const TypographyView({super.key});

  @override
  State<TypographyView> createState() => _TypographyViewState();
}

class _TypographyViewState extends State<TypographyView> {
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
    final fonts = AppVariables.availableFonts.entries;

    return AppScaffold.scrollable(
      controller: _scrollController,
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) => RadioGroup<String>(
          groupValue: state.fontFamily,
          onChanged: (v) {},
          child: Column(
            children: [
              const SizedBox(height: AppVariables.topScaffoldSpacing),
              AppTitleText(title: l10n.titleFont),
              for (final (index, font) in fonts.indexed) ...[
                WearOsExpressiveItem(
                  scrollController: _scrollController,
                  child: CardFonts(
                    value: font.value,
                    label: font.key,
                  ),
                ),
                if (index < fonts.length - 1)
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

class CardFonts extends StatelessWidget {
  const CardFonts({
    required this.label,
    required this.value,
    super.key,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return AppCardAction(
      onPressed: () =>
          context.read<AppCubit>().changeFontFamily(fontFamily: value),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
        child: Row(
          spacing: 5,
          children: [
            SizedBox.square(
              dimension: 20,
              child: Radio<String>(value: value),
            ),
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontFamily: value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
