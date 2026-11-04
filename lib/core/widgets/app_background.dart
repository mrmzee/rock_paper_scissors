import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/core/theme/game_colors.dart';

/// Quiet paper backdrop with a few oversized, low contrast arcade marks.
class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = GameColors.of(context);
    final scheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [colors.gradientTop, colors.gradientBottom],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
              top: -170,
              right: -120,
              child: _ArcadeMark(color: scheme.primary)),
          Positioned(
              bottom: -200,
              left: -140,
              child: _ArcadeMark(color: scheme.secondary, reverse: true)),
          const Positioned(
            top: 88,
            left: 18,
            child: _PlaygroundStar(size: 36, opacity: 0.2),
          ),
          const Positioned(
            right: 24,
            bottom: 106,
            child: _PlaygroundStar(size: 24, opacity: 0.14),
          ),
          child,
        ],
      ),
    );
  }
}

class _PlaygroundStar extends StatelessWidget {
  const _PlaygroundStar({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return IgnorePointer(
      child: Icon(
        Icons.star_rounded,
        size: size,
        color: scheme.tertiary.withValues(alpha: opacity),
      ),
    );
  }
}

class _ArcadeMark extends StatelessWidget {
  const _ArcadeMark({required this.color, this.reverse = false});

  final Color color;
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox.square(
        dimension: 360,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    Border.all(color: color.withValues(alpha: 0.10), width: 2),
              ),
            ),
            Container(
              width: 210,
              height: 210,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.025),
                border:
                    Border.all(color: color.withValues(alpha: 0.06), width: 1),
              ),
            ),
            Transform.rotate(
              angle: reverse ? -0.78 : 0.78,
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
