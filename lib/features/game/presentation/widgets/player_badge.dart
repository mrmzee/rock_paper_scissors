import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/core/widgets/toy_surface.dart';

/// The child's avatar: a smiling face on the player color. [second] is the
/// friend's look in pass-and-play.
class PlayerBadge extends StatelessWidget {
  const PlayerBadge({super.key, this.size = 72, this.second = false});

  final double size;
  final bool second;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ExcludeSemantics(
      child: ToyBadge(
        color: second ? scheme.tertiary : scheme.primary,
        size: size,
        child: Icon(
          second
              ? Icons.sentiment_satisfied_alt_rounded
              : Icons.sentiment_very_satisfied_rounded,
          color: Colors.white,
          size: size * 0.62,
        ),
      ),
    );
  }
}
