import 'package:rock_paper_scissors/features/game/domain/entities/match.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/player_stats.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/round_outcome.dart';
import 'package:rock_paper_scissors/features/game/domain/repositories/stats_repository.dart';

/// Merges a finished (or abandoned) match into lifetime stats.
final class RecordMatchStats {
  const RecordMatchStats(this._stats);

  final StatsRepository _stats;

  Future<PlayerStats> call(Match match) async {
    final current = await _stats.load();
    if (match.history.isEmpty) return current;

    final score = match.scoreboard;
    final moves = {...current.movesPlayed};
    var streak = current.currentStreak;
    var best = current.bestStreak;
    for (final round in match.history) {
      moves[round.playerMove] = (moves[round.playerMove] ?? 0) + 1;
      streak = switch (round.outcome) {
        RoundOutcome.win => streak + 1,
        RoundOutcome.draw => streak,
        RoundOutcome.loss => 0,
      };
      if (streak > best) best = streak;
    }

    final robot = match.difficulty;
    final updated = current.copyWith(
      matchesPlayed: current.matchesPlayed + 1,
      matchesWon: current.matchesWon + (match.playerWon == true ? 1 : 0),
      matchesLost: current.matchesLost + (match.playerWon == false ? 1 : 0),
      roundsWon: current.roundsWon + score.wins,
      roundsDrawn: current.roundsDrawn + score.draws,
      roundsLost: current.roundsLost + score.losses,
      bestStreak: best,
      currentStreak: streak,
      movesPlayed: moves,
      roundsPlayedBy: {
        ...current.roundsPlayedBy,
        robot: (current.roundsPlayedBy[robot] ?? 0) + score.roundsPlayed,
      },
      roundsWonBy: {
        ...current.roundsWonBy,
        robot: (current.roundsWonBy[robot] ?? 0) + score.wins,
      },
    );

    await _stats.save(updated);
    return updated;
  }
}
