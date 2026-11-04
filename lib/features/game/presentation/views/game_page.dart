import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match_mode.dart';
import 'package:rock_paper_scissors/features/game/domain/usecases/play_round.dart';
import 'package:rock_paper_scissors/features/game/domain/usecases/record_match_stats.dart';
import 'package:rock_paper_scissors/features/game/presentation/bloc/game_bloc.dart';
import 'package:rock_paper_scissors/features/game/presentation/views/game_view.dart';

/// Creates the game bloc and shows [GameView].
class GamePage extends StatelessWidget {
  const GamePage({
    super.key,
    required this.mode,
    required this.difficulty,
    required this.playRound,
    required this.recordMatchStats,
    this.revealDelay = GameBloc.defaultRevealDelay,
    this.resultDelay = GameBloc.defaultResultDelay,
  });

  final MatchMode mode;
  final Difficulty difficulty;
  final PlayRound playRound;
  final RecordMatchStats recordMatchStats;
  final Duration revealDelay;
  final Duration resultDelay;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GameBloc(
        playRound: playRound,
        recordMatchStats: recordMatchStats,
        initialMatch: Match.start(mode: mode, difficulty: difficulty),
        revealDelay: revealDelay,
        resultDelay: resultDelay,
      ),
      child: const GameView(),
    );
  }
}
