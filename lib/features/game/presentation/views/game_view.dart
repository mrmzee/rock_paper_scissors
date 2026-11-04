import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rock_paper_scissors/core/audio/sound_service.dart';
import 'package:rock_paper_scissors/core/theme/app_motion.dart';
import 'package:rock_paper_scissors/core/theme/app_spacing.dart';
import 'package:rock_paper_scissors/core/widgets/app_background.dart';
import 'package:rock_paper_scissors/features/achievements/presentation/widgets/achievement_snack_bar.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/move.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/round_outcome.dart';
import 'package:rock_paper_scissors/features/game/presentation/bloc/game_bloc.dart';
import 'package:rock_paper_scissors/features/game/presentation/bloc/game_event.dart';
import 'package:rock_paper_scissors/features/game/presentation/bloc/game_phase.dart';
import 'package:rock_paper_scissors/features/game/presentation/bloc/game_state.dart';
import 'package:rock_paper_scissors/features/game/presentation/mappers/match_sides.dart';
import 'package:rock_paper_scissors/features/game/presentation/views/match_result_page.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/game_stage.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/game_top_bar.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/move_pad.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/pause_sheet.dart';

/// Face-off layout: the robot (or a friend) on one side, the child on the
/// other, the chant and result in between, and the hand buttons in the thumb
/// zone.
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
  int _toastedAchievements = 0;

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  void _onRoundRevealed(BuildContext context, GameState state) {
    final outcome = state.pendingRound?.outcome;
    switch (outcome) {
      case RoundOutcome.loss when state.match.isPassAndPlay:
        HapticFeedback.mediumImpact();
        context.playSfx(Sfx.win);
        _celebrate(0);
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
      MatchResultPage.route(match, achievements: bloc.state.achievements),
    );
    if (!mounted) return;
    if (action == MatchResultAction.playAgain) {
      bloc.add(const GameResetRequested());
    } else {
      Navigator.of(context).pop();
    }
  }

  void _onAchievementsEarned(BuildContext context, GameState state) {
    final messenger = ScaffoldMessenger.of(context);
    for (final achievement in state.achievements.skip(_toastedAchievements)) {
      messenger.showSnackBar(achievementSnackBar(context, achievement));
    }
    _toastedAchievements = state.achievements.length;
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

  void _confirmHandoff() {
    HapticFeedback.selectionClick();
    context.playSfx(Sfx.tap);
    context.read<GameBloc>().add(const GameHandoffConfirmed());
  }

  void _pick(Move move) {
    HapticFeedback.selectionClick();
    context.playSfx(Sfx.tap);
    context.read<GameBloc>().add(GameMoveSelected(move));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameBloc, GameState>(
      // The result page lists badges earned in the final round instead.
      listenWhen: (previous, current) =>
          previous.achievements != current.achievements &&
          current.phase != GamePhase.matchOver,
      listener: _onAchievementsEarned,
      child: _buildGame(context),
    );
  }

  Widget _buildGame(BuildContext context) {
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
                              GameTopBar(
                                match: match,
                                onBack: () => Navigator.of(context).maybePop(),
                                onPause: _openPauseMenu,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Expanded(
                                child: GameStage(
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
                                  onHandoffReady: _confirmHandoff,
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
