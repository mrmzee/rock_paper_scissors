import 'package:equatable/equatable.dart';

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
  });

  final int matchesPlayed;
  final int matchesWon;
  final int matchesLost;
  final int roundsWon;
  final int roundsDrawn;
  final int roundsLost;
  final int bestStreak;

  int get roundsPlayed => roundsWon + roundsDrawn + roundsLost;

  double get winRate {
    if (roundsPlayed == 0) return 0;
    return roundsWon / roundsPlayed;
  }

  PlayerStats copyWith({
    int? matchesPlayed,
    int? matchesWon,
    int? matchesLost,
    int? roundsWon,
    int? roundsDrawn,
    int? roundsLost,
    int? bestStreak,
  }) {
    return PlayerStats(
      matchesPlayed: matchesPlayed ?? this.matchesPlayed,
      matchesWon: matchesWon ?? this.matchesWon,
      matchesLost: matchesLost ?? this.matchesLost,
      roundsWon: roundsWon ?? this.roundsWon,
      roundsDrawn: roundsDrawn ?? this.roundsDrawn,
      roundsLost: roundsLost ?? this.roundsLost,
      bestStreak: bestStreak ?? this.bestStreak,
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
      ];
}
