import 'package:equatable/equatable.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/move.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/round_outcome.dart';

/// Lifetime totals persisted across sessions.
final class PlayerStats extends Equatable {
  const PlayerStats({
    this.matchesPlayed = 0,
    this.matchesWon = 0,
    this.matchesLost = 0,
    this.roundsWon = 0,
    this.roundsDrawn = 0,
    this.roundsLost = 0,
    this.bestStreak = 0,
    this.currentStreak = 0,
    this.movesPlayed = const {},
    this.roundsPlayedBy = const {},
    this.roundsWonBy = const {},
  });

  final int matchesPlayed;
  final int matchesWon;
  final int matchesLost;
  final int roundsWon;
  final int roundsDrawn;
  final int roundsLost;

  /// Longest run of round wins ever (draws keep a run alive).
  final int bestStreak;

  /// Round wins in a row up to the last round played.
  final int currentStreak;

  /// How often the player threw each hand.
  final Map<Move, int> movesPlayed;

  /// Rounds played and won against each robot.
  final Map<Difficulty, int> roundsPlayedBy;
  final Map<Difficulty, int> roundsWonBy;

  int get roundsPlayed => roundsWon + roundsDrawn + roundsLost;

  bool get isEmpty => roundsPlayed == 0 && matchesPlayed == 0;

  double get winRate {
    if (roundsPlayed == 0) return 0;
    return roundsWon / roundsPlayed;
  }

  /// The most thrown hand, or null before the first round.
  Move? get favoriteMove {
    Move? favorite;
    var most = 0;
    for (final move in Move.values) {
      final count = movesPlayed[move] ?? 0;
      if (count > most) {
        favorite = move;
        most = count;
      }
    }
    return favorite;
  }

  /// Share of rounds won against [difficulty], or null if never played.
  double? winRateAgainst(Difficulty difficulty) {
    final played = roundsPlayedBy[difficulty] ?? 0;
    if (played == 0) return null;
    return (roundsWonBy[difficulty] ?? 0) / played;
  }

  /// These totals with [match] added; an empty match changes nothing.
  PlayerStats including(Match match) {
    if (match.history.isEmpty) return this;

    final score = match.scoreboard;
    final moves = {...movesPlayed};
    var streak = currentStreak;
    var best = bestStreak;
    for (final round in match.history) {
      moves[round.playerMove] = (moves[round.playerMove] ?? 0) + 1;
      streak = switch (round.outcome) {
        RoundOutcome.win => streak + 1,
        RoundOutcome.draw => streak,
        RoundOutcome.loss => 0,
      };
      if (streak > best) best = streak;
    }

    final robot = match.difficulty;
    return copyWith(
      matchesPlayed: matchesPlayed + 1,
      matchesWon: matchesWon + (match.playerWon == true ? 1 : 0),
      matchesLost: matchesLost + (match.playerWon == false ? 1 : 0),
      roundsWon: roundsWon + score.wins,
      roundsDrawn: roundsDrawn + score.draws,
      roundsLost: roundsLost + score.losses,
      bestStreak: best,
      currentStreak: streak,
      movesPlayed: moves,
      roundsPlayedBy: {
        ...roundsPlayedBy,
        robot: (roundsPlayedBy[robot] ?? 0) + score.roundsPlayed,
      },
      roundsWonBy: {
        ...roundsWonBy,
        robot: (roundsWonBy[robot] ?? 0) + score.wins,
      },
    );
  }

  PlayerStats copyWith({
    int? matchesPlayed,
    int? matchesWon,
    int? matchesLost,
    int? roundsWon,
    int? roundsDrawn,
    int? roundsLost,
    int? bestStreak,
    int? currentStreak,
    Map<Move, int>? movesPlayed,
    Map<Difficulty, int>? roundsPlayedBy,
    Map<Difficulty, int>? roundsWonBy,
  }) {
    return PlayerStats(
      matchesPlayed: matchesPlayed ?? this.matchesPlayed,
      matchesWon: matchesWon ?? this.matchesWon,
      matchesLost: matchesLost ?? this.matchesLost,
      roundsWon: roundsWon ?? this.roundsWon,
      roundsDrawn: roundsDrawn ?? this.roundsDrawn,
      roundsLost: roundsLost ?? this.roundsLost,
      bestStreak: bestStreak ?? this.bestStreak,
      currentStreak: currentStreak ?? this.currentStreak,
      movesPlayed: movesPlayed ?? this.movesPlayed,
      roundsPlayedBy: roundsPlayedBy ?? this.roundsPlayedBy,
      roundsWonBy: roundsWonBy ?? this.roundsWonBy,
    );
  }

  @override
  List<Object?> get props => [
        matchesPlayed,
        matchesWon,
        matchesLost,
        roundsWon,
        roundsDrawn,
        roundsLost,
        bestStreak,
        currentStreak,
        movesPlayed,
        roundsPlayedBy,
        roundsWonBy,
      ];
}
