import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match_mode.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/opponent.dart';
import 'package:rock_paper_scissors/features/game/presentation/bloc/game_bloc.dart';
import 'package:rock_paper_scissors/features/game/presentation/views/game_view.dart';

/// Creates the game bloc and shows [GameView].
class GamePage extends StatelessWidget {
  const GamePage({
    super.key,
    required this.mode,
    required this.difficulty,
    this.opponent = Opponent.robot,
    this.revealDelay = GameBloc.defaultRevealDelay,
    this.resultDelay = GameBloc.defaultResultDelay,
  });

  final MatchMode mode;
  final Difficulty difficulty;
  final Opponent opponent;
  final Duration revealDelay;
  final Duration resultDelay;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameBloc(
        playRound: context.read(),
        recordMatchStats: context.read(),
        unlockAchievements: context.read(),
        initialMatch: Match.start(
          mode: mode,
          difficulty: difficulty,
          opponent: opponent,
        ),
        revealDelay: revealDelay,
        resultDelay: resultDelay,
      ),
      child: const GameView(),
    );
  }
}
