import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/move.dart';
import 'package:rock_paper_scissors/features/game/domain/repositories/opponent_strategy.dart';

/// Returns moves in order for deterministic tests.
final class SequenceOpponentStrategy implements OpponentStrategy {
  SequenceOpponentStrategy(this.moves);

  final List<Move> moves;
  var _index = 0;

  @override
  Move nextMove({
    required Difficulty difficulty,
    required List<Move> playerHistory,
  }) {
    if (_index >= moves.length) {
      throw StateError('No more scripted opponent moves');
    }
    return moves[_index++];
  }
}
