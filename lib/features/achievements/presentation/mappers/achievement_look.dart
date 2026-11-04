import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/core/l10n/l10n.dart';
import 'package:rock_paper_scissors/core/theme/app_colors.dart';
import 'package:rock_paper_scissors/features/achievements/domain/entities/achievement.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/presentation/mappers/robot_look.dart';

/// Icon, color and text for each badge.
extension AchievementLook on Achievement {
  IconData get icon => switch (this) {
        Achievement.firstWin => Icons.emoji_events_rounded,
        Achievement.streak3 => Icons.local_fire_department_rounded,
        Achievement.streak5 => Icons.bolt_rounded,
        Achievement.perfectMatch => Icons.auto_awesome_rounded,
        Achievement.beatGrumpy => Icons.sentiment_very_satisfied_rounded,
        Achievement.allMoves => Icons.back_hand_rounded,
        Achievement.matches10 => Icons.sports_esports_rounded,
        Achievement.matches50 => Icons.military_tech_rounded,
      };

  Color get color => switch (this) {
        Achievement.firstWin => AppColors.star,
        Achievement.streak3 => AppColors.orange,
        Achievement.streak5 => AppColors.coral,
        Achievement.perfectMatch => AppColors.purple,
        Achievement.beatGrumpy => AppColors.robotHard,
        Achievement.allMoves => AppColors.paperHand,
        Achievement.matches10 => AppColors.mint,
        Achievement.matches50 => AppColors.blue,
      };

  String title(BuildContext context) {
    final l10n = context.l10n;
    return switch (this) {
      Achievement.firstWin => l10n.badgeFirstWin,
      Achievement.streak3 => l10n.badgeStreak3,
      Achievement.streak5 => l10n.badgeStreak5,
      Achievement.perfectMatch => l10n.badgePerfect,
      Achievement.beatGrumpy => l10n.badgeBeatGrumpy,
      Achievement.allMoves => l10n.badgeAllMoves,
      Achievement.matches10 => l10n.badgeMatches10,
      Achievement.matches50 => l10n.badgeMatches50,
    };
  }

  String hint(BuildContext context) {
    final l10n = context.l10n;
    return switch (this) {
      Achievement.firstWin => l10n.badgeFirstWinHint,
      Achievement.streak3 => l10n.badgeStreak3Hint,
      Achievement.streak5 => l10n.badgeStreak5Hint,
      Achievement.perfectMatch => l10n.badgePerfectHint,
      Achievement.beatGrumpy =>
        l10n.badgeBeatGrumpyHint(Difficulty.hard.robotName(context)),
      Achievement.allMoves => l10n.badgeAllMovesHint,
      Achievement.matches10 => l10n.badgeMatches10Hint,
      Achievement.matches50 => l10n.badgeMatches50Hint,
    };
  }
}
