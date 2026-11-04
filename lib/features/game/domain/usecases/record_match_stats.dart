import 'package:rock_paper_scissors/features/game/domain/entities/match.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/player_stats.dart';
import 'package:rock_paper_scissors/features/game/domain/repositories/stats_repository.dart';

/// Merges a finished (or abandoned) match into lifetime stats.
final class RecordMatchStats {
  const RecordMatchStats(this._stats);

  final StatsRepository _stats;

  Future<PlayerStats> call(Match match) async {
    if (match.history.isEmpty) {
      return _stats.load();
    }

    final current = await _stats.load();
    final score = match.scoreboard;
    final nextBest = match.bestStreak > current.bestStreak
        ? match.bestStreak
        : current.bestStreak;

    final updated = current.copyWith(
      matchesPlayed: current.matchesPlayed + 1,
      matchesWon: current.matchesWon + (match.playerWon == true ? 1 : 0),
      matchesLost: current.matchesLost + (match.playerWon == false ? 1 : 0),
      roundsWon: current.roundsWon + score.wins,
      roundsDrawn: current.roundsDrawn + score.draws,
      roundsLost: current.roundsLost + score.losses,
      bestStreak: nextBest,
    );

    await _stats.save(updated);
    return updated;
  }
}
