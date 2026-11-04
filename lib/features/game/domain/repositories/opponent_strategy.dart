import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/move.dart';

/// Chooses the computer's next hand.
abstract interface class OpponentStrategy {
  Move nextMove({
    required Difficulty difficulty,
    required List<Move> playerHistory,
  });
}
