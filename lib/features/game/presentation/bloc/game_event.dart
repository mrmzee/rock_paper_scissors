import 'package:equatable/equatable.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match_mode.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/move.dart';

sealed class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

final class GameStarted extends GameEvent {
  const GameStarted({
    required this.mode,
    required this.difficulty,
  });

  final MatchMode mode;
  final Difficulty difficulty;

  @override
  List<Object?> get props => [mode, difficulty];
}

final class GameMoveSelected extends GameEvent {
  const GameMoveSelected(this.move);

  final Move move;

  @override
  List<Object?> get props => [move];
}

final class GameRoundAcknowledged extends GameEvent {
  const GameRoundAcknowledged();
}

final class GameResetRequested extends GameEvent {
  const GameResetRequested();
}

final class GameExited extends GameEvent {
  const GameExited();
}
