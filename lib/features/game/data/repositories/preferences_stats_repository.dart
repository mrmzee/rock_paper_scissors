import 'dart:convert';

import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/move.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/player_stats.dart';
import 'package:rock_paper_scissors/features/game/domain/repositories/stats_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Stores stats as one versioned JSON document under [storageKey].
///
/// Totals written by app versions before 3.1 (one int per key) are read once
/// and replaced by the JSON document on the next save.
final class PreferencesStatsRepository implements StatsRepository {
  PreferencesStatsRepository(this._prefs);

  final SharedPreferences _prefs;

  static const storageKey = 'stats.v2';
  static const _version = 2;

  static const _legacyFields = [
    'matchesPlayed',
    'matchesWon',
    'matchesLost',
    'roundsWon',
    'roundsDrawn',
    'roundsLost',
    'bestStreak',
  ];

  static Iterable<String> get _legacyKeys =>
      _legacyFields.map((field) => 'stats.$field');

  @override
  Future<PlayerStats> load() async {
    final raw = _prefs.getString(storageKey);
    if (raw == null) return _loadLegacy();
    try {
      final json = jsonDecode(raw);
      if (json is Map<String, Object?> && json['version'] == _version) {
        return _fromJson(json);
      }
    } on FormatException {
      // Fall through to empty stats rather than crashing on corrupt data.
    }
    return const PlayerStats();
  }

  @override
  Future<void> save(PlayerStats stats) async {
    await _prefs.setString(storageKey, jsonEncode(_toJson(stats)));
    await Future.wait(_legacyKeys.map(_prefs.remove));
  }

  @override
  Future<void> clear() async {
    await Future.wait([storageKey, ..._legacyKeys].map(_prefs.remove));
  }

  PlayerStats _loadLegacy() {
    int read(String field) => _prefs.getInt('stats.$field') ?? 0;
    return PlayerStats(
      matchesPlayed: read('matchesPlayed'),
      matchesWon: read('matchesWon'),
      matchesLost: read('matchesLost'),
      roundsWon: read('roundsWon'),
      roundsDrawn: read('roundsDrawn'),
      roundsLost: read('roundsLost'),
      bestStreak: read('bestStreak'),
    );
  }

  static Map<String, Object?> _toJson(PlayerStats stats) => {
        'version': _version,
        'matchesPlayed': stats.matchesPlayed,
        'matchesWon': stats.matchesWon,
        'matchesLost': stats.matchesLost,
        'roundsWon': stats.roundsWon,
        'roundsDrawn': stats.roundsDrawn,
        'roundsLost': stats.roundsLost,
        'bestStreak': stats.bestStreak,
        'currentStreak': stats.currentStreak,
        'movesPlayed': _enumMapToJson(stats.movesPlayed),
        'roundsPlayedBy': _enumMapToJson(stats.roundsPlayedBy),
        'roundsWonBy': _enumMapToJson(stats.roundsWonBy),
      };

  static PlayerStats _fromJson(Map<String, Object?> json) {
    int read(String key) => switch (json[key]) {
          final int value => value,
          _ => 0,
        };
    return PlayerStats(
      matchesPlayed: read('matchesPlayed'),
      matchesWon: read('matchesWon'),
      matchesLost: read('matchesLost'),
      roundsWon: read('roundsWon'),
      roundsDrawn: read('roundsDrawn'),
      roundsLost: read('roundsLost'),
      bestStreak: read('bestStreak'),
      currentStreak: read('currentStreak'),
      movesPlayed: _enumMapFromJson(Move.values, json['movesPlayed']),
      roundsPlayedBy:
          _enumMapFromJson(Difficulty.values, json['roundsPlayedBy']),
      roundsWonBy: _enumMapFromJson(Difficulty.values, json['roundsWonBy']),
    );
  }

  static Map<String, int> _enumMapToJson<T extends Enum>(Map<T, int> map) =>
      {for (final MapEntry(:key, :value) in map.entries) key.name: value};

  static Map<T, int> _enumMapFromJson<T extends Enum>(
    List<T> values,
    Object? json,
  ) {
    if (json is! Map<String, Object?>) return const {};
    return {
      for (final value in values)
        if (json[value.name] case final int count) value: count,
    };
  }
}
