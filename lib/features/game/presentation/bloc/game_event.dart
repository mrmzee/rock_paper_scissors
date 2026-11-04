import 'package:equatable/equatable.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match_mode.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/move.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/opponent.dart';

sealed class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

final class GameStarted extends GameEvent {
  const GameStarted({
    required this.mode,
    required this.difficulty,
    this.opponent = Opponent.robot,
  });

  final MatchMode mode;
  final Difficulty difficulty;
  final Opponent opponent;

  @override
  List<Object?> get props => [mode, difficulty, opponent];
}

final class GameMoveSelected extends GameEvent {
  const GameMoveSelected(this.move);

  final Move move;

  @override
  List<Object?> get props => [move];
}

/// Player 2 has the device and is ready to pick.
final class GameHandoffConfirmed extends GameEvent {
  const GameHandoffConfirmed();
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
