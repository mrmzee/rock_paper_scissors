import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rock_paper_scissors/core/audio/sound_service.dart';
import 'package:rock_paper_scissors/core/l10n/l10n.dart';
import 'package:rock_paper_scissors/core/theme/app_motion.dart';
import 'package:rock_paper_scissors/core/theme/app_spacing.dart';
import 'package:rock_paper_scissors/core/theme/game_colors.dart';
import 'package:rock_paper_scissors/core/widgets/app_background.dart';
import 'package:rock_paper_scissors/core/widgets/chunky_button.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match_mode.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/move.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/round.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/round_outcome.dart';
import 'package:rock_paper_scissors/features/game/presentation/bloc/game_bloc.dart';
import 'package:rock_paper_scissors/features/game/presentation/bloc/game_event.dart';
import 'package:rock_paper_scissors/features/game/presentation/bloc/game_phase.dart';
import 'package:rock_paper_scissors/features/game/presentation/bloc/game_state.dart';
import 'package:rock_paper_scissors/features/game/presentation/mappers/move_asset.dart';
import 'package:rock_paper_scissors/features/game/presentation/mappers/robot_look.dart';
import 'package:rock_paper_scissors/features/game/presentation/views/match_result_page.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/battle_center.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/hand_card.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/move_pad.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/pause_sheet.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/player_badge.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/robot_avatar.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/score_strip.dart';

/// Face-off layout: the robot on one side, the child on the other, the chant
/// and result in between, and the hand buttons in the thumb zone.
class GameView extends StatefulWidget {
  const GameView({super.key});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  static const _resultPagePause = Duration(milliseconds: 1400);

  final _confetti = ConfettiController(
    duration: const Duration(milliseconds: 600),
  );
  int _confettiParticles = 10;

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  void _onRoundRevealed(BuildContext context, GameState state) {
    final outcome = state.pendingRound?.outcome;
    switch (outcome) {
      case RoundOutcome.win:
        HapticFeedback.mediumImpact();
        context.playSfx(Sfx.win);
        _celebrate(state.match.currentStreak);
      case RoundOutcome.loss:
        HapticFeedback.heavyImpact();
        context.playSfx(Sfx.lose);
      case RoundOutcome.draw:
        HapticFeedback.lightImpact();
        context.playSfx(Sfx.draw);
      case null:
        break;
    }

    if (state.phase == GamePhase.matchOver) {
      _showMatchResult(state.match);
    }
  }

  void _celebrate(int streak) {
    if (AppMotion.reduced(context)) return;
    setState(() => _confettiParticles = streak >= 3 ? 30 : 10);
    _confetti.play();
  }

  Future<void> _showMatchResult(Match match) async {
    final bloc = context.read<GameBloc>();
    await Future<void>.delayed(_resultPagePause);
    if (!mounted || bloc.state.phase != GamePhase.matchOver) return;

    final action = await Navigator.of(context).push(
      MatchResultPage.route(match),
    );
    if (!mounted) return;
    if (action == MatchResultAction.playAgain) {
      bloc.add(const GameResetRequested());
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> _openPauseMenu() async {
    final bloc = context.read<GameBloc>();
    final action = await showPauseSheet(context);
    if (!mounted) return;
    switch (action) {
      case PauseAction.restart:
        bloc.add(const GameResetRequested());
      case PauseAction.home:
        Navigator.of(context).pop();
      case PauseAction.resume || null:
        break;
    }
  }

  void _pick(Move move) {
    HapticFeedback.selectionClick();
    context.playSfx(Sfx.tap);
    context.read<GameBloc>().add(GameMoveSelected(move));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameBloc, GameState>(
      listenWhen: (previous, current) =>
          previous.phase != current.phase &&
          (current.phase == GamePhase.roundResult ||
              current.phase == GamePhase.matchOver),
      listener: _onRoundRevealed,
      builder: (context, state) {
        final bloc = context.read<GameBloc>();
        final match = state.match;

        return PopScope<void>(
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) bloc.add(const GameExited());
          },
          child: Scaffold(
            body: AppBackground(
              child: SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final landscape =
                        constraints.maxWidth > constraints.maxHeight;
                    final gutter =
                        constraints.maxWidth >= AppBreakpoints.expanded
                            ? AppSpacing.xlg
                            : AppSpacing.md;

                    return Padding(
                      padding: EdgeInsets.fromLTRB(
                        gutter,
                        AppSpacing.sm,
                        gutter,
                        AppSpacing.md,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 960),
                          child: Column(
                            children: [
                              _TopBar(
                                match: match,
                                onBack: () => Navigator.of(context).maybePop(),
                                onPause: _openPauseMenu,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Expanded(
                                child: _Stage(
                                  state: state,
                                  landscape: landscape,
                                  chantDuration: bloc.revealDelay,
                                  confetti: _confetti,
                                  confettiParticles: _confettiParticles,
                                  onBeat: (beat) => context.playSfx(
                                    beat < 2 ? Sfx.tick : Sfx.reveal,
                                  ),
                                  onContinue: () =>
                                      bloc.add(const GameRoundAcknowledged()),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 620),
                                child: MovePad(
                                  enabled: state.canPick,
                                  selected: state.selectedMove,
                                  compact:
                                      landscape && constraints.maxHeight < 500,
                                  onSelected: _pick,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.match,
    required this.onBack,
    required this.onPause,
  });

  final Match match;
  final VoidCallback onBack;
  final VoidCallback onPause;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      children: [
        ChunkyIconButton(
          icon: Icons.arrow_back_rounded,
          tooltip: l10n.back,
          onPressed: onBack,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Center(
            child: ScoreStrip(
              wins: match.scoreboard.wins,
              losses: match.scoreboard.losses,
              winsNeeded: match.mode.winsNeeded,
              difficulty: match.difficulty,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        ChunkyIconButton(
          icon: Icons.pause_rounded,
          tooltip: l10n.pause,
          onPressed: onPause,
        ),
      ],
    );
  }
}

class _Stage extends StatelessWidget {
  const _Stage({
    required this.state,
    required this.landscape,
    required this.chantDuration,
    required this.confetti,
    required this.confettiParticles,
    required this.onBeat,
    required this.onContinue,
  });

  final GameState state;
  final bool landscape;
  final Duration chantDuration;
  final ConfettiController confetti;
  final int confettiParticles;
  final ValueChanged<int> onBeat;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final colors = GameColors.of(context);
    final phase = state.phase;
    final match = state.match;
    final difficulty = match.difficulty;
    final robotName = difficulty.robotName(context);
    final Round? round = state.pendingRound;
    final showResult =
        phase == GamePhase.roundResult || phase == GamePhase.matchOver;
    final outcome = showResult ? round?.outcome : null;

    String handLabel(String who, Move? move, HandCardState handState) {
      final visible = move != null &&
          handState != HandCardState.hidden &&
          handState != HandCardState.shaking;
      return l10n.handSemantics(
        who,
        visible ? move.label(context) : l10n.hiddenHand,
      );
    }

    final playerState = _handState(phase, outcome, player: true);
    final robotState = _handState(phase, outcome, player: false);

    const handSize = 132.0;
    final playerHand = HandCard(
      size: handSize,
      state: playerState,
      move: round?.playerMove ?? state.selectedMove,
      shakeDuration: chantDuration,
      semanticLabel: handLabel(
        l10n.you,
        round?.playerMove ?? state.selectedMove,
        playerState,
      ),
    );
    final robotHand = HandCard(
      size: handSize,
      state: robotState,
      move: round?.opponentMove,
      shakeDuration: chantDuration,
      flipped: true,
      semanticLabel: handLabel(robotName, round?.opponentMove, robotState),
    );
    final playerInfo = _PlayerInfo(streak: match.currentStreak);
    final robotInfo = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RobotAvatar(
          difficulty: difficulty,
          mood: _robotMood(phase, outcome),
          size: 84,
          semanticLabel: robotName,
        ),
        const SizedBox(height: AppSpacing.xxs),
        _NameTag(text: robotName),
      ],
    );
    final center = SizedBox(
      height: landscape ? null : 84,
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: BattleCenter(
            phase: phase,
            outcome: outcome,
            robotName: robotName,
            chantDuration: chantDuration,
            onBeat: onBeat,
          ),
        ),
      ),
    );

    const gap = SizedBox.square(dimension: AppSpacing.lg);
    final Widget arena = landscape
        ? Row(
            children: [
              Expanded(
                child: _Fit(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [playerInfo, gap, playerHand],
                  ),
                ),
              ),
              Expanded(child: center),
              Expanded(
                child: _Fit(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [robotInfo, gap, robotHand],
                  ),
                ),
              ),
            ],
          )
        : Column(
            children: [
              Expanded(
                child: _Fit(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [robotInfo, gap, robotHand],
                  ),
                ),
              ),
              center,
              Expanded(
                child: _Fit(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [playerHand, gap, playerInfo],
                  ),
                ),
              ),
            ],
          );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: phase == GamePhase.roundResult ? onContinue : null,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surface.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.8),
            width: 2.5,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: arena,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: confetti,
                blastDirectionality: BlastDirectionality.explosive,
                numberOfParticles: confettiParticles,
                emissionFrequency: 0.3,
                gravity: 0.25,
                colors: [
                  colors.star,
                  colors.rock,
                  colors.paper,
                  colors.scissors,
                  colors.win,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static HandCardState _handState(
    GamePhase phase,
    RoundOutcome? outcome, {
    required bool player,
  }) {
    return switch (phase) {
      GamePhase.picking => HandCardState.hidden,
      GamePhase.revealing => HandCardState.shaking,
      GamePhase.roundResult || GamePhase.matchOver => switch (outcome) {
          RoundOutcome.win =>
            player ? HandCardState.winner : HandCardState.loser,
          RoundOutcome.loss =>
            player ? HandCardState.loser : HandCardState.winner,
          RoundOutcome.draw || null => HandCardState.revealed,
        },
    };
  }

  static RobotMood _robotMood(GamePhase phase, RoundOutcome? outcome) {
    return switch (phase) {
      GamePhase.picking => RobotMood.idle,
      GamePhase.revealing => RobotMood.thinking,
      GamePhase.roundResult || GamePhase.matchOver => switch (outcome) {
          RoundOutcome.win => RobotMood.sad,
          RoundOutcome.loss => RobotMood.happy,
          RoundOutcome.draw || null => RobotMood.surprised,
        },
    };
  }
}

/// Shrinks its child uniformly when the screen is too small for it.
class _Fit extends StatelessWidget {
  const _Fit({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: Center(child: FittedBox(fit: BoxFit.scaleDown, child: child)),
    );
  }
}

class _PlayerInfo extends StatelessWidget {
  const _PlayerInfo({required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const PlayerBadge(size: 72),
        const SizedBox(height: AppSpacing.xs),
        _NameTag(text: l10n.you),
        AnimatedSize(
          duration: AppMotion.of(context),
          child: streak >= 2
              ? Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xs),
                  child: _StreakChip(count: streak),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _NameTag extends StatelessWidget {
  const _NameTag({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ExcludeSemantics(
      child: Text(
        text,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w800,
          height: 1.1,
        ),
      ),
    );
  }
}

class _StreakChip extends StatelessWidget {
  const _StreakChip({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = GameColors.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.rock,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.local_fire_department_rounded,
              size: 20,
              color: colors.handInk,
            ),
            const SizedBox(width: AppSpacing.xxs),
            Text(
              context.l10n.streak(count),
              style: theme.textTheme.labelLarge?.copyWith(
                color: colors.handInk,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
