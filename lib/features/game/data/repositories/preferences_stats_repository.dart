import 'package:rock_paper_scissors/features/game/domain/entities/player_stats.dart';
import 'package:rock_paper_scissors/features/game/domain/repositories/stats_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class PreferencesStatsRepository implements StatsRepository {
  PreferencesStatsRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _matchesPlayed = 'stats.matchesPlayed';
  static const _matchesWon = 'stats.matchesWon';
  static const _matchesLost = 'stats.matchesLost';
  static const _roundsWon = 'stats.roundsWon';
  static const _roundsDrawn = 'stats.roundsDrawn';
  static const _roundsLost = 'stats.roundsLost';
  static const _bestStreak = 'stats.bestStreak';

  @override
  Future<PlayerStats> load() async {
    return PlayerStats(
      matchesPlayed: _prefs.getInt(_matchesPlayed) ?? 0,
      matchesWon: _prefs.getInt(_matchesWon) ?? 0,
      matchesLost: _prefs.getInt(_matchesLost) ?? 0,
      roundsWon: _prefs.getInt(_roundsWon) ?? 0,
      roundsDrawn: _prefs.getInt(_roundsDrawn) ?? 0,
      roundsLost: _prefs.getInt(_roundsLost) ?? 0,
      bestStreak: _prefs.getInt(_bestStreak) ?? 0,
    );
  }

  @override
  Future<void> save(PlayerStats stats) async {
    await Future.wait([
      _prefs.setInt(_matchesPlayed, stats.matchesPlayed),
      _prefs.setInt(_matchesWon, stats.matchesWon),
      _prefs.setInt(_matchesLost, stats.matchesLost),
      _prefs.setInt(_roundsWon, stats.roundsWon),
      _prefs.setInt(_roundsDrawn, stats.roundsDrawn),
      _prefs.setInt(_roundsLost, stats.roundsLost),
      _prefs.setInt(_bestStreak, stats.bestStreak),
    ]);
  }
}
