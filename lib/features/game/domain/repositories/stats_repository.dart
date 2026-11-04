import 'package:rock_paper_scissors/features/game/domain/entities/player_stats.dart';

/// Reads and writes lifetime player statistics.
abstract interface class StatsRepository {
  Future<PlayerStats> load();

  Future<void> save(PlayerStats stats);
}
