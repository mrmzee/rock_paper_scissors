import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/core/l10n/l10n.dart';
import 'package:rock_paper_scissors/core/theme/app_spacing.dart';
import 'package:rock_paper_scissors/features/achievements/domain/entities/achievement.dart';
import 'package:rock_paper_scissors/features/achievements/presentation/mappers/achievement_look.dart';
import 'package:rock_paper_scissors/features/achievements/presentation/widgets/achievement_badge.dart';

/// "New badge!" heading with the badges just earned.
class NewAchievements extends StatelessWidget {
  const NewAchievements({super.key, required this.achievements});

  final List<Achievement> achievements;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      children: [
        Text(
          context.l10n.newBadge,
          style: theme.textTheme.titleMedium?.copyWith(
            color: scheme.onSurface,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.sm,
          children: [
            for (final achievement in achievements)
              SizedBox(
                width: 96,
                child: Column(
                  children: [
                    AchievementBadge(achievement: achievement),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      achievement.title(context),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
