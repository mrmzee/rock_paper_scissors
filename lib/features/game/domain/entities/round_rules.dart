import 'package:rock_paper_scissors/features/game/domain/entities/move.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/round_outcome.dart';

/// Decides who won a round. This rule does not depend on UI or randomness.
abstract final class RoundRules {
  static RoundOutcome decide({
    required Move playerMove,
    required Move opponentMove,
  }) {
    if (playerMove == opponentMove) {
      return RoundOutcome.draw;
    }

    final playerWins = playerMove.beats == opponentMove;
    return playerWins ? RoundOutcome.win : RoundOutcome.loss;
  }
}
