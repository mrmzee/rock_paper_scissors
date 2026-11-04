import 'package:rock_paper_scissors/features/game/domain/entities/match.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/move.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/round.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/round_rules.dart';
import 'package:rock_paper_scissors/features/game/domain/repositories/opponent_strategy.dart';

/// Applies the player's chosen hand against the opponent strategy.
final class PlayRound {
  const PlayRound(this._opponent);

  final OpponentStrategy _opponent;

  Match call({
    required Match match,
    required Move playerMove,
  }) {
    if (match.isOver) return match;

    final playerHistory = match.history.map((r) => r.playerMove).toList();
    final opponentMove = _opponent.nextMove(
      difficulty: match.difficulty,
      playerHistory: playerHistory,
    );
    final outcome = RoundRules.decide(
      playerMove: playerMove,
      opponentMove: opponentMove,
    );

    return match.withRound(
      Round(
        playerMove: playerMove,
        opponentMove: opponentMove,
        outcome: outcome,
      ),
    );
  }
}
