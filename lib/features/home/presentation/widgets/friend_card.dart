import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/core/l10n/l10n.dart';
import 'package:rock_paper_scissors/core/theme/app_spacing.dart';
import 'package:rock_paper_scissors/core/widgets/chunky_button.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/player_badge.dart';

/// Pass-and-play option next to the robots.
class FriendCard extends StatelessWidget {
  const FriendCard({
    super.key,
    required this.selected,
    required this.onPressed,
  });

  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = context.l10n;
    final name = l10n.opponentFriend;
    final hint = l10n.opponentFriendHint;

    return ChunkyButton(
      key: const Key('opponent_friend'),
      color: selected
          ? Color.lerp(scheme.tertiary, Colors.white, 0.45)!
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
          const SizedBox(
            width: 52,
            height: 52,
            child: Stack(
              children: [
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: PlayerBadge(size: 34),
                ),
                Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: PlayerBadge(size: 34, second: true),
                ),
              ],
            ),
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
