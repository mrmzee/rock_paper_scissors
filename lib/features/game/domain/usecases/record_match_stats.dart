import 'package:rock_paper_scissors/features/game/domain/entities/match.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/player_stats.dart';
import 'package:rock_paper_scissors/features/game/domain/repositories/stats_repository.dart';

/// Merges a finished (or abandoned) match into lifetime stats.
final class RecordMatchStats {
  const RecordMatchStats(this._stats);

  final StatsRepository _stats;

  Future<PlayerStats> call(Match match) async {
    final current = await _stats.load();
    if (match.history.isEmpty) return current;

    final updated = current.including(match);
    await _stats.save(updated);
    return updated;
  }

  /// Lifetime stats as they will be once [match] is recorded, without saving.
  Future<PlayerStats> preview(Match match) async {
    return (await _stats.load()).including(match);
  }
}
