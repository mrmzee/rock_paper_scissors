import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/core/l10n/l10n.dart';
import 'package:rock_paper_scissors/core/theme/app_spacing.dart';
import 'package:rock_paper_scissors/core/widgets/chunky_button.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/score_strip.dart';

/// Back button, live score and pause button above the stage.
class GameTopBar extends StatelessWidget {
  const GameTopBar({
    super.key,
    required this.match,
    required this.onBack,
    required this.onPause,
  });

  final Match match;
  final VoidCallback onBack;
  final VoidCallback onPause;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      children: [
        ChunkyIconButton(
          icon: Icons.arrow_back_rounded,
          tooltip: l10n.back,
          onPressed: onBack,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Center(
            child: ScoreStrip(match: match),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        ChunkyIconButton(
          icon: Icons.pause_rounded,
          tooltip: l10n.pause,
          onPressed: onPause,
        ),
      ],
    );
  }
}
