import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/core/theme/app_colors.dart';
import 'package:rock_paper_scissors/core/theme/app_motion.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/presentation/mappers/robot_look.dart';

enum RobotMood { idle, thinking, happy, sad, surprised }

/// The opponent character. Its look depends on [difficulty] and its face
/// reacts to the round through [mood].
class RobotAvatar extends StatefulWidget {
  const RobotAvatar({
    super.key,
    required this.difficulty,
    this.mood = RobotMood.idle,
    this.size = 96,
    this.semanticLabel,
  });

  final Difficulty difficulty;
  final RobotMood mood;
  final double size;
  final String? semanticLabel;

  @override
  State<RobotAvatar> createState() => _RobotAvatarState();
}

class _RobotAvatarState extends State<RobotAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _life = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3600),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotion.reduced(context)) {
      _life
        ..stop()
        ..value = 0.5;
    } else if (!_life.isAnimating) {
      _life.repeat();
    }
  }

  @override
  void dispose() {
    _life.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    final mood = widget.mood;

    return Semantics(
      image: true,
      label: widget.semanticLabel,
      child: SizedBox.square(
        dimension: size,
        child: AnimatedBuilder(
          animation: _life,
          builder: (context, _) {
            final t = _life.value;
            final blinkPhase = ((t - 0.92) / 0.06).clamp(0.0, 1.0);
            final eyeOpen = 1 - math.sin(blinkPhase * math.pi);
            final bounce = math.sin(t * math.pi * 2 * 3).abs();
            final sway = math.sin(t * math.pi * 2 * 2);

            final dy = switch (mood) {
              RobotMood.happy => -bounce * size * 0.06,
              RobotMood.sad => size * 0.02,
              _ => 0.0,
            };
            final angle = switch (mood) {
              RobotMood.thinking => sway * 0.06,
              RobotMood.sad => -0.05,
              _ => 0.0,
            };

            return Transform.translate(
              offset: Offset(0, dy),
              child: Transform.rotate(
                angle: angle,
                child: CustomPaint(
                  size: Size.square(size),
                  painter: _RobotPainter(
                    color: widget.difficulty.robotColor,
                    mood: mood,
                    eyeOpen: eyeOpen,
                    look: mood == RobotMood.thinking ? sway : 0,
                    glow: 0.5 + 0.5 * math.sin(t * math.pi * 2 * 4),
                    angryBrows: widget.difficulty == Difficulty.hard,
                    round: widget.difficulty == Difficulty.easy,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RobotPainter extends CustomPainter {
  const _RobotPainter({
    required this.color,
    required this.mood,
    required this.eyeOpen,
    required this.look,
    required this.glow,
    required this.angryBrows,
    required this.round,
  });

  final Color color;
  final RobotMood mood;
  final double eyeOpen;
  final double look;
  final double glow;
  final bool angryBrows;
  final bool round;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final edge = Color.lerp(color, Colors.black, 0.28)!;

    _paintAntenna(canvas, s, edge);
    _paintHead(canvas, s, edge);
    _paintEyes(canvas, s);
    _paintBrows(canvas, s);
    _paintMouth(canvas, s);
    _paintCheeks(canvas, s);
  }

  void _paintAntenna(Canvas canvas, double s, Color edge) {
    canvas.drawLine(
      Offset(s * 0.5, s * 0.2),
      Offset(s * 0.5, s * 0.09),
      Paint()
        ..color = edge
        ..strokeWidth = s * 0.035
        ..strokeCap = StrokeCap.round,
    );
    final tip = Offset(s * 0.5, s * 0.075);
    if (mood == RobotMood.thinking) {
      canvas.drawCircle(
        tip,
        s * (0.07 + 0.03 * glow),
        Paint()..color = AppColors.star.withValues(alpha: 0.35),
      );
    }
    canvas.drawCircle(tip, s * 0.055, Paint()..color = AppColors.star);
    canvas.drawCircle(
      tip.translate(-s * 0.015, -s * 0.015),
      s * 0.015,
      Paint()..color = Colors.white.withValues(alpha: 0.8),
    );
  }

  void _paintHead(Canvas canvas, double s, Color edge) {
    final earPaint = Paint()..color = edge;
    final earRadius = Radius.circular(s * 0.04);
    canvas
      ..drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(s * 0.03, s * 0.42, s * 0.1, s * 0.2),
          earRadius,
        ),
        earPaint,
      )
      ..drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(s * 0.87, s * 0.42, s * 0.1, s * 0.2),
          earRadius,
        ),
        earPaint,
      );

    final headRect = Rect.fromLTRB(s * 0.1, s * 0.17, s * 0.9, s * 0.85);
    final radius = Radius.circular(s * (round ? 0.3 : 0.2));
    final head = RRect.fromRectAndRadius(headRect, radius);

    canvas
      ..drawRRect(head.shift(Offset(0, s * 0.045)), Paint()..color = edge)
      ..drawRRect(
        head,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.lerp(color, Colors.white, 0.45)!, color],
          ).createShader(headRect),
      )
      ..drawRRect(
        head,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = s * 0.025
          ..color = Colors.white.withValues(alpha: 0.9),
      )
      ..drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(s * 0.22, s * 0.215, s * 0.2, s * 0.045),
          Radius.circular(s),
        ),
        Paint()..color = Colors.white.withValues(alpha: 0.6),
      )
      ..drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(s * 0.2, s * 0.3, s * 0.8, s * 0.77),
          Radius.circular(s * 0.13),
        ),
        Paint()..color = AppColors.robotScreen,
      );
  }

  double get _eyeRadius => round ? 0.085 : 0.072;

  (Offset, Offset) _eyeCenters(double s) {
    final y = s * (mood == RobotMood.sad ? 0.5 : 0.48);
    final dx = look * s * 0.035;
    return (Offset(s * 0.37 + dx, y), Offset(s * 0.63 + dx, y));
  }

  void _paintEyes(Canvas canvas, double s) {
    final r = s * _eyeRadius;
    final glowPaint = Paint()..color = AppColors.robotGlow;
    final (left, right) = _eyeCenters(s);

    for (final c in [left, right]) {
      switch (mood) {
        case RobotMood.happy:
          final path = Path()
            ..moveTo(c.dx - r, c.dy + r * 0.35)
            ..quadraticBezierTo(
                c.dx, c.dy - r * 1.2, c.dx + r, c.dy + r * 0.35);
          canvas.drawPath(
            path,
            Paint()
              ..color = AppColors.robotGlow
              ..style = PaintingStyle.stroke
              ..strokeWidth = s * 0.038
              ..strokeCap = StrokeCap.round,
          );
        case RobotMood.surprised:
          canvas
            ..drawCircle(c, r * 1.2, glowPaint)
            ..drawCircle(c, r * 0.45, Paint()..color = AppColors.robotScreen);
        case RobotMood.idle || RobotMood.thinking || RobotMood.sad:
          final open = eyeOpen.clamp(0.12, 1.0);
          canvas.drawOval(
            Rect.fromCenter(center: c, width: r * 2, height: r * 2 * open),
            glowPaint,
          );
          if (open > 0.5) {
            canvas
              ..drawCircle(
                c.translate(look * r * 0.35, r * 0.1),
                r * 0.42,
                Paint()..color = AppColors.robotScreen,
              )
              ..drawCircle(
                c.translate(look * r * 0.35 - r * 0.15, -r * 0.1),
                r * 0.14,
                glowPaint,
              );
          }
      }
    }
  }

  void _paintBrows(Canvas canvas, double s) {
    final sad = mood == RobotMood.sad;
    final angry = angryBrows && !sad && mood != RobotMood.happy;
    if (!sad && !angry) return;

    final r = s * _eyeRadius;
    final (left, right) = _eyeCenters(s);
    final paint = Paint()
      ..color = AppColors.robotGlow
      ..strokeWidth = s * 0.03
      ..strokeCap = StrokeCap.round;
    final outer = sad ? 1.35 : 2.0;
    final inner = sad ? 2.0 : 1.3;

    canvas
      ..drawLine(
        Offset(left.dx - r, left.dy - r * outer),
        Offset(left.dx + r * 0.9, left.dy - r * inner),
        paint,
      )
      ..drawLine(
        Offset(right.dx + r, right.dy - r * outer),
        Offset(right.dx - r * 0.9, right.dy - r * inner),
        paint,
      );
  }

  void _paintMouth(Canvas canvas, double s) {
    final m = Offset(s * 0.5, s * 0.665);
    final w = s * 0.09;
    final stroke = Paint()
      ..color = AppColors.robotGlow
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.03
      ..strokeCap = StrokeCap.round;

    switch (mood) {
      case RobotMood.idle:
        canvas.drawPath(
          Path()
            ..moveTo(m.dx - w, m.dy - s * 0.01)
            ..quadraticBezierTo(
                m.dx, m.dy + s * 0.045, m.dx + w, m.dy - s * 0.01),
          stroke,
        );
      case RobotMood.thinking:
        canvas.drawPath(
          Path()
            ..moveTo(m.dx - w * 0.8, m.dy)
            ..cubicTo(
              m.dx - w * 0.3,
              m.dy - s * 0.03,
              m.dx + w * 0.3,
              m.dy + s * 0.03,
              m.dx + w * 0.8,
              m.dy,
            ),
          stroke,
        );
      case RobotMood.happy:
        canvas.drawPath(
          Path()
            ..moveTo(m.dx - w * 1.2, m.dy - s * 0.025)
            ..lineTo(m.dx + w * 1.2, m.dy - s * 0.025)
            ..quadraticBezierTo(
              m.dx,
              m.dy + s * 0.1,
              m.dx - w * 1.2,
              m.dy - s * 0.025,
            )
            ..close(),
          Paint()..color = const Color(0xFFFF8FB1),
        );
      case RobotMood.sad:
        canvas.drawPath(
          Path()
            ..moveTo(m.dx - w, m.dy + s * 0.03)
            ..quadraticBezierTo(
                m.dx, m.dy - s * 0.025, m.dx + w, m.dy + s * 0.03),
          stroke,
        );
      case RobotMood.surprised:
        canvas.drawCircle(m.translate(0, s * 0.01), s * 0.035, stroke);
    }
  }

  void _paintCheeks(Canvas canvas, double s) {
    if (mood != RobotMood.happy && !round) return;
    final paint = Paint()
      ..color = const Color(0xFFFF8FB1).withValues(alpha: 0.5);
    canvas
      ..drawCircle(Offset(s * 0.27, s * 0.65), s * 0.035, paint)
      ..drawCircle(Offset(s * 0.73, s * 0.65), s * 0.035, paint);
  }

  @override
  bool shouldRepaint(_RobotPainter old) {
    return old.color != color ||
        old.mood != mood ||
        old.eyeOpen != eyeOpen ||
        old.look != look ||
        old.glow != glow ||
        old.angryBrows != angryBrows ||
        old.round != round;
  }
}
