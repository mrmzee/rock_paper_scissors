import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/core/theme/app_motion.dart';
import 'package:rock_paper_scissors/core/theme/game_colors.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/move.dart';
import 'package:rock_paper_scissors/features/game/presentation/mappers/move_asset.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/hand_art.dart';

enum HandCardState { hidden, shaking, revealed, winner, loser }

/// One player's hand on the stage. While [HandCardState.shaking] it bounces
/// three times over [shakeDuration], showing rock, paper and then scissors in
/// time with the chant.
class HandCard extends StatefulWidget {
  const HandCard({
    super.key,
    required this.state,
    required this.move,
    required this.shakeDuration,
    this.size = 140,
    this.flipped = false,
    this.semanticLabel,
  });

  final HandCardState state;
  final Move? move;
  final Duration shakeDuration;
  final double size;
  final bool flipped;
  final String? semanticLabel;

  @override
  State<HandCard> createState() => _HandCardState();
}

class _HandCardState extends State<HandCard>
    with SingleTickerProviderStateMixin {
  static final _beats = Move.values.length;

  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: widget.shakeDuration,
    animationBehavior: AnimationBehavior.preserve,
  )..addListener(_onShakeTick);

  int _beat = 0;

  @override
  void initState() {
    super.initState();
    if (widget.state == HandCardState.shaking) _shake.forward();
  }

  @override
  void didUpdateWidget(covariant HandCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _shake.duration = widget.shakeDuration;
    if (widget.state == HandCardState.shaking &&
        oldWidget.state != HandCardState.shaking) {
      _beat = 0;
      _shake.forward(from: 0);
    }
  }

  void _onShakeTick() {
    final beat = (_shake.value * _beats).floor().clamp(0, _beats - 1);
    if (beat != _beat) setState(() => _beat = beat);
  }

  @override
  void dispose() {
    _shake.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    final state = widget.state;
    final scheme = Theme.of(context).colorScheme;
    final colors = GameColors.of(context);
    final move = widget.move;
    final shaking = state == HandCardState.shaking;
    final chantMove = Move.values[_beat];
    final showsMove = move != null && state != HandCardState.hidden && !shaking;
    final base = shaking
        ? Color.lerp(chantMove.color(context), Colors.white, 0.35)!
        : showsMove
            ? move.color(context)
            : scheme.surface;
    final reduced = AppMotion.reduced(context);

    final scale = switch (state) {
      HandCardState.winner => 1.08,
      HandCardState.loser => 0.9,
      _ => 1.0,
    };

    final Widget art = switch (state) {
      HandCardState.hidden => Icon(
          Icons.question_mark_rounded,
          key: const ValueKey('hidden'),
          size: size * 0.45,
          color: scheme.outline,
        ),
      HandCardState.shaking => HandArt(
          key: ValueKey('shaking$_beat'),
          move: chantMove,
          size: size * 0.66,
          flipped: widget.flipped,
        ),
      _ => HandArt(
          key: ValueKey(move),
          move: move ?? Move.rock,
          size: size * 0.7,
          flipped: widget.flipped,
        ),
    };

    Widget card = AnimatedContainer(
      duration: AppMotion.of(context),
      curve: AppMotion.standardCurve,
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color.lerp(base, Colors.white, 0.5)!, base],
        ),
        borderRadius: BorderRadius.circular(size * 0.26),
        border: Border.all(
          color: state == HandCardState.winner ? colors.star : Colors.white,
          width: state == HandCardState.winner ? 6 : 4,
        ),
        boxShadow: [
          BoxShadow(
            color: Color.lerp(base, Colors.black, 0.2)!,
            offset: const Offset(0, 7),
          ),
          if (state == HandCardState.winner)
            BoxShadow(
              color: colors.star.withValues(alpha: 0.7),
              blurRadius: 28,
              spreadRadius: 4,
            ),
        ],
      ),
      child: Center(
        child: AnimatedSwitcher(
          duration: AppMotion.of(
            context,
            shaking ? AppMotion.quick : AppMotion.celebrate,
          ),
          switchInCurve: AppMotion.pop,
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: art,
        ),
      ),
    );

    if (state == HandCardState.loser) {
      card = ColorFiltered(
        colorFilter: const ColorFilter.matrix(_greyscale),
        child: Opacity(opacity: 0.7, child: card),
      );
    }

    return Semantics(
      label: widget.semanticLabel,
      liveRegion: showsMove,
      child: AnimatedBuilder(
        animation: _shake,
        builder: (context, child) {
          final dy = shaking && !reduced
              ? -math.sin(_shake.value * math.pi * 3).abs() * size * 0.14
              : 0.0;
          return Transform.translate(offset: Offset(0, dy), child: child);
        },
        child: AnimatedScale(
          scale: scale,
          duration: AppMotion.of(context, AppMotion.celebrate),
          curve: AppMotion.pop,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              card,
              if (state == HandCardState.winner)
                PositionedDirectional(
                  top: -size * 0.12,
                  end: -size * 0.12,
                  child: _WinnerStar(size: size * 0.34),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WinnerStar extends StatelessWidget {
  const _WinnerStar({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = GameColors.of(context);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AppMotion.of(context, AppMotion.celebrate),
      curve: AppMotion.pop,
      builder: (context, t, child) => Transform.scale(
        scale: t,
        child: Transform.rotate(angle: (1 - t) * -1.2, child: child),
      ),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: colors.star,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: Color.lerp(colors.star, Colors.black, 0.25)!,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(Icons.star_rounded, color: Colors.white, size: size * 0.7),
      ),
    );
  }
}

const _greyscale = <double>[
  0.2126, 0.7152, 0.0722, 0, 0, //
  0.2126, 0.7152, 0.0722, 0, 0, //
  0.2126, 0.7152, 0.0722, 0, 0, //
  0, 0, 0, 1, 0,
];
