import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:rock_paper_scissors/features/game/data/repositories/adaptive_opponent_strategy.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/move.dart';

/// Replays fixed values so each branch of the strategy is deterministic.
class _FakeRandom implements Random {
  _FakeRandom({this.doubles = const [], this.ints = const []});

  final List<double> doubles;
  final List<int> ints;
  int _doubleIndex = 0;
  int _intIndex = 0;

  @override
  double nextDouble() => doubles[_doubleIndex++];

  @override
  int nextInt(int max) => ints[_intIndex++];

  @override
  bool nextBool() => throw UnimplementedError();
}

void main() {
  Move play(
    Difficulty difficulty,
    List<Move> history, {
    List<double> doubles = const [],
    List<int> ints = const [],
  }) {
    return AdaptiveOpponentStrategy(
      random: _FakeRandom(doubles: doubles, ints: ints),
    ).nextMove(difficulty: difficulty, playerHistory: history);
  }

  test('easy always plays randomly', () {
    expect(
      play(Difficulty.easy, [Move.rock, Move.rock, Move.rock], ints: [2]),
      Move.scissors,
    );
  });

  test('plays randomly before the player has any history', () {
    expect(play(Difficulty.hard, [], ints: [1]), Move.paper);
  });

  group('normal', () {
    test('counters the most frequent recent move within its chance', () {
      expect(
        play(
          Difficulty.normal,
          [Move.scissors, Move.rock, Move.rock],
          doubles: [0.45],
        ),
        Move.paper,
      );
    });

    test('plays randomly above its chance', () {
      expect(
        play(
          Difficulty.normal,
          [Move.rock, Move.rock, Move.rock],
          doubles: [0.46],
          ints: [2],
        ),
        Move.scissors,
      );
    });
  });

  group('hard', () {
    test('counters the last move when recent moves are tied', () {
      expect(
        play(
          Difficulty.hard,
          [Move.rock, Move.paper, Move.scissors],
          doubles: [0.8],
        ),
        Move.rock,
      );
    });

    test('counters the last move with a short history', () {
      expect(
        play(Difficulty.hard, [Move.paper], doubles: [0.1]),
        Move.scissors,
      );
    });

    test('plays randomly above its chance', () {
      expect(
        play(Difficulty.hard, [Move.rock], doubles: [0.81], ints: [0]),
        Move.rock,
      );
    });
  });
}
