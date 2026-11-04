import 'package:rock_paper_scissors/features/achievements/domain/entities/achievement.dart';
import 'package:rock_paper_scissors/features/achievements/domain/repositories/achievements_repository.dart';

/// Test-friendly badge store.
final class InMemoryAchievementsRepository implements AchievementsRepository {
  InMemoryAchievementsRepository([Set<Achievement> unlocked = const {}])
      : _unlocked = {...unlocked};

  Set<Achievement> _unlocked;

  @override
  Future<Set<Achievement>> load() async => {..._unlocked};

  @override
  Future<void> save(Set<Achievement> unlocked) async {
    _unlocked = {...unlocked};
  }

  @override
  Future<void> clear() async {
    _unlocked = {};
  }
}
