import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/core/l10n/l10n.dart';
import 'package:rock_paper_scissors/core/theme/app_spacing.dart';
import 'package:rock_paper_scissors/features/achievements/domain/entities/achievement.dart';
import 'package:rock_paper_scissors/features/achievements/presentation/mappers/achievement_look.dart';
import 'package:rock_paper_scissors/features/achievements/presentation/widgets/achievement_badge.dart';

/// Floating "New badge!" toast shown mid-match.
SnackBar achievementSnackBar(BuildContext context, Achievement achievement) {
  final theme = Theme.of(context);
  final scheme = theme.colorScheme;

  return SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: scheme.surface,
    duration: const Duration(seconds: 3),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
    ),
    content: Row(
      children: [
        AchievementBadge(achievement: achievement, size: 40),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.newBadge,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                achievement.title(context),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
