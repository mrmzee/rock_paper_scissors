import 'package:flutter/material.dart';

/// Raised, glossy surface used for the game's kid-friendly controls.
class ToySurface extends StatelessWidget {
  const ToySurface({
    super.key,
    required this.color,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.borderRadius = const BorderRadius.all(Radius.circular(22)),
    this.depth = 6,
  });

  final Color color;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final double depth;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color.lerp(color, Colors.white, 0.42)!, color],
        ),
        borderRadius: borderRadius,
        border:
            Border.all(color: Colors.white.withValues(alpha: 0.82), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.72),
            offset: Offset(0, depth),
            blurRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            offset: Offset(0, depth + 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: child,
    );
  }
}

/// A glossy 3D-style icon button or hand-art badge.
class ToyBadge extends StatelessWidget {
  const ToyBadge({
    super.key,
    required this.color,
    required this.child,
    this.size = 72,
    this.circle = true,
  });

  final Color color;
  final Widget child;
  final double size;
  final bool circle;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(size * 0.32);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color.lerp(color, Colors.white, 0.56)!, color],
        ),
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circle ? null : radius,
        border:
            Border.all(color: Colors.white.withValues(alpha: 0.9), width: 3),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.74),
            offset: const Offset(0, 6),
            blurRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            offset: const Offset(0, 9),
            blurRadius: 12,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: size * 0.16,
            left: size * 0.22,
            child: Container(
              width: size * 0.22,
              height: size * 0.09,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.68),
                borderRadius: BorderRadius.circular(size),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
