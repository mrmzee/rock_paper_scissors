import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/core/l10n/l10n.dart';
import 'package:rock_paper_scissors/core/theme/app_motion.dart';
import 'package:rock_paper_scissors/core/theme/app_spacing.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/move.dart';
import 'package:rock_paper_scissors/features/game/presentation/mappers/robot_look.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/hand_art.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/player_badge.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/robot_avatar.dart';

/// Selected robot (or two players) with floating hands, the title and the
/// greeting.
class HomeHero extends StatefulWidget {
  const HomeHero({super.key, required this.difficulty, this.friend = false});

  final Difficulty difficulty;
  final bool friend;

  @override
  State<HomeHero> createState() => _HomeHeroState();
}

class _HomeHeroState extends State<HomeHero>
    with SingleTickerProviderStateMixin {
  late final AnimationController _float = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotion.reduced(context)) {
      _float.stop();
    } else if (!_float.isAnimating) {
      _float.repeat();
    }
  }

  @override
  void dispose() {
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = context.l10n;

    Widget floatingHand(Move move, double phase, double angle) {
      return AnimatedBuilder(
        animation: _float,
        builder: (context, child) {
          final t = _float.value * math.pi * 2 + phase;
          return Transform.translate(
            offset: Offset(0, math.sin(t) * 6),
            child: Transform.rotate(angle: angle, child: child),
          );
        },
        child: HandArt(move: move, size: 52),
      );
    }

    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            height: 124,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                floatingHand(Move.rock, 0, -0.25),
                const SizedBox(width: AppSpacing.sm),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    floatingHand(Move.paper, 2, 0),
                    const Spacer(),
                  ],
                ),
                const SizedBox(width: AppSpacing.sm),
                if (widget.friend) ...[
                  const PlayerBadge(size: 84),
                  const SizedBox(width: AppSpacing.xs),
                  const PlayerBadge(size: 84, second: true),
                ] else
                  RobotAvatar(
                    difficulty: widget.difficulty,
                    size: 108,
                    semanticLabel: widget.difficulty.robotName(context),
                  ),
                const SizedBox(width: AppSpacing.sm),
                floatingHand(Move.scissors, 4, 0.25),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.appTitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: scheme.onSurface,
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
        ),
        Text(
          l10n.homeGreeting,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium?.copyWith(
            color: scheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
