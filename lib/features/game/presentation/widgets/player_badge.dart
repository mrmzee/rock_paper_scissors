import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/core/widgets/toy_surface.dart';

/// The child's avatar: a smiling face on the player color.
class PlayerBadge extends StatelessWidget {
  const PlayerBadge({super.key, this.size = 72});

  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ExcludeSemantics(
      child: ToyBadge(
        color: scheme.primary,
        size: size,
        child: Icon(
          Icons.sentiment_very_satisfied_rounded,
          color: Colors.white,
          size: size * 0.62,
        ),
      ),
    );
  }
}
