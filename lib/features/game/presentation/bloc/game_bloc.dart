import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rock_paper_scissors/features/achievements/domain/usecases/unlock_achievements.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/round.dart';
import 'package:rock_paper_scissors/features/game/domain/usecases/play_round.dart';
import 'package:rock_paper_scissors/features/game/domain/usecases/record_match_stats.dart';
import 'package:rock_paper_scissors/features/game/presentation/bloc/game_event.dart';
import 'package:rock_paper_scissors/features/game/presentation/bloc/game_phase.dart';
import 'package:rock_paper_scissors/features/game/presentation/bloc/game_state.dart';

/// Orchestrates match flow and reveal timing. Rules live in the domain.
final class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({
    required PlayRound playRound,
    required RecordMatchStats recordMatchStats,
    required UnlockAchievements unlockAchievements,
    required Match initialMatch,
    this.revealDelay = defaultRevealDelay,
    this.resultDelay = defaultResultDelay,
  })  : _playRound = playRound,
        _recordMatchStats = recordMatchStats,
        _unlockAchievements = unlockAchievements,
        super(GameState.initial(initialMatch)) {
    on<GameStarted>(_onStarted);
    on<GameMoveSelected>(_onMoveSelected);
    on<GameRoundAcknowledged>(_onRoundAcknowledged);
    on<GameResetRequested>(_onReset);
    on<GameExited>(_onExited);
  }

  /// Long enough for the three-beat "rock, paper, scissors" chant.
  static const defaultRevealDelay = Duration(milliseconds: 1500);
  static const defaultResultDelay = Duration(milliseconds: 1800);

  final PlayRound _playRound;
  final RecordMatchStats _recordMatchStats;
  final UnlockAchievements _unlockAchievements;
  final Duration revealDelay;
  final Duration resultDelay;

  bool _statsRecorded = false;

  void _onStarted(GameStarted event, Emitter<GameState> emit) {
    _statsRecorded = false;
    emit(
      GameState.initial(
        Match.start(mode: event.mode, difficulty: event.difficulty),
      ),
    );
  }

  Future<void> _onMoveSelected(
    GameMoveSelected event,
    Emitter<GameState> emit,
  ) async {
    if (!state.canPick) return;

    final updated = _playRound(match: state.match, playerMove: event.move);
    final round = updated.lastRound!;

    emit(
      state.copyWith(
        match: updated,
        selectedMove: event.move,
        pendingRound: round,
        phase: GamePhase.revealing,
      ),
    );

    await Future<void>.delayed(revealDelay);
    if (emit.isDone || !_isCurrent(round, GamePhase.revealing)) return;

    emit(
      state.copyWith(
        pendingRound: round,
        phase: updated.isOver ? GamePhase.matchOver : GamePhase.roundResult,
      ),
    );

    await _unlockFor(updated, emit);
    if (updated.isOver) {
      await _persistStats(updated);
    } else {
      await Future<void>.delayed(resultDelay);
      if (emit.isDone || !_isCurrent(round, GamePhase.roundResult)) return;
      emit(
        state.copyWith(
          phase: GamePhase.picking,
          clearPending: true,
          clearSelected: true,
        ),
      );
    }
  }

  void _onRoundAcknowledged(
    GameRoundAcknowledged event,
    Emitter<GameState> emit,
  ) {
    if (state.phase != GamePhase.roundResult) return;
    emit(
      state.copyWith(
        phase: GamePhase.picking,
        clearPending: true,
        clearSelected: true,
      ),
    );
  }

  Future<void> _onReset(
    GameResetRequested event,
    Emitter<GameState> emit,
  ) async {
    await _persistStats(state.match);
    _statsRecorded = false;
    emit(
      GameState.initial(
        Match.start(
          mode: state.match.mode,
          difficulty: state.match.difficulty,
        ),
      ),
    );
  }

  Future<void> _onExited(GameExited event, Emitter<GameState> emit) async {
    await _persistStats(state.match);
  }

  /// False once the round was skipped or the match was reset meanwhile.
  bool _isCurrent(Round round, GamePhase phase) {
    return state.phase == phase && identical(state.pendingRound, round);
  }

  /// Badges are checked after every round so Endless matches earn them too;
  /// this must run before the match is recorded so the preview counts it once.
  Future<void> _unlockFor(Match match, Emitter<GameState> emit) async {
    if (_statsRecorded) return;
    final stats = await _recordMatchStats.preview(match);
    final earned = await _unlockAchievements(match, stats);
    if (earned.isEmpty || emit.isDone || !identical(state.match, match)) {
      return;
    }
    emit(state.copyWith(achievements: [...state.achievements, ...earned]));
  }

  Future<void> _persistStats(Match match) async {
    if (_statsRecorded || match.history.isEmpty) return;
    _statsRecorded = true;
    await _recordMatchStats(match);
  }
}
