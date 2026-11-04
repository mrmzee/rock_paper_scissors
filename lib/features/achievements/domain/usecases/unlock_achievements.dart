import 'package:rock_paper_scissors/features/achievements/domain/entities/achievement.dart';
import 'package:rock_paper_scissors/features/achievements/domain/repositories/achievements_repository.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/player_stats.dart';

/// Saves badges newly earned by [Match] and returns them in display order.
final class UnlockAchievements {
  const UnlockAchievements(this._repository);

  final AchievementsRepository _repository;

  Future<List<Achievement>> call(Match match, PlayerStats stats) async {
    final unlocked = await _repository.load();
    final earned = [
      for (final achievement in Achievement.values)
        if (!unlocked.contains(achievement) &&
            achievement.isEarned(match, stats))
          achievement,
    ];
    if (earned.isNotEmpty) {
      await _repository.save({...unlocked, ...earned});
    }
    return earned;
  }
}
