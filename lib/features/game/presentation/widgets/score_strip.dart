import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/core/l10n/l10n.dart';
import 'package:rock_paper_scissors/core/theme/app_motion.dart';
import 'package:rock_paper_scissors/core/theme/app_spacing.dart';
import 'package:rock_paper_scissors/core/theme/game_colors.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/presentation/mappers/robot_look.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/player_badge.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/robot_avatar.dart';

/// Match score as stars to collect (3-star mode) or plain counters (endless).
class ScoreStrip extends StatelessWidget {
  const ScoreStrip({
    super.key,
    required this.wins,
    required this.losses,
    required this.winsNeeded,
    required this.difficulty,
  });

  final int wins;
  final int losses;
  final int? winsNeeded;
  final Difficulty difficulty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final robotName = difficulty.robotName(context);

    return Semantics(
      container: true,
      liveRegion: true,
      label: context.l10n.scoreSemantics(wins, robotName, losses),
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surface.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: Colors.white, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: scheme.primary.withValues(alpha: 0.18),
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const PlayerBadge(size: 32),
                const SizedBox(width: AppSpacing.xs),
                _SideScore(
                  key: const Key('player_score'),
                  value: wins,
                  goal: winsNeeded,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                  ),
                  child: Text(
                    'VS',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                _SideScore(
                  key: const Key('robot_score'),
                  value: losses,
                  goal: winsNeeded,
                ),
                const SizedBox(width: AppSpacing.xs),
                RobotAvatar(difficulty: difficulty, size: 34),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SideScore extends StatelessWidget {
  const _SideScore({super.key, required this.value, required this.goal});

  final int value;
  final int? goal;

  @override
  Widget build(BuildContext context) {
    final goal = this.goal;
    if (goal == null) {
      final theme = Theme.of(context);
      return SizedBox(
        width: 44,
        child: AnimatedSwitcher(
          duration: AppMotion.of(context, AppMotion.celebrate),
          switchInCurve: AppMotion.pop,
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: Text(
            context.number(value),
            key: ValueKey(value),
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < goal; i++) _ScoreStar(filled: i < value),
      ],
    );
  }
}

class _ScoreStar extends StatelessWidget {
  const _ScoreStar({required this.filled});

  final bool filled;

  @override
  Widget build(BuildContext context) {
    final colors = GameColors.of(context);
    final scheme = Theme.of(context).colorScheme;

    return AnimatedSwitcher(
      duration: AppMotion.of(context, AppMotion.celebrate),
      switchInCurve: AppMotion.pop,
      transitionBuilder: (child, animation) =>
          ScaleTransition(scale: animation, child: child),
      child: Icon(
        filled ? Icons.star_rounded : Icons.star_outline_rounded,
        key: ValueKey(filled),
        size: 24,
        color: filled ? colors.star : scheme.outlineVariant,
        shadows: filled
            ? [
                Shadow(
                  color: Color.lerp(colors.star, Colors.black, 0.3)!,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
    );
  }
}
