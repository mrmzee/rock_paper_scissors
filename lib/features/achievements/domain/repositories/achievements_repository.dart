import 'package:rock_paper_scissors/features/achievements/domain/entities/achievement.dart';

/// Remembers which badges were earned.
abstract interface class AchievementsRepository {
  Future<Set<Achievement>> load();

  Future<void> save(Set<Achievement> unlocked);

  Future<void> clear();
}
