import 'package:flutter_test/flutter_test.dart';
import 'package:rock_paper_scissors/features/achievements/data/repositories/in_memory_achievements_repository.dart';
import 'package:rock_paper_scissors/features/achievements/domain/entities/achievement.dart';
import 'package:rock_paper_scissors/features/achievements/domain/usecases/unlock_achievements.dart';
import 'package:rock_paper_scissors/features/game/data/repositories/in_memory_stats_repository.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match_mode.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/move.dart';
import 'package:rock_paper_scissors/features/game/domain/usecases/play_round.dart';
import 'package:rock_paper_scissors/features/game/domain/usecases/record_match_stats.dart';
import 'package:rock_paper_scissors/features/game/presentation/bloc/game_bloc.dart';
import 'package:rock_paper_scissors/features/game/presentation/bloc/game_event.dart';
import 'package:rock_paper_scissors/features/game/presentation/bloc/game_phase.dart';

import '../../../helpers/sequence_opponent_strategy.dart';

GameBloc _bloc(
  List<Move> robotMoves, {
  MatchMode mode = MatchMode.endless,
  InMemoryStatsRepository? stats,
  InMemoryAchievementsRepository? achievements,
}) {
  return GameBloc(
    playRound: PlayRound(SequenceOpponentStrategy(robotMoves)),
    recordMatchStats: RecordMatchStats(stats ?? InMemoryStatsRepository()),
    unlockAchievements: UnlockAchievements(
      achievements ?? InMemoryAchievementsRepository(),
    ),
    initialMatch: Match.start(mode: mode, difficulty: Difficulty.easy),
    revealDelay: const Duration(milliseconds: 20),
    resultDelay: const Duration(milliseconds: 40),
  );
}

Future<void> _wait(int ms) => Future<void>.delayed(Duration(milliseconds: ms));

void main() {
  test('reset during the reveal discards the pending round', () async {
    final bloc = _bloc([Move.rock]);

    bloc.add(const GameMoveSelected(Move.paper));
    await _wait(5);
    expect(bloc.state.phase, GamePhase.revealing);

    bloc.add(const GameResetRequested());
    await _wait(60);

    expect(bloc.state.phase, GamePhase.picking);
    expect(bloc.state.match.history, isEmpty);
    await bloc.close();
  });

  test('a skipped result does not interrupt the next round', () async {
    final bloc = _bloc([Move.rock, Move.rock]);

    bloc.add(const GameMoveSelected(Move.paper));
    await _wait(30);
    expect(bloc.state.phase, GamePhase.roundResult);

    bloc.add(const GameRoundAcknowledged());
    await _wait(1);
    bloc.add(const GameMoveSelected(Move.scissors));
    await _wait(30);

    expect(bloc.state.phase, GamePhase.roundResult);
    expect(bloc.state.pendingRound?.playerMove, Move.scissors);

    await _wait(5);
    expect(bloc.state.phase, GamePhase.roundResult);
    await bloc.close();
  });

  test('badges unlock mid-match in Endless and are saved once', () async {
    final achievements = InMemoryAchievementsRepository();
    final bloc = _bloc(
      [Move.scissors, Move.scissors, Move.scissors],
      achievements: achievements,
    );

    for (var round = 0; round < 3; round++) {
      bloc.add(const GameMoveSelected(Move.rock));
      await _wait(30);
      bloc.add(const GameRoundAcknowledged());
      await _wait(1);
    }

    expect(bloc.state.achievements, [Achievement.streak3]);
    expect(await achievements.load(), {Achievement.streak3});
    await bloc.close();
  });

  test('a won 3-star match earns its badges and records stats once', () async {
    final stats = InMemoryStatsRepository();
    final achievements = InMemoryAchievementsRepository();
    final bloc = _bloc(
      [Move.scissors, Move.rock, Move.paper],
      mode: MatchMode.bestOf5,
      stats: stats,
      achievements: achievements,
    );

    for (final move in [Move.rock, Move.paper, Move.scissors]) {
      bloc.add(GameMoveSelected(move));
      await _wait(30);
      bloc.add(const GameRoundAcknowledged());
      await _wait(1);
    }

    expect(bloc.state.phase, GamePhase.matchOver);
    expect(bloc.state.achievements, [
      Achievement.firstWin,
      Achievement.streak3,
      Achievement.perfectMatch,
      Achievement.allMoves,
    ]);
    expect((await stats.load()).matchesPlayed, 1);

    bloc.add(const GameExited());
    await _wait(5);
    expect((await stats.load()).matchesPlayed, 1);
    await bloc.close();
  });
}
