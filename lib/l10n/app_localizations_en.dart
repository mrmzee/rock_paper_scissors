// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Rock Paper Scissors';

  @override
  String get homeGreeting => 'Ready to play?';

  @override
  String get play => 'Play!';

  @override
  String get gameType => 'Game type';

  @override
  String get modeBestOf5 => '3 stars';

  @override
  String get modeBestOf5Hint => 'First to 3 wins';

  @override
  String get modeEndless => 'Endless';

  @override
  String get modeEndlessHint => 'Play as long as you like';

  @override
  String get chooseRobot => 'Pick your robot';

  @override
  String get robotEasy => 'Robo Jr.';

  @override
  String get robotNormal => 'Robo';

  @override
  String get robotHard => 'Grumpy Robo';

  @override
  String get robotEasyHint => 'Plays for fun';

  @override
  String get robotNormalHint => 'A fair fight';

  @override
  String get robotHardHint => 'Learns your tricks';

  @override
  String get myTrophies => 'My trophies';

  @override
  String get switchLanguage => 'فارسی';

  @override
  String get switchLanguageTooltip => 'Change language';

  @override
  String get soundOn => 'Sound on';

  @override
  String get soundOff => 'Sound off';

  @override
  String get back => 'Back';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Keep playing';

  @override
  String get restart => 'Start over';

  @override
  String get home => 'Home';

  @override
  String get you => 'You';

  @override
  String get rock => 'Rock';

  @override
  String get paper => 'Paper';

  @override
  String get scissors => 'Scissors';

  @override
  String get pickPrompt => 'Pick your hand!';

  @override
  String get youWin => 'You win!';

  @override
  String robotWins(String robot) {
    return '$robot wins!';
  }

  @override
  String get draw => 'Draw!';

  @override
  String get tapToContinue => 'Tap to continue';

  @override
  String streak(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString in a row!';
  }

  @override
  String scoreSemantics(int wins, String robot, int losses) {
    final intl.NumberFormat winsNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String winsString = winsNumberFormat.format(wins);
    final intl.NumberFormat lossesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String lossesString = lossesNumberFormat.format(losses);

    return 'You $winsString, $robot $lossesString';
  }

  @override
  String handSemantics(String player, String move) {
    return '$player: $move';
  }

  @override
  String get hiddenHand => 'hidden';

  @override
  String get matchWinTitle => 'You\'re the champion!';

  @override
  String get matchWinSubtitle => 'Amazing playing!';

  @override
  String matchLoseTitle(String robot) {
    return '$robot won this time';
  }

  @override
  String get matchLoseSubtitle => 'Try again, you can do it!';

  @override
  String get playAgain => 'Play again';

  @override
  String get niceRun => 'Nice playing!';

  @override
  String get winRate => 'Win rate';

  @override
  String roundsSummary(int won, int played) {
    final intl.NumberFormat wonNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String wonString = wonNumberFormat.format(won);
    final intl.NumberFormat playedNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String playedString = playedNumberFormat.format(played);

    return '$wonString of $playedString rounds';
  }

  @override
  String roundsBreakdown(int won, int drawn, int lost) {
    final intl.NumberFormat wonNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String wonString = wonNumberFormat.format(won);
    final intl.NumberFormat drawnNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String drawnString = drawnNumberFormat.format(drawn);
    final intl.NumberFormat lostNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String lostString = lostNumberFormat.format(lost);

    return '$wonString wins, $drawnString draws, $lostString losses';
  }

  @override
  String get matches => 'Matches';

  @override
  String get rounds => 'Rounds';

  @override
  String get bestStreak => 'Best streak';

  @override
  String get noStatsYet => 'Play a game to win trophies!';

  @override
  String get tryAgain => 'Try again';

  @override
  String get loading => 'Loading';
}
