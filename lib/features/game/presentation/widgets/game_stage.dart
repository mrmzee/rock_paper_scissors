import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/core/l10n/l10n.dart';
import 'package:rock_paper_scissors/core/theme/app_motion.dart';
import 'package:rock_paper_scissors/core/theme/app_spacing.dart';
import 'package:rock_paper_scissors/core/theme/game_colors.dart';
import 'package:rock_paper_scissors/core/widgets/chunky_button.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/move.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/round.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/round_outcome.dart';
import 'package:rock_paper_scissors/features/game/presentation/bloc/game_phase.dart';
import 'package:rock_paper_scissors/features/game/presentation/bloc/game_state.dart';
import 'package:rock_paper_scissors/features/game/presentation/mappers/match_sides.dart';
import 'package:rock_paper_scissors/features/game/presentation/mappers/move_asset.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/battle_center.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/hand_card.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/opponent_avatar.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/player_badge.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/robot_avatar.dart';

/// The arena: robot (or Player 2) and player hands facing each other with the
/// chant and round result in between. In pass-and-play a cover hides the
/// board while the device changes hands.
class GameStage extends StatelessWidget {
  const GameStage({
    super.key,
    required this.state,
    required this.landscape,
    required this.chantDuration,
    required this.confetti,
    required this.confettiParticles,
    required this.onBeat,
    required this.onContinue,
    required this.onHandoffReady,
  });

  final GameState state;
  final bool landscape;
  final Duration chantDuration;
  final ConfettiController confetti;
  final int confettiParticles;
  final ValueChanged<int> onBeat;
  final VoidCallback onContinue;
  final VoidCallback onHandoffReady;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final colors = GameColors.of(context);
    final phase = state.phase;
    final match = state.match;
    final passAndPlay = match.isPassAndPlay;
    final playerName = match.playerName(context);
    final opponentName = match.opponentName(context);
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
        playerName,
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
      semanticLabel: handLabel(opponentName, round?.opponentMove, robotState),
    );
    final playerInfo = _PlayerInfo(
      name: playerName,
      streak: passAndPlay ? 0 : match.currentStreak,
    );
    final robotInfo = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        OpponentAvatar(
          match: match,
          mood: _robotMood(phase, outcome),
          size: 84,
          semanticLabel: opponentName,
        ),
        const SizedBox(height: AppSpacing.xxs),
        _NameTag(text: opponentName),
      ],
    );
    final prompt = !passAndPlay
        ? l10n.pickPrompt
        : l10n.playerTurn(state.firstMove == null ? playerName : opponentName);
    final center = SizedBox(
      height: landscape ? null : 84,
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: BattleCenter(
            phase: phase,
            outcome: outcome,
            prompt: prompt,
            opponentName: opponentName,
            playerName: passAndPlay ? playerName : null,
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
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: AppMotion.of(context, AppMotion.quick),
                child: phase == GamePhase.handoff
                    ? _HandoffCover(
                        playerName: opponentName,
                        onReady: onHandoffReady,
                      )
                    : const SizedBox.shrink(),
              ),
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
      GamePhase.picking || GamePhase.handoff => HandCardState.hidden,
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
      GamePhase.picking || GamePhase.handoff => RobotMood.idle,
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

/// Covers the board so Player 1's pick stays secret while the device is
/// passed to [playerName].
class _HandoffCover extends StatelessWidget {
  const _HandoffCover({required this.playerName, required this.onReady});

  final String playerName;
  final VoidCallback onReady;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = context.l10n;

    return DecoratedBox(
      key: const Key('handoff_cover'),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const PlayerBadge(size: 88, second: true),
                const SizedBox(height: AppSpacing.md),
                Semantics(
                  liveRegion: true,
                  child: Text(
                    l10n.handoffTitle(playerName),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  l10n.handoffHint,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                ChunkyButton(
                  key: const Key('handoff_ready'),
                  color: scheme.secondary,
                  onPressed: onReady,
                  semanticLabel: l10n.handoffReady,
                  child: Text(
                    l10n.handoffReady,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: scheme.onSecondary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayerInfo extends StatelessWidget {
  const _PlayerInfo({required this.name, required this.streak});

  final String name;
  final int streak;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const PlayerBadge(size: 72),
        const SizedBox(height: AppSpacing.xs),
        _NameTag(text: name),
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
