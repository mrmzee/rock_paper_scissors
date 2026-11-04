import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/core/l10n/l10n.dart';
import 'package:rock_paper_scissors/core/theme/app_spacing.dart';
import 'package:rock_paper_scissors/core/theme/game_colors.dart';
import 'package:rock_paper_scissors/core/widgets/toy_surface.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/move.dart';
import 'package:rock_paper_scissors/features/game/presentation/mappers/move_asset.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/hand_art.dart';

/// The hand the player throws most, in that hand's color.
class FavoriteMoveCard extends StatelessWidget {
  const FavoriteMoveCard({super.key, required this.move, required this.count});

  final Move move;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ink = GameColors.of(context).handInk;
    final l10n = context.l10n;

    return Semantics(
      container: true,
      label: '${l10n.favoriteMove}: ${move.label(context)}, '
          '${l10n.timesPlayed(count)}',
      excludeSemantics: true,
      child: ToySurface(
        color: move.color(context),
        padding: const EdgeInsets.all(AppSpacing.md),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        depth: 5,
        child: Row(
          children: [
            HandArt(move: move, size: 56),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.favoriteMove,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: ink.withValues(alpha: 0.88),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    move.label(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: ink,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    l10n.timesPlayed(count),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: ink.withValues(alpha: 0.88),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
