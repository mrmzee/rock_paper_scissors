import 'package:flutter_test/flutter_test.dart';
import 'package:rock_paper_scissors/features/game/data/repositories/in_memory_stats_repository.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match_mode.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/move.dart';
import 'package:rock_paper_scissors/features/game/domain/usecases/play_round.dart';
import 'package:rock_paper_scissors/features/game/domain/usecases/record_match_stats.dart';

import '../../../../helpers/sequence_opponent_strategy.dart';

void main() {
  test('records rounds and match outcome into lifetime stats', () async {
    final repo = InMemoryStatsRepository();
    final record = RecordMatchStats(repo);
    final playRound = PlayRound(
      SequenceOpponentStrategy([Move.rock, Move.rock, Move.rock]),
    );

    var match = Match.start(
      mode: MatchMode.bestOf5,
      difficulty: Difficulty.normal,
    );
    match = playRound(match: match, playerMove: Move.paper);
    match = playRound(match: match, playerMove: Move.paper);
    match = playRound(match: match, playerMove: Move.paper);

    final stats = await record(match);

    expect(stats.matchesPlayed, 1);
    expect(stats.matchesWon, 1);
    expect(stats.roundsWon, 3);
    expect(stats.bestStreak, 3);
  });
}
