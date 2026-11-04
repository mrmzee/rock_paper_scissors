import 'package:flutter_test/flutter_test.dart';
import 'package:rock_paper_scissors/features/game/data/repositories/in_memory_stats_repository.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match_mode.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/move.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/player_stats.dart';
import 'package:rock_paper_scissors/features/game/domain/usecases/play_round.dart';
import 'package:rock_paper_scissors/features/game/domain/usecases/record_match_stats.dart';

import '../../../../helpers/sequence_opponent_strategy.dart';

Match _play({
  required List<Move> robot,
  required List<Move> player,
  MatchMode mode = MatchMode.bestOf5,
  Difficulty difficulty = Difficulty.normal,
}) {
  final playRound = PlayRound(SequenceOpponentStrategy(robot));
  var match = Match.start(mode: mode, difficulty: difficulty);
  for (final move in player) {
    match = playRound(match: match, playerMove: move);
  }
  return match;
}

void main() {
  test('records rounds and match outcome into lifetime stats', () async {
    final record = RecordMatchStats(InMemoryStatsRepository());

    final stats = await record(
      _play(
        robot: [Move.rock, Move.rock, Move.rock],
        player: [Move.paper, Move.paper, Move.paper],
      ),
    );

    expect(stats.matchesPlayed, 1);
    expect(stats.matchesWon, 1);
    expect(stats.roundsWon, 3);
    expect(stats.bestStreak, 3);
    expect(stats.currentStreak, 3);
  });

  test('tracks favorite move and win rate per robot', () async {
    final record = RecordMatchStats(InMemoryStatsRepository());

    await record(
      _play(
        mode: MatchMode.endless,
        difficulty: Difficulty.hard,
        robot: [Move.rock, Move.rock, Move.paper, Move.rock],
        // win, draw, loss, win
        player: [Move.paper, Move.rock, Move.rock, Move.paper],
      ),
    );
    final stats = await record(
      _play(
        mode: MatchMode.endless,
        difficulty: Difficulty.easy,
        robot: [Move.scissors],
        player: [Move.rock],
      ),
    );

    expect(stats.movesPlayed, {Move.paper: 2, Move.rock: 3});
    expect(stats.favoriteMove, Move.rock);
    expect(stats.winRateAgainst(Difficulty.hard), 0.5);
    expect(stats.winRateAgainst(Difficulty.easy), 1);
    expect(stats.winRateAgainst(Difficulty.normal), isNull);
    expect(stats.currentStreak, 2);
    expect(stats.bestStreak, 2);
  });

  test('a streak carries across matches and resets on a loss', () async {
    final repository = InMemoryStatsRepository(
      const PlayerStats(currentStreak: 4, bestStreak: 5),
    );
    final record = RecordMatchStats(repository);

    var stats = await record(
      _play(
        mode: MatchMode.endless,
        robot: [Move.rock, Move.rock],
        player: [Move.paper, Move.paper],
      ),
    );
    expect(stats.currentStreak, 6);
    expect(stats.bestStreak, 6);

    stats = await record(
      _play(mode: MatchMode.endless, robot: [Move.paper], player: [Move.rock]),
    );
    expect(stats.currentStreak, 0);
    expect(stats.bestStreak, 6);
  });

  test('an empty match changes nothing', () async {
    final repository = InMemoryStatsRepository();

    final stats = await RecordMatchStats(repository)(
      _play(robot: const [], player: const []),
    );

    expect(stats, const PlayerStats());
  });
}
