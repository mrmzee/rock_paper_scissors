import 'package:flutter_test/flutter_test.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match_mode.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/move.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/opponent.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/round_outcome.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/round_rules.dart';
import 'package:rock_paper_scissors/features/game/domain/usecases/play_round.dart';

import '../../../../helpers/sequence_opponent_strategy.dart';

void main() {
  group('RoundRules', () {
    test('matching hands draw', () {
      for (final move in Move.values) {
        expect(
          RoundRules.decide(playerMove: move, opponentMove: move),
          RoundOutcome.draw,
        );
      }
    });

    test('paper beats rock, scissors beat paper, rock beats scissors', () {
      expect(
        RoundRules.decide(playerMove: Move.paper, opponentMove: Move.rock),
        RoundOutcome.win,
      );
      expect(
        RoundRules.decide(
          playerMove: Move.scissors,
          opponentMove: Move.paper,
        ),
        RoundOutcome.win,
      );
      expect(
        RoundRules.decide(
          playerMove: Move.rock,
          opponentMove: Move.scissors,
        ),
        RoundOutcome.win,
      );
    });

    test('the opposite matchups lose', () {
      expect(
        RoundRules.decide(playerMove: Move.rock, opponentMove: Move.paper),
        RoundOutcome.loss,
      );
      expect(
        RoundRules.decide(
          playerMove: Move.paper,
          opponentMove: Move.scissors,
        ),
        RoundOutcome.loss,
      );
      expect(
        RoundRules.decide(
          playerMove: Move.scissors,
          opponentMove: Move.rock,
        ),
        RoundOutcome.loss,
      );
    });
  });

  group('PlayRound', () {
    test('applies the player move against a scripted opponent', () {
      final playRound = PlayRound(
        SequenceOpponentStrategy([Move.rock, Move.scissors]),
      );
      final match = Match.start(
        mode: MatchMode.endless,
        difficulty: Difficulty.easy,
      );

      final afterWin = playRound(match: match, playerMove: Move.paper);
      expect(afterWin.lastRound!.opponentMove, Move.rock);
      expect(afterWin.lastRound!.playerMove, Move.paper);
      expect(afterWin.scoreboard.wins, 1);
      expect(afterWin.currentStreak, 1);

      final afterDraw = playRound(
        match: afterWin,
        playerMove: Move.scissors,
      );
      expect(afterDraw.lastRound!.opponentMove, Move.scissors);
      expect(afterDraw.scoreboard.wins, 1);
      expect(afterDraw.scoreboard.draws, 1);
      expect(afterDraw.currentStreak, 1);
    });

    test('uses a given opponent move instead of the strategy', () {
      final playRound = PlayRound(SequenceOpponentStrategy([Move.rock]));
      final match = Match.start(
        mode: MatchMode.bestOf5,
        difficulty: Difficulty.easy,
        opponent: Opponent.friend,
      );

      final next = playRound(
        match: match,
        playerMove: Move.paper,
        opponentMove: Move.scissors,
      );

      expect(next.lastRound!.opponentMove, Move.scissors);
      expect(next.scoreboard.losses, 1);
      expect(next.opponent, Opponent.friend);
    });
  });

  group('Match', () {
    test('best of 5 ends when a side reaches three wins', () {
      final playRound = PlayRound(
        SequenceOpponentStrategy([
          Move.rock,
          Move.rock,
          Move.rock,
        ]),
      );
      var match = Match.start(
        mode: MatchMode.bestOf5,
        difficulty: Difficulty.easy,
      );

      match = playRound(match: match, playerMove: Move.paper);
      match = playRound(match: match, playerMove: Move.paper);
      expect(match.isOver, isFalse);

      match = playRound(match: match, playerMove: Move.paper);
      expect(match.isOver, isTrue);
      expect(match.playerWon, isTrue);
      expect(match.scoreboard.wins, 3);
    });
  });
}
