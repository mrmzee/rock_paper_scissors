import 'package:rock_paper_scissors/features/game/domain/entities/player_stats.dart';
import 'package:rock_paper_scissors/features/game/domain/repositories/stats_repository.dart';

/// Test-friendly stats store.
final class InMemoryStatsRepository implements StatsRepository {
  InMemoryStatsRepository([this._stats = const PlayerStats()]);

  PlayerStats _stats;

  @override
  Future<PlayerStats> load() async => _stats;

  @override
  Future<void> save(PlayerStats stats) async {
    _stats = stats;
  }
}
