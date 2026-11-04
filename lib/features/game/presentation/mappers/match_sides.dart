import 'package:flutter/widgets.dart';
import 'package:rock_paper_scissors/core/l10n/l10n.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/opponent.dart';
import 'package:rock_paper_scissors/features/game/presentation/mappers/robot_look.dart';

/// Display names for both sides of a match: "You" vs a robot, or
/// "Player 1" vs "Player 2" in pass-and-play.
extension MatchSides on Match {
  bool get isPassAndPlay => opponent == Opponent.friend;

  String playerName(BuildContext context) =>
      isPassAndPlay ? context.l10n.player1 : context.l10n.you;

  String opponentName(BuildContext context) =>
      isPassAndPlay ? context.l10n.player2 : difficulty.robotName(context);

  String scoreSemantics(BuildContext context) {
    final l10n = context.l10n;
    return isPassAndPlay
        ? l10n.versusScoreSemantics(
            l10n.player1,
            scoreboard.wins,
            l10n.player2,
            scoreboard.losses,
          )
        : l10n.scoreSemantics(
            scoreboard.wins,
            difficulty.robotName(context),
            scoreboard.losses,
          );
  }
}
