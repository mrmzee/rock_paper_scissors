import 'package:flutter/widgets.dart';
import 'package:rock_paper_scissors/core/l10n/l10n.dart';
import 'package:rock_paper_scissors/core/theme/game_colors.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/move.dart';

/// Presentation details for a domain hand: artwork, color and name.
extension MovePresentation on Move {
  String get assetPath => 'assets/images/hands/$name.svg';

  Color color(BuildContext context) {
    final colors = GameColors.of(context);
    return switch (this) {
      Move.rock => colors.rock,
      Move.paper => colors.paper,
      Move.scissors => colors.scissors,
    };
  }

  String label(BuildContext context) {
    final l10n = context.l10n;
    return switch (this) {
      Move.rock => l10n.rock,
      Move.paper => l10n.paper,
      Move.scissors => l10n.scissors,
    };
  }
}
