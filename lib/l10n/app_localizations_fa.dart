// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'سنگ کاغذ قیچی';

  @override
  String get homeGreeting => 'آماده‌ای بازی کنیم؟';

  @override
  String get play => 'بزن بریم!';

  @override
  String get gameType => 'نوع بازی';

  @override
  String get modeBestOf5 => 'سه ستاره';

  @override
  String get modeBestOf5Hint => 'هر کی زودتر ۳ بار ببره';

  @override
  String get modeEndless => 'بی‌پایان';

  @override
  String get modeEndlessHint => 'تا هر وقت دوست داری';

  @override
  String get chooseRobot => 'ربات حریفت رو انتخاب کن';

  @override
  String get robotEasy => 'ربو کوچولو';

  @override
  String get robotNormal => 'ربو';

  @override
  String get robotHard => 'ربو اخمو';

  @override
  String get robotEasyHint => 'فقط برای سرگرمی';

  @override
  String get robotNormalHint => 'یه رقیب منصف';

  @override
  String get robotHardHint => 'حقه‌هات رو یاد می‌گیره';

  @override
  String get myTrophies => 'جایزه‌های من';

  @override
  String get switchLanguage => 'English';

  @override
  String get switchLanguageTooltip => 'تغییر زبان';

  @override
  String get soundOn => 'صدا روشن';

  @override
  String get soundOff => 'صدا خاموش';

  @override
  String get back => 'برگشت';

  @override
  String get pause => 'توقف';

  @override
  String get resume => 'ادامه بازی';

  @override
  String get restart => 'از اول';

  @override
  String get home => 'خانه';

  @override
  String get you => 'تو';

  @override
  String get rock => 'سنگ';

  @override
  String get paper => 'کاغذ';

  @override
  String get scissors => 'قیچی';

  @override
  String get pickPrompt => 'دستت رو انتخاب کن!';

  @override
  String get youWin => 'بردی!';

  @override
  String robotWins(String robot) {
    return '$robot برد!';
  }

  @override
  String get draw => 'مساوی!';

  @override
  String get tapToContinue => 'برای ادامه بزن';

  @override
  String streak(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString تا پشت سر هم!';
  }

  @override
  String scoreSemantics(int wins, String robot, int losses) {
    final intl.NumberFormat winsNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String winsString = winsNumberFormat.format(wins);
    final intl.NumberFormat lossesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String lossesString = lossesNumberFormat.format(losses);

    return 'تو $winsString، $robot $lossesString';
  }

  @override
  String handSemantics(String player, String move) {
    return '$player: $move';
  }

  @override
  String get hiddenHand => 'مخفی';

  @override
  String get matchWinTitle => 'تو قهرمانی!';

  @override
  String get matchWinSubtitle => 'عالی بازی کردی!';

  @override
  String matchLoseTitle(String robot) {
    return 'این دفعه $robot برد';
  }

  @override
  String get matchLoseSubtitle => 'دوباره امتحان کن، تو می‌تونی!';

  @override
  String get playAgain => 'دوباره';

  @override
  String get niceRun => 'آفرین!';

  @override
  String get winRate => 'درصد برد';

  @override
  String roundsSummary(int won, int played) {
    final intl.NumberFormat wonNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String wonString = wonNumberFormat.format(won);
    final intl.NumberFormat playedNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String playedString = playedNumberFormat.format(played);

    return '$wonString از $playedString دست';
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

    return '$wonString برد، $drawnString مساوی، $lostString باخت';
  }

  @override
  String get matches => 'مسابقه‌ها';

  @override
  String get rounds => 'دست‌ها';

  @override
  String get bestStreak => 'بهترین رکورد';

  @override
  String get noStatsYet => 'بازی کن تا جایزه ببری!';

  @override
  String get tryAgain => 'دوباره امتحان کن';

  @override
  String get loading => 'در حال بارگذاری';
}
