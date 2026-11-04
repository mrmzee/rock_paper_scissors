import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/core/theme/app_colors.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/move.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/hand_art.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/robot_avatar.dart';

/// Brand background behind the launcher icon.
const brandBlue = AppColors.blue;
const brandBlueLight = AppColors.paperHand;

/// The app icon artwork: the robot with the three hands arched above it.
///
/// [contentScale] shrinks the artwork inside the square so it survives
/// adaptive-icon and splash-screen masks.
class AppIconArt extends StatelessWidget {
  const AppIconArt({
    super.key,
    this.size = 1024,
    this.withBackground = true,
    this.contentScale = 1,
  });

  final double size;
  final bool withBackground;
  final double contentScale;

  @override
  Widget build(BuildContext context) {
    final s = size * contentScale;

    Widget hand(Move move, double angle) {
      return Transform.rotate(
        angle: angle,
        child: HandArt(move: move, size: s * 0.27),
      );
    }

    final art = SizedBox.square(
      dimension: s,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: s * 0.06,
            child: RobotAvatar(
              difficulty: Difficulty.normal,
              mood: RobotMood.happy,
              size: s * 0.58,
            ),
          ),
          Positioned(
            left: s * 0.06,
            top: s * 0.2,
            child: hand(Move.rock, -0.4),
          ),
          Positioned(top: s * 0.05, child: hand(Move.paper, 0)),
          Positioned(
            right: s * 0.06,
            top: s * 0.2,
            child: hand(Move.scissors, 0.4),
          ),
        ],
      ),
    );

    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: withBackground
              ? const RadialGradient(
                  center: Alignment(0, -0.3),
                  radius: 0.9,
                  colors: [brandBlueLight, brandBlue],
                )
              : null,
        ),
        child: Center(child: art),
      ),
    );
  }
}
