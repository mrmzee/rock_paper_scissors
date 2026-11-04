import 'package:equatable/equatable.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/round_outcome.dart';

/// Running totals for the current match.
final class Scoreboard extends Equatable {
  const Scoreboard({this.wins = 0, this.draws = 0, this.losses = 0});

  final int wins;
  final int draws;
  final int losses;

  int get roundsPlayed => wins + draws + losses;

  Scoreboard record(RoundOutcome outcome) {
    return switch (outcome) {
      RoundOutcome.win => Scoreboard(
          wins: wins + 1,
          draws: draws,
          losses: losses,
        ),
      RoundOutcome.draw => Scoreboard(
          wins: wins,
          draws: draws + 1,
          losses: losses,
        ),
      RoundOutcome.loss => Scoreboard(
          wins: wins,
          draws: draws,
          losses: losses + 1,
        ),
    };
  }

  @override
  List<Object?> get props => [wins, draws, losses];
}
