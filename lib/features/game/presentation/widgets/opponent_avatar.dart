import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match.dart';
import 'package:rock_paper_scissors/features/game/presentation/mappers/match_sides.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/player_badge.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/robot_avatar.dart';

/// The robot for [match], or Player 2's badge in pass-and-play.
class OpponentAvatar extends StatelessWidget {
  const OpponentAvatar({
    super.key,
    required this.match,
    required this.size,
    this.mood = RobotMood.idle,
    this.semanticLabel,
  });

  final Match match;
  final double size;
  final RobotMood mood;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    if (match.isPassAndPlay) return PlayerBadge(size: size, second: true);
    return RobotAvatar(
      difficulty: match.difficulty,
      mood: mood,
      size: size,
      semanticLabel: semanticLabel,
    );
  }
}
