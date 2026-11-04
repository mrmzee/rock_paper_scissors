import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/core/theme/app_spacing.dart';
import 'package:rock_paper_scissors/core/widgets/chunky_button.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/presentation/mappers/robot_look.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/robot_avatar.dart';

class RobotCard extends StatelessWidget {
  const RobotCard({
    super.key,
    required this.difficulty,
    required this.selected,
    required this.onPressed,
  });

  final Difficulty difficulty;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final name = difficulty.robotName(context);
    final hint = difficulty.robotHint(context);

    return ChunkyButton(
      key: Key('robot_${difficulty.name}'),
      color: selected
          ? Color.lerp(difficulty.robotColor, Colors.white, 0.45)!
          : scheme.surface,
      selected: selected,
      onPressed: onPressed,
      semanticLabel: '$name. $hint',
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RobotAvatar(
            difficulty: difficulty,
            mood: selected ? RobotMood.happy : RobotMood.idle,
            size: 52,
          ),
          const SizedBox(height: AppSpacing.xxs),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              name,
              maxLines: 1,
              style: theme.textTheme.titleSmall?.copyWith(
                color: scheme.onSurface,
                fontWeight: FontWeight.w800,
                height: 1.1,
              ),
            ),
          ),
          Text(
            hint,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.8),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
