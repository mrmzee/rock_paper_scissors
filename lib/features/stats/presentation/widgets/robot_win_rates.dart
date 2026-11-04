import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rock_paper_scissors/core/l10n/l10n.dart';
import 'package:rock_paper_scissors/core/theme/app_spacing.dart';
import 'package:rock_paper_scissors/core/widgets/toy_surface.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/player_stats.dart';
import 'package:rock_paper_scissors/features/game/presentation/mappers/robot_look.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/robot_avatar.dart';

/// Round win rate against each robot, as one bar per robot.
class RobotWinRates extends StatelessWidget {
  const RobotWinRates({super.key, required this.stats});

  final PlayerStats stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return ToySurface(
      color: scheme.surface,
      padding: const EdgeInsets.all(AppSpacing.md),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      depth: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.vsRobots,
            style: theme.textTheme.titleMedium?.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w900,
            ),
          ),
          for (final difficulty in Difficulty.values) ...[
            const SizedBox(height: AppSpacing.sm),
            _RobotRow(
              difficulty: difficulty,
              rate: stats.winRateAgainst(difficulty),
            ),
          ],
        ],
      ),
    );
  }
}

class _RobotRow extends StatelessWidget {
  const _RobotRow({required this.difficulty, required this.rate});

  final Difficulty difficulty;
  final double? rate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final rate = this.rate;
    final name = difficulty.robotName(context);
    final value = rate == null
        ? context.l10n.notPlayedYet
        : NumberFormat.percentPattern(
            Localizations.localeOf(context).toLanguageTag(),
          ).format(rate);

    return Semantics(
      label: '$name: $value',
      excludeSemantics: true,
      child: Row(
        children: [
          RobotAvatar(difficulty: difficulty, size: 40),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: scheme.onSurface,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      value,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: rate == null
                            ? scheme.onSurfaceVariant
                            : scheme.onSurface,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                LinearProgressIndicator(
                  value: rate ?? 0,
                  minHeight: 10,
                  color: difficulty.robotColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
