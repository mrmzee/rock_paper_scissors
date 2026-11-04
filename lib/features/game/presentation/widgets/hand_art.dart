import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/move.dart';
import 'package:rock_paper_scissors/features/game/presentation/mappers/move_asset.dart';

/// Vector hand artwork. [flipped] points the hand down, toward the player.
class HandArt extends StatelessWidget {
  const HandArt({
    super.key,
    required this.move,
    this.size = 96,
    this.flipped = false,
  });

  final Move move;
  final double size;
  final bool flipped;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: RotatedBox(
        quarterTurns: flipped ? 2 : 0,
        child: SvgPicture.asset(
          move.assetPath,
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
