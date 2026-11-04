import 'package:rock_paper_scissors/features/achievements/domain/entities/achievement.dart';
import 'package:rock_paper_scissors/features/achievements/domain/repositories/achievements_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Stores badge names as a string list; unknown names are ignored.
final class PreferencesAchievementsRepository
    implements AchievementsRepository {
  PreferencesAchievementsRepository(this._prefs);

  final SharedPreferences _prefs;

  static const storageKey = 'achievements.unlocked';

  @override
  Future<Set<Achievement>> load() async {
    final names = _prefs.getStringList(storageKey) ?? const [];
    return {
      for (final achievement in Achievement.values)
        if (names.contains(achievement.name)) achievement,
    };
  }

  @override
  Future<void> save(Set<Achievement> unlocked) async {
    await _prefs.setStringList(
      storageKey,
      [for (final achievement in unlocked) achievement.name],
    );
  }

  @override
  Future<void> clear() async {
    await _prefs.remove(storageKey);
  }
}
