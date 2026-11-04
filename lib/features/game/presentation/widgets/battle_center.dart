import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/core/l10n/l10n.dart';
import 'package:rock_paper_scissors/core/theme/app_motion.dart';
import 'package:rock_paper_scissors/core/theme/app_spacing.dart';
import 'package:rock_paper_scissors/core/theme/game_colors.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/move.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/round_outcome.dart';
import 'package:rock_paper_scissors/features/game/presentation/bloc/game_phase.dart';
import 'package:rock_paper_scissors/features/game/presentation/mappers/move_asset.dart';

/// Middle of the stage: a prompt while picking, the "rock, paper, scissors"
/// chant while revealing, then a big result banner. Content keeps its natural
/// width, so wrap it in a [FittedBox] where space is tight.
class BattleCenter extends StatefulWidget {
  const BattleCenter({
    super.key,
    required this.phase,
    required this.outcome,
    required this.robotName,
    required this.chantDuration,
    this.onBeat,
  });

  final GamePhase phase;
  final RoundOutcome? outcome;
  final String robotName;
  final Duration chantDuration;

  /// Called at the start of each of the three chant beats.
  final ValueChanged<int>? onBeat;

  @override
  State<BattleCenter> createState() => _BattleCenterState();
}

class _BattleCenterState extends State<BattleCenter>
    with TickerProviderStateMixin {
  static const _beats = 3;

  late final AnimationController _chant = AnimationController(
    vsync: this,
    duration: widget.chantDuration,
    animationBehavior: AnimationBehavior.preserve,
  )..addListener(_onChantTick);

  late final AnimationController _bob = AnimationController(
    vsync: this,
    duration: AppMotion.pulse,
  );

  int _beat = -1;

  @override
  void initState() {
    super.initState();
    if (widget.phase == GamePhase.revealing) _startChant();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncBob();
  }

  @override
  void didUpdateWidget(covariant BattleCenter oldWidget) {
    super.didUpdateWidget(oldWidget);
    _chant.duration = widget.chantDuration;
    if (widget.phase == GamePhase.revealing &&
        oldWidget.phase != GamePhase.revealing) {
      _startChant();
    }
    _syncBob();
  }

  void _startChant() {
    _beat = 0;
    _chant.forward(from: 0);
    widget.onBeat?.call(0);
  }

  void _onChantTick() {
    final beat = (_chant.value * _beats).floor().clamp(0, _beats - 1);
    if (beat == _beat) return;
    setState(() => _beat = beat);
    widget.onBeat?.call(beat);
  }

  void _syncBob() {
    final shouldBob =
        widget.phase == GamePhase.picking && !AppMotion.reduced(context);
    if (shouldBob && !_bob.isAnimating) {
      _bob.repeat(reverse: true);
    } else if (!shouldBob && _bob.isAnimating) {
      _bob
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _chant.dispose();
    _bob.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget content = switch (widget.phase) {
      GamePhase.picking => _Prompt(key: const ValueKey('prompt'), bob: _bob),
      GamePhase.revealing => _ChantWord(
          key: ValueKey('chant$_beat'),
          move: Move.values[_beat.clamp(0, _beats - 1)],
          last: _beat >= _beats - 1,
        ),
      GamePhase.roundResult || GamePhase.matchOver => _ResultBanner(
          key: ValueKey('result${widget.outcome}'),
          outcome: widget.outcome,
          robotName: widget.robotName,
          showHint: widget.phase == GamePhase.roundResult,
        ),
    };

    return Semantics(
      liveRegion: true,
      child: AnimatedSwitcher(
        duration: AppMotion.of(context, AppMotion.quick),
        switchInCurve: Curves.easeOutBack,
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: animation, child: child),
        ),
        child: content,
      ),
    );
  }
}

class _Prompt extends StatelessWidget {
  const _Prompt({super.key, required this.bob});

  final Animation<double> bob;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: bob,
          builder: (context, child) => Transform.translate(
            offset: Offset(0, bob.value * 6),
            child: child,
          ),
          child: Icon(
            Icons.keyboard_double_arrow_down_rounded,
            size: 28,
            color: scheme.primary,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          context.l10n.pickPrompt,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge?.copyWith(
            color: scheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _ChantWord extends StatelessWidget {
  const _ChantWord({super.key, required this.move, required this.last});

  final Move move;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = move.color(context);
    final ink = Color.lerp(color, Colors.black, 0.35)!;

    return Text(
      '${move.label(context)}${last ? '!' : '…'}',
      textAlign: TextAlign.center,
      style: theme.textTheme.headlineMedium?.copyWith(
        color: ink,
        fontWeight: FontWeight.w800,
        shadows: const [Shadow(color: Colors.white, offset: Offset(0, 3))],
      ),
    );
  }
}

class _ResultBanner extends StatelessWidget {
  const _ResultBanner({
    super.key,
    required this.outcome,
    required this.robotName,
    required this.showHint,
  });

  final RoundOutcome? outcome;
  final String robotName;
  final bool showHint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = GameColors.of(context);
    final l10n = context.l10n;
    final outcome = this.outcome;
    if (outcome == null) return const SizedBox.shrink();

    final (text, icon, color) = switch (outcome) {
      RoundOutcome.win => (l10n.youWin, Icons.emoji_events_rounded, colors.win),
      RoundOutcome.loss => (
          l10n.robotWins(robotName),
          Icons.smart_toy_rounded,
          colors.loss,
        ),
      RoundOutcome.draw => (l10n.draw, Icons.handshake_rounded, colors.draw),
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Color.lerp(color, Colors.black, 0.3)!,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xlg,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showHint) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.tapToContinue,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }
}
