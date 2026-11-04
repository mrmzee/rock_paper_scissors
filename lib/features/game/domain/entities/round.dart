import 'package:equatable/equatable.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/move.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/round_outcome.dart';

/// One completed exchange of hands.
final class Round extends Equatable {
  const Round({
    required this.playerMove,
    required this.opponentMove,
    required this.outcome,
  });

  final Move playerMove;
  final Move opponentMove;
  final RoundOutcome outcome;

  @override
  List<Object?> get props => [playerMove, opponentMove, outcome];
}
