import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/core/theme/app_motion.dart';
import 'package:rock_paper_scissors/core/theme/app_spacing.dart';
import 'package:rock_paper_scissors/core/theme/game_colors.dart';
import 'package:rock_paper_scissors/core/widgets/chunky_button.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/move.dart';
import 'package:rock_paper_scissors/features/game/presentation/mappers/move_asset.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/hand_art.dart';

/// Three big hand buttons in the thumb zone.
class MovePad extends StatelessWidget {
  const MovePad({
    super.key,
    required this.enabled,
    required this.selected,
    required this.onSelected,
    this.compact = false,
  });

  final bool enabled;
  final Move? selected;
  final ValueChanged<Move> onSelected;

  /// Places the hand beside its label for short landscape screens.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final move in Move.values)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: AnimatedOpacity(
                duration: AppMotion.of(context),
                opacity: enabled || selected == move ? 1 : 0.55,
                child: _MoveButton(
                  key: Key('pick_${move.name}'),
                  move: move,
                  selected: selected == move,
                  compact: compact,
                  onPressed: enabled ? () => onSelected(move) : null,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _MoveButton extends StatelessWidget {
  const _MoveButton({
    super.key,
    required this.move,
    required this.selected,
    required this.compact,
    required this.onPressed,
  });

  final Move move;
  final bool selected;
  final bool compact;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = move.label(context);
    final labelText = FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        label,
        maxLines: 1,
        style: theme.textTheme.titleMedium?.copyWith(
          color: GameColors.of(context).handInk,
          fontWeight: FontWeight.w800,
          height: 1.1,
        ),
      ),
    );

    return ChunkyButton(
      color: move.color(context),
      selected: selected,
      onPressed: onPressed,
      semanticLabel: label,
      depth: compact ? 5 : 7,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: compact ? AppSpacing.xs : AppSpacing.sm,
      ),
      child: compact
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HandArt(move: move, size: 34),
                const SizedBox(width: AppSpacing.xs),
                Flexible(child: labelText),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HandArt(move: move, size: 48),
                const SizedBox(height: AppSpacing.xxs),
                labelText,
              ],
            ),
    );
  }
}
