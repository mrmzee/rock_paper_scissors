import 'package:equatable/equatable.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match_mode.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/round.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/round_outcome.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/scoreboard.dart';

/// A full contest made of rounds under a mode and difficulty.
final class Match extends Equatable {
  const Match({
    required this.mode,
    required this.difficulty,
    this.scoreboard = const Scoreboard(),
    this.history = const [],
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.isOver = false,
    this.playerWon,
  });

  factory Match.start({
    required MatchMode mode,
    required Difficulty difficulty,
  }) {
    return Match(mode: mode, difficulty: difficulty);
  }

  final MatchMode mode;
  final Difficulty difficulty;
  final Scoreboard scoreboard;
  final List<Round> history;
  final int currentStreak;
  final int bestStreak;
  final bool isOver;

  /// `true` if the player won a finished match, `false` if lost, null if open.
  final bool? playerWon;

  Round? get lastRound => history.isEmpty ? null : history.last;

  Match withRound(Round round) {
    final nextScore = scoreboard.record(round.outcome);
    final nextStreak = switch (round.outcome) {
      RoundOutcome.win => currentStreak + 1,
      RoundOutcome.draw => currentStreak,
      RoundOutcome.loss => 0,
    };
    final nextBest = nextStreak > bestStreak ? nextStreak : bestStreak;
    final nextHistory = [...history, round];

    final winsNeeded = mode.winsNeeded;
    if (winsNeeded != null) {
      if (nextScore.wins >= winsNeeded) {
        return Match(
          mode: mode,
          difficulty: difficulty,
          scoreboard: nextScore,
          history: nextHistory,
          currentStreak: nextStreak,
          bestStreak: nextBest,
          isOver: true,
          playerWon: true,
        );
      }
      if (nextScore.losses >= winsNeeded) {
        return Match(
          mode: mode,
          difficulty: difficulty,
          scoreboard: nextScore,
          history: nextHistory,
          currentStreak: nextStreak,
          bestStreak: nextBest,
          isOver: true,
          playerWon: false,
        );
      }
    }

    return Match(
      mode: mode,
      difficulty: difficulty,
      scoreboard: nextScore,
      history: nextHistory,
      currentStreak: nextStreak,
      bestStreak: nextBest,
    );
  }

  @override
  List<Object?> get props => [
        mode,
        difficulty,
        scoreboard,
        history,
        currentStreak,
        bestStreak,
        isOver,
        playerWon,
      ];
}
