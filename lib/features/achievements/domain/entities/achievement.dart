import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match_mode.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/move.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/player_stats.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/round_outcome.dart';

/// Badges the player can earn, in display order.
enum Achievement {
  firstWin,
  streak3,
  streak5,
  perfectMatch,
  beatGrumpy,
  allMoves,
  matches10,
  matches50;

  /// Whether [match] (in progress or finished) earns this badge, given the
  /// lifetime [stats] that already include it.
  bool isEarned(Match match, PlayerStats stats) {
    final won = match.playerWon ?? false;
    return switch (this) {
      firstWin => won,
      streak3 => stats.bestStreak >= 3,
      streak5 => stats.bestStreak >= 5,
      perfectMatch =>
        won && match.mode == MatchMode.bestOf5 && match.scoreboard.losses == 0,
      beatGrumpy => won && match.difficulty == Difficulty.hard,
      allMoves => {
            for (final round in match.history)
              if (round.outcome == RoundOutcome.win) round.playerMove,
          }.length ==
          Move.values.length,
      matches10 => stats.matchesPlayed >= 10,
      matches50 => stats.matchesPlayed >= 50,
    };
  }
}
