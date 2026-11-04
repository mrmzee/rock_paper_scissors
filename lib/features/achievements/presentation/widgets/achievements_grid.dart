import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/core/l10n/l10n.dart';
import 'package:rock_paper_scissors/core/theme/app_spacing.dart';
import 'package:rock_paper_scissors/core/widgets/toy_surface.dart';
import 'package:rock_paper_scissors/features/achievements/domain/entities/achievement.dart';
import 'package:rock_paper_scissors/features/achievements/presentation/mappers/achievement_look.dart';
import 'package:rock_paper_scissors/features/achievements/presentation/widgets/achievement_badge.dart';

/// Every badge with its goal, earned ones in color.
class AchievementsGrid extends StatelessWidget {
  const AchievementsGrid({super.key, required this.unlocked});

  final Set<Achievement> unlocked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = context.l10n;

    return ToySurface(
      color: scheme.surface,
      padding: const EdgeInsets.all(AppSpacing.md),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      depth: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.badges,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                l10n.badgesProgress(
                  unlocked.length,
                  Achievement.values.length,
                ),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 560 ? 4 : 2;
              final width =
                  (constraints.maxWidth - AppSpacing.sm * (columns - 1)) /
                      columns;
              return Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.md,
                children: [
                  for (final achievement in Achievement.values)
                    SizedBox(
                      width: width,
                      child: _AchievementTile(
                        achievement: achievement,
                        unlocked: unlocked.contains(achievement),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  const _AchievementTile({required this.achievement, required this.unlocked});

  final Achievement achievement;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final title = achievement.title(context);
    final hint = achievement.hint(context);

    return Semantics(
      label: unlocked
          ? '$title. $hint'
          : '$title, ${context.l10n.badgeLocked}. $hint',
      excludeSemantics: true,
      child: Row(
        children: [
          AchievementBadge(
            achievement: achievement,
            unlocked: unlocked,
            size: 44,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color:
                        unlocked ? scheme.onSurface : scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  hint,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
