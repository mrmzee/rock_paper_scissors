import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/core/l10n/l10n.dart';
import 'package:rock_paper_scissors/core/theme/app_spacing.dart';
import 'package:rock_paper_scissors/core/theme/game_colors.dart';
import 'package:rock_paper_scissors/core/widgets/chunky_button.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match_mode.dart';

class ModeCard extends StatelessWidget {
  const ModeCard({
    super.key,
    required this.mode,
    required this.selected,
    required this.onPressed,
  });

  final MatchMode mode;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = GameColors.of(context);
    final l10n = context.l10n;

    final (title, hint, accent) = switch (mode) {
      MatchMode.bestOf5 => (
          l10n.modeBestOf5,
          l10n.modeBestOf5Hint,
          colors.star
        ),
      MatchMode.endless => (
          l10n.modeEndless,
          l10n.modeEndlessHint,
          colors.paper
        ),
    };
    final Widget art = switch (mode) {
      MatchMode.bestOf5 => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < 3; i++)
              Icon(
                Icons.star_rounded,
                size: 26,
                color: selected ? Colors.white : colors.star,
              ),
          ],
        ),
      MatchMode.endless => Icon(
          Icons.all_inclusive_rounded,
          size: 30,
          color: selected ? Colors.white : colors.paper,
        ),
    };

    return ChunkyButton(
      key: Key('mode_${mode.name}'),
      color: selected ? accent : scheme.surface,
      selected: selected,
      onPressed: onPressed,
      semanticLabel: '$title. $hint',
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 30, child: Center(child: art)),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          Text(
            hint,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.8),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
