import 'package:equatable/equatable.dart';
import 'package:rock_paper_scissors/features/achievements/domain/entities/achievement.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/move.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/round.dart';
import 'package:rock_paper_scissors/features/game/presentation/bloc/game_phase.dart';

final class GameState extends Equatable {
  const GameState({
    required this.match,
    required this.phase,
    this.pendingRound,
    this.selectedMove,
    this.firstMove,
    this.achievements = const [],
  });

  factory GameState.initial(Match match) {
    return GameState(match: match, phase: GamePhase.picking);
  }

  final Match match;
  final GamePhase phase;
  final Round? pendingRound;
  final Move? selectedMove;

  /// Player 1's hidden pick while Player 2 is choosing (pass-and-play).
  final Move? firstMove;

  /// Badges earned during this match, oldest first.
  final List<Achievement> achievements;

  bool get canPick => phase == GamePhase.picking && !match.isOver;

  GameState copyWith({
    Match? match,
    GamePhase? phase,
    Round? pendingRound,
    Move? selectedMove,
    Move? firstMove,
    List<Achievement>? achievements,
    bool clearPending = false,
    bool clearSelected = false,
    bool clearFirst = false,
  }) {
    return GameState(
      match: match ?? this.match,
      phase: phase ?? this.phase,
      pendingRound: clearPending ? null : (pendingRound ?? this.pendingRound),
      selectedMove: clearSelected ? null : (selectedMove ?? this.selectedMove),
      firstMove: clearFirst ? null : (firstMove ?? this.firstMove),
      achievements: achievements ?? this.achievements,
    );
  }

  @override
  List<Object?> get props =>
      [match, phase, pendingRound, selectedMove, firstMove, achievements];
}
