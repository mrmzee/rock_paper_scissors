import 'package:flutter_test/flutter_test.dart';
import 'package:rock_paper_scissors/features/game/data/repositories/preferences_stats_repository.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/player_stats.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('loads empty stats on first launch', () async {
    final repository = PreferencesStatsRepository(
      await SharedPreferences.getInstance(),
    );

    expect(await repository.load(), const PlayerStats());
  });

  test('round-trips saved stats across instances', () async {
    const stats = PlayerStats(
      matchesPlayed: 4,
      matchesWon: 3,
      matchesLost: 1,
      roundsWon: 10,
      roundsDrawn: 2,
      roundsLost: 5,
      bestStreak: 4,
    );

    await PreferencesStatsRepository(
      await SharedPreferences.getInstance(),
    ).save(stats);
    final reloaded = PreferencesStatsRepository(
      await SharedPreferences.getInstance(),
    );

    expect(await reloaded.load(), stats);
  });
}
