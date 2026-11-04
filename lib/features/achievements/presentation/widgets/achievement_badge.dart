import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/core/widgets/toy_surface.dart';
import 'package:rock_paper_scissors/features/achievements/domain/entities/achievement.dart';
import 'package:rock_paper_scissors/features/achievements/presentation/mappers/achievement_look.dart';

/// Round glossy badge; locked badges are greyed out with a padlock.
class AchievementBadge extends StatelessWidget {
  const AchievementBadge({
    super.key,
    required this.achievement,
    this.unlocked = true,
    this.size = 56,
  });

  final Achievement achievement;
  final bool unlocked;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ToyBadge(
      color: unlocked ? achievement.color : scheme.surfaceContainerHighest,
      size: size,
      child: Icon(
        unlocked ? achievement.icon : Icons.lock_rounded,
        color: unlocked ? Colors.white : scheme.outline,
        size: size * 0.52,
      ),
    );
  }
}
