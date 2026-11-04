import 'package:flutter_test/flutter_test.dart';
import 'package:rock_paper_scissors/features/game/data/repositories/preferences_stats_repository.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/move.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/player_stats.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<PreferencesStatsRepository> build([
    Map<String, Object> values = const {},
  ]) async {
    SharedPreferences.setMockInitialValues(values);
    return PreferencesStatsRepository(await SharedPreferences.getInstance());
  }

  const stats = PlayerStats(
    matchesPlayed: 4,
    matchesWon: 3,
    matchesLost: 1,
    roundsWon: 10,
    roundsDrawn: 2,
    roundsLost: 5,
    bestStreak: 4,
    currentStreak: 2,
    movesPlayed: {Move.rock: 9, Move.paper: 5, Move.scissors: 3},
    roundsPlayedBy: {Difficulty.easy: 7, Difficulty.hard: 10},
    roundsWonBy: {Difficulty.easy: 6, Difficulty.hard: 4},
  );

  test('loads empty stats on first launch', () async {
    final repository = await build();

    expect(await repository.load(), const PlayerStats());
  });

  test('round-trips saved stats across instances', () async {
    await (await build()).save(stats);
    final reloaded = PreferencesStatsRepository(
      await SharedPreferences.getInstance(),
    );

    expect(await reloaded.load(), stats);
  });

  test('migrates totals stored by older versions', () async {
    final repository = await build({
      'stats.matchesPlayed': 5,
      'stats.matchesWon': 2,
      'stats.matchesLost': 3,
      'stats.roundsWon': 8,
      'stats.roundsDrawn': 1,
      'stats.roundsLost': 9,
      'stats.bestStreak': 3,
    });

    final migrated = await repository.load();
    expect(
      migrated,
      const PlayerStats(
        matchesPlayed: 5,
        matchesWon: 2,
        matchesLost: 3,
        roundsWon: 8,
        roundsDrawn: 1,
        roundsLost: 9,
        bestStreak: 3,
      ),
    );

    await repository.save(migrated);
    final prefs = await SharedPreferences.getInstance();
    expect(
      prefs.getKeys(),
      {PreferencesStatsRepository.storageKey},
    );
  });

  test('ignores corrupt or unknown documents', () async {
    for (final raw in ['not json', '{"version": 99}', '[1, 2]']) {
      final repository = await build({
        PreferencesStatsRepository.storageKey: raw,
      });

      expect(await repository.load(), const PlayerStats(), reason: raw);
    }
  });

  test('clear forgets new and legacy stats', () async {
    final repository = await build({'stats.roundsWon': 4});
    await repository.save(stats);

    await repository.clear();

    expect(await repository.load(), const PlayerStats());
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getKeys(), isEmpty);
  });
}
