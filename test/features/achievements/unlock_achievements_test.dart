import 'package:flutter_test/flutter_test.dart';
import 'package:rock_paper_scissors/features/achievements/data/repositories/in_memory_achievements_repository.dart';
import 'package:rock_paper_scissors/features/achievements/data/repositories/preferences_achievements_repository.dart';
import 'package:rock_paper_scissors/features/achievements/domain/entities/achievement.dart';
import 'package:rock_paper_scissors/features/achievements/domain/usecases/unlock_achievements.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match_mode.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/move.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/player_stats.dart';
import 'package:rock_paper_scissors/features/game/domain/usecases/play_round.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/sequence_opponent_strategy.dart';

Match _play({
  required List<Move> robot,
  required List<Move> player,
  MatchMode mode = MatchMode.bestOf5,
  Difficulty difficulty = Difficulty.normal,
}) {
  final playRound = PlayRound(SequenceOpponentStrategy(robot));
  var match = Match.start(mode: mode, difficulty: difficulty);
  for (final move in player) {
    match = playRound(match: match, playerMove: move);
  }
  return match;
}

Set<Achievement> _earned(
  Match match, [
  PlayerStats before = const PlayerStats(),
]) {
  final stats = before.including(match);
  return {
    for (final achievement in Achievement.values)
      if (achievement.isEarned(match, stats)) achievement,
  };
}

void main() {
  group('Achievement.isEarned', () {
    test('a clean 3-0 win against Grumpy earns the match badges', () {
      final match = _play(
        difficulty: Difficulty.hard,
        robot: [Move.scissors, Move.scissors, Move.scissors],
        player: [Move.rock, Move.rock, Move.rock],
      );

      expect(_earned(match), {
        Achievement.firstWin,
        Achievement.streak3,
        Achievement.perfectMatch,
        Achievement.beatGrumpy,
      });
    });

    test('a win after a lost round is not perfect', () {
      final match = _play(
        robot: [Move.paper, Move.scissors, Move.scissors, Move.scissors],
        player: [Move.rock, Move.rock, Move.rock, Move.rock],
      );

      expect(_earned(match), contains(Achievement.firstWin));
      expect(_earned(match), isNot(contains(Achievement.perfectMatch)));
    });

    test('winning with every hand earns allMoves, even in Endless', () {
      final match = _play(
        mode: MatchMode.endless,
        robot: [Move.scissors, Move.rock, Move.paper],
        player: [Move.rock, Move.paper, Move.scissors],
      );

      expect(_earned(match), contains(Achievement.allMoves));
      expect(_earned(match), isNot(contains(Achievement.firstWin)));
    });

    test('lifetime totals unlock streak and match count badges', () {
      final match = _play(
        mode: MatchMode.endless,
        robot: [Move.scissors],
        player: [Move.rock],
      );

      expect(
        _earned(match, const PlayerStats(matchesPlayed: 49, currentStreak: 4)),
        containsAll([
          Achievement.streak5,
          Achievement.matches10,
          Achievement.matches50,
        ]),
      );
    });
  });

  test('UnlockAchievements returns only new badges and saves them', () async {
    final repository = InMemoryAchievementsRepository({Achievement.firstWin});
    final unlock = UnlockAchievements(repository);
    final match = _play(
      robot: [Move.scissors, Move.scissors, Move.scissors],
      player: [Move.rock, Move.rock, Move.rock],
    );

    final earned = await unlock(match, const PlayerStats().including(match));

    expect(earned, [Achievement.streak3, Achievement.perfectMatch]);
    expect(await repository.load(), {
      Achievement.firstWin,
      Achievement.streak3,
      Achievement.perfectMatch,
    });
    expect(await unlock(match, const PlayerStats().including(match)), isEmpty);
  });

  test('PreferencesAchievementsRepository round-trips and clears', () async {
    SharedPreferences.setMockInitialValues({
      PreferencesAchievementsRepository.storageKey: ['firstWin', 'retired'],
    });
    final repository = PreferencesAchievementsRepository(
      await SharedPreferences.getInstance(),
    );

    expect(await repository.load(), {Achievement.firstWin});

    await repository.save({Achievement.firstWin, Achievement.matches10});
    expect(
      await repository.load(),
      {Achievement.firstWin, Achievement.matches10},
    );

    await repository.clear();
    expect(await repository.load(), isEmpty);
  });
}
