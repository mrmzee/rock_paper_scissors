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
  String get chooseRobot => 'حریفت رو انتخاب کن';

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
  String get themeSystem => 'تم: مثل دستگاه';

  @override
  String get themeLight => 'تم: روشن';

  @override
  String get themeDark => 'تم: تیره';

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
  String get currentStreak => 'برد پشت سر هم';

  @override
  String get favoriteMove => 'دست محبوب';

  @override
  String timesPlayed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString بار';
  }

  @override
  String get vsRobots => 'در برابر هر ربات';

  @override
  String get notPlayedYet => 'هنوز بازی نکردی';

  @override
  String get resetStats => 'پاک کردن آمار';

  @override
  String get resetStatsTitle => 'همهٔ آمار پاک بشه؟';

  @override
  String get resetStatsBody =>
      'جایزه‌ها و رکوردهات پاک می‌شن و دیگه برنمی‌گردن.';

  @override
  String get cancel => 'نه';

  @override
  String get reset => 'پاک کن';

  @override
  String get noStatsYet => 'بازی کن تا جایزه ببری!';

  @override
  String get tryAgain => 'دوباره امتحان کن';

  @override
  String get badges => 'نشان‌ها';

  @override
  String badgesProgress(int unlocked, int total) {
    final intl.NumberFormat unlockedNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String unlockedString = unlockedNumberFormat.format(unlocked);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '$unlockedString از $totalString';
  }

  @override
  String get newBadge => 'نشان جدید!';

  @override
  String get badgeLocked => 'قفل';

  @override
  String get badgeFirstWin => 'اولین برد';

  @override
  String get badgeFirstWinHint => 'یه مسابقه ببر';

  @override
  String get badgeStreak3 => 'سه‌تایی';

  @override
  String get badgeStreak3Hint => '۳ دست پشت سر هم ببر';

  @override
  String get badgeStreak5 => 'توقف‌ناپذیر';

  @override
  String get badgeStreak5Hint => '۵ دست پشت سر هم ببر';

  @override
  String get badgePerfect => 'بی‌نقص';

  @override
  String get badgePerfectHint => '۳ ستاره بگیر بدون حتی یه باخت';

  @override
  String get badgeBeatGrumpy => 'اخمو رو بردی';

  @override
  String badgeBeatGrumpyHint(String robot) {
    return 'یه مسابقه از $robot ببر';
  }

  @override
  String get badgeAllMoves => 'استاد سه دست';

  @override
  String get badgeAllMovesHint => 'توی یه مسابقه با سنگ، کاغذ و قیچی ببر';

  @override
  String get badgeMatches10 => 'پایه‌ی ثابت';

  @override
  String get badgeMatches10Hint => '۱۰ مسابقه بازی کن';

  @override
  String get badgeMatches50 => 'کهنه‌کار';

  @override
  String get badgeMatches50Hint => '۵۰ مسابقه بازی کن';

  @override
  String get howToPlay => 'راهنمای بازی';

  @override
  String get onboardingSkip => 'رد شو';

  @override
  String get onboardingNext => 'بعدی';

  @override
  String get onboardingDone => 'بزن بریم!';

  @override
  String get onboardingMovesTitle => 'دستت رو انتخاب کن';

  @override
  String get onboardingMovesBody =>
      'سنگ قیچی رو می‌بره، قیچی کاغذ رو، کاغذ هم سنگ رو.';

  @override
  String get onboardingRobotsTitle => 'یه ربات انتخاب کن';

  @override
  String onboardingRobotsBody(String easy, String hard) {
    return '$easy برای سرگرمی بازی می‌کنه. $hard حقه‌هات رو یاد می‌گیره!';
  }

  @override
  String get onboardingTrophiesTitle => 'ستاره و جایزه ببر';

  @override
  String get onboardingTrophiesBody =>
      'هر کی زودتر ۳ ستاره بگیره برنده‌ست. هر بازی به جایزه‌هات اضافه می‌شه.';

  @override
  String onboardingPage(int current, int total) {
    final intl.NumberFormat currentNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String currentString = currentNumberFormat.format(current);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'صفحهٔ $currentString از $totalString';
  }

  @override
  String get loading => 'در حال بارگذاری';

  @override
  String get opponentFriend => 'یه دوست';

  @override
  String get opponentFriendHint => 'دو نفره با یه گوشی';

  @override
  String get player1 => 'بازیکن ۱';

  @override
  String get player2 => 'بازیکن ۲';

  @override
  String playerTurn(String player) {
    return '$player، انتخاب کن!';
  }

  @override
  String handoffTitle(String player) {
    return 'گوشی رو بده به $player';
  }

  @override
  String get handoffHint => 'یواشکی نگاه نکنی!';

  @override
  String get handoffReady => 'آماده‌ام';

  @override
  String playerWinsMatch(String player) {
    return '$player قهرمان شد!';
  }

  @override
  String get friendMatchSubtitle => 'چه بازی‌ای بود!';

  @override
  String versusScoreSemantics(
      String player, int wins, String opponent, int losses) {
    final intl.NumberFormat winsNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String winsString = winsNumberFormat.format(wins);
    final intl.NumberFormat lossesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String lossesString = lossesNumberFormat.format(losses);

    return '$player $winsString، $opponent $lossesString';
  }
}
