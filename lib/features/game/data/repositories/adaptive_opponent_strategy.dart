import 'dart:math';

import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/move.dart';
import 'package:rock_paper_scissors/features/game/domain/repositories/opponent_strategy.dart';

/// Easy = random, Normal = light counter, Hard = strong pattern counter.
final class AdaptiveOpponentStrategy implements OpponentStrategy {
  AdaptiveOpponentStrategy({Random? random}) : _random = random ?? Random();

  final Random _random;

  @override
  Move nextMove({
    required Difficulty difficulty,
    required List<Move> playerHistory,
  }) {
    return switch (difficulty) {
      Difficulty.easy => _randomMove(),
      Difficulty.normal => _maybeCounter(playerHistory, chance: 0.45),
      Difficulty.hard => _maybeCounter(playerHistory, chance: 0.8),
    };
  }

  Move _maybeCounter(List<Move> playerHistory, {required double chance}) {
    if (playerHistory.isEmpty || _random.nextDouble() > chance) {
      return _randomMove();
    }

    final predicted = _predictPlayerMove(playerHistory);
    return predicted.beatenBy;
  }

  Move _predictPlayerMove(List<Move> history) {
    if (history.length >= 3) {
      final recent = history.sublist(history.length - 3);
      final counts = <Move, int>{
        for (final move in Move.values) move: 0,
      };
      for (final move in recent) {
        counts[move] = counts[move]! + 1;
      }
      final sorted = counts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      if (sorted.first.value > sorted[1].value) {
        return sorted.first.key;
      }
    }

    return history.last;
  }

  Move _randomMove() {
    const values = Move.values;
    return values[_random.nextInt(values.length)];
  }
}
