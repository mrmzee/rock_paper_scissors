import 'package:flutter/widgets.dart';
import 'package:rock_paper_scissors/core/l10n/l10n.dart';
import 'package:rock_paper_scissors/core/theme/app_colors.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';

/// Each difficulty is a different robot character.
extension RobotLook on Difficulty {
  Color get robotColor => switch (this) {
        Difficulty.easy => AppColors.robotEasy,
        Difficulty.normal => AppColors.robotNormal,
        Difficulty.hard => AppColors.robotHard,
      };

  String robotName(BuildContext context) {
    final l10n = context.l10n;
    return switch (this) {
      Difficulty.easy => l10n.robotEasy,
      Difficulty.normal => l10n.robotNormal,
      Difficulty.hard => l10n.robotHard,
    };
  }

  String robotHint(BuildContext context) {
    final l10n = context.l10n;
    return switch (this) {
      Difficulty.easy => l10n.robotEasyHint,
      Difficulty.normal => l10n.robotNormalHint,
      Difficulty.hard => l10n.robotHardHint,
    };
  }
}
