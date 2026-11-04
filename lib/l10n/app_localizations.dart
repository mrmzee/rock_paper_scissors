import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fa')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Rock Paper Scissors'**
  String get appTitle;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Ready to play?'**
  String get homeGreeting;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play!'**
  String get play;

  /// No description provided for @gameType.
  ///
  /// In en, this message translates to:
  /// **'Game type'**
  String get gameType;

  /// No description provided for @modeBestOf5.
  ///
  /// In en, this message translates to:
  /// **'3 stars'**
  String get modeBestOf5;

  /// No description provided for @modeBestOf5Hint.
  ///
  /// In en, this message translates to:
  /// **'First to 3 wins'**
  String get modeBestOf5Hint;

  /// No description provided for @modeEndless.
  ///
  /// In en, this message translates to:
  /// **'Endless'**
  String get modeEndless;

  /// No description provided for @modeEndlessHint.
  ///
  /// In en, this message translates to:
  /// **'Play as long as you like'**
  String get modeEndlessHint;

  /// No description provided for @chooseRobot.
  ///
  /// In en, this message translates to:
  /// **'Pick your robot'**
  String get chooseRobot;

  /// No description provided for @robotEasy.
  ///
  /// In en, this message translates to:
  /// **'Robo Jr.'**
  String get robotEasy;

  /// No description provided for @robotNormal.
  ///
  /// In en, this message translates to:
  /// **'Robo'**
  String get robotNormal;

  /// No description provided for @robotHard.
  ///
  /// In en, this message translates to:
  /// **'Grumpy Robo'**
  String get robotHard;

  /// No description provided for @robotEasyHint.
  ///
  /// In en, this message translates to:
  /// **'Plays for fun'**
  String get robotEasyHint;

  /// No description provided for @robotNormalHint.
  ///
  /// In en, this message translates to:
  /// **'A fair fight'**
  String get robotNormalHint;

  /// No description provided for @robotHardHint.
  ///
  /// In en, this message translates to:
  /// **'Learns your tricks'**
  String get robotHardHint;

  /// No description provided for @myTrophies.
  ///
  /// In en, this message translates to:
  /// **'My trophies'**
  String get myTrophies;

  /// No description provided for @switchLanguage.
  ///
  /// In en, this message translates to:
  /// **'فارسی'**
  String get switchLanguage;

  /// No description provided for @switchLanguageTooltip.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get switchLanguageTooltip;

  /// No description provided for @soundOn.
  ///
  /// In en, this message translates to:
  /// **'Sound on'**
  String get soundOn;

  /// No description provided for @soundOff.
  ///
  /// In en, this message translates to:
  /// **'Sound off'**
  String get soundOff;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'Theme: follow device'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Theme: light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Theme: dark'**
  String get themeDark;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Keep playing'**
  String get resume;

  /// No description provided for @restart.
  ///
  /// In en, this message translates to:
  /// **'Start over'**
  String get restart;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @rock.
  ///
  /// In en, this message translates to:
  /// **'Rock'**
  String get rock;

  /// No description provided for @paper.
  ///
  /// In en, this message translates to:
  /// **'Paper'**
  String get paper;

  /// No description provided for @scissors.
  ///
  /// In en, this message translates to:
  /// **'Scissors'**
  String get scissors;

  /// No description provided for @pickPrompt.
  ///
  /// In en, this message translates to:
  /// **'Pick your hand!'**
  String get pickPrompt;

  /// No description provided for @youWin.
  ///
  /// In en, this message translates to:
  /// **'You win!'**
  String get youWin;

  /// No description provided for @robotWins.
  ///
  /// In en, this message translates to:
  /// **'{robot} wins!'**
  String robotWins(String robot);

  /// No description provided for @draw.
  ///
  /// In en, this message translates to:
  /// **'Draw!'**
  String get draw;

  /// No description provided for @tapToContinue.
  ///
  /// In en, this message translates to:
  /// **'Tap to continue'**
  String get tapToContinue;

  /// No description provided for @streak.
  ///
  /// In en, this message translates to:
  /// **'{count} in a row!'**
  String streak(int count);

  /// No description provided for @scoreSemantics.
  ///
  /// In en, this message translates to:
  /// **'You {wins}, {robot} {losses}'**
  String scoreSemantics(int wins, String robot, int losses);

  /// No description provided for @handSemantics.
  ///
  /// In en, this message translates to:
  /// **'{player}: {move}'**
  String handSemantics(String player, String move);

  /// No description provided for @hiddenHand.
  ///
  /// In en, this message translates to:
  /// **'hidden'**
  String get hiddenHand;

  /// No description provided for @matchWinTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re the champion!'**
  String get matchWinTitle;

  /// No description provided for @matchWinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Amazing playing!'**
  String get matchWinSubtitle;

  /// No description provided for @matchLoseTitle.
  ///
  /// In en, this message translates to:
  /// **'{robot} won this time'**
  String matchLoseTitle(String robot);

  /// No description provided for @matchLoseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try again, you can do it!'**
  String get matchLoseSubtitle;

  /// No description provided for @playAgain.
  ///
  /// In en, this message translates to:
  /// **'Play again'**
  String get playAgain;

  /// No description provided for @niceRun.
  ///
  /// In en, this message translates to:
  /// **'Nice playing!'**
  String get niceRun;

  /// No description provided for @winRate.
  ///
  /// In en, this message translates to:
  /// **'Win rate'**
  String get winRate;

  /// No description provided for @roundsSummary.
  ///
  /// In en, this message translates to:
  /// **'{won} of {played} rounds'**
  String roundsSummary(int won, int played);

  /// No description provided for @roundsBreakdown.
  ///
  /// In en, this message translates to:
  /// **'{won} wins, {drawn} draws, {lost} losses'**
  String roundsBreakdown(int won, int drawn, int lost);

  /// No description provided for @matches.
  ///
  /// In en, this message translates to:
  /// **'Matches'**
  String get matches;

  /// No description provided for @rounds.
  ///
  /// In en, this message translates to:
  /// **'Rounds'**
  String get rounds;

  /// No description provided for @bestStreak.
  ///
  /// In en, this message translates to:
  /// **'Best streak'**
  String get bestStreak;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'In a row now'**
  String get currentStreak;

  /// No description provided for @favoriteMove.
  ///
  /// In en, this message translates to:
  /// **'Favorite hand'**
  String get favoriteMove;

  /// No description provided for @timesPlayed.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 time} other{{count} times}}'**
  String timesPlayed(int count);

  /// No description provided for @vsRobots.
  ///
  /// In en, this message translates to:
  /// **'Against each robot'**
  String get vsRobots;

  /// No description provided for @notPlayedYet.
  ///
  /// In en, this message translates to:
  /// **'Not played yet'**
  String get notPlayedYet;

  /// No description provided for @resetStats.
  ///
  /// In en, this message translates to:
  /// **'Reset stats'**
  String get resetStats;

  /// No description provided for @resetStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset all stats?'**
  String get resetStatsTitle;

  /// No description provided for @resetStatsBody.
  ///
  /// In en, this message translates to:
  /// **'Your trophies and records will be erased. This can\'t be undone.'**
  String get resetStatsBody;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @noStatsYet.
  ///
  /// In en, this message translates to:
  /// **'Play a game to win trophies!'**
  String get noStatsYet;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @badges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get badges;

  /// No description provided for @badgesProgress.
  ///
  /// In en, this message translates to:
  /// **'{unlocked} of {total}'**
  String badgesProgress(int unlocked, int total);

  /// No description provided for @newBadge.
  ///
  /// In en, this message translates to:
  /// **'New badge!'**
  String get newBadge;

  /// No description provided for @badgeLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get badgeLocked;

  /// No description provided for @badgeFirstWin.
  ///
  /// In en, this message translates to:
  /// **'First win'**
  String get badgeFirstWin;

  /// No description provided for @badgeFirstWinHint.
  ///
  /// In en, this message translates to:
  /// **'Win a match'**
  String get badgeFirstWinHint;

  /// No description provided for @badgeStreak3.
  ///
  /// In en, this message translates to:
  /// **'Hat trick'**
  String get badgeStreak3;

  /// No description provided for @badgeStreak3Hint.
  ///
  /// In en, this message translates to:
  /// **'Win 3 rounds in a row'**
  String get badgeStreak3Hint;

  /// No description provided for @badgeStreak5.
  ///
  /// In en, this message translates to:
  /// **'Unstoppable'**
  String get badgeStreak5;

  /// No description provided for @badgeStreak5Hint.
  ///
  /// In en, this message translates to:
  /// **'Win 5 rounds in a row'**
  String get badgeStreak5Hint;

  /// No description provided for @badgePerfect.
  ///
  /// In en, this message translates to:
  /// **'Perfect match'**
  String get badgePerfect;

  /// No description provided for @badgePerfectHint.
  ///
  /// In en, this message translates to:
  /// **'Get 3 stars without losing a round'**
  String get badgePerfectHint;

  /// No description provided for @badgeBeatGrumpy.
  ///
  /// In en, this message translates to:
  /// **'Grumpy no more'**
  String get badgeBeatGrumpy;

  /// No description provided for @badgeBeatGrumpyHint.
  ///
  /// In en, this message translates to:
  /// **'Win a match against {robot}'**
  String badgeBeatGrumpyHint(String robot);

  /// No description provided for @badgeAllMoves.
  ///
  /// In en, this message translates to:
  /// **'Triple threat'**
  String get badgeAllMoves;

  /// No description provided for @badgeAllMovesHint.
  ///
  /// In en, this message translates to:
  /// **'Win with rock, paper and scissors in one match'**
  String get badgeAllMovesHint;

  /// No description provided for @badgeMatches10.
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get badgeMatches10;

  /// No description provided for @badgeMatches10Hint.
  ///
  /// In en, this message translates to:
  /// **'Play 10 matches'**
  String get badgeMatches10Hint;

  /// No description provided for @badgeMatches50.
  ///
  /// In en, this message translates to:
  /// **'Veteran'**
  String get badgeMatches50;

  /// No description provided for @badgeMatches50Hint.
  ///
  /// In en, this message translates to:
  /// **'Play 50 matches'**
  String get badgeMatches50Hint;

  /// No description provided for @howToPlay.
  ///
  /// In en, this message translates to:
  /// **'How to play'**
  String get howToPlay;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingDone.
  ///
  /// In en, this message translates to:
  /// **'Let\'s play!'**
  String get onboardingDone;

  /// No description provided for @onboardingMovesTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick your hand'**
  String get onboardingMovesTitle;

  /// No description provided for @onboardingMovesBody.
  ///
  /// In en, this message translates to:
  /// **'Rock beats scissors, scissors beat paper, and paper beats rock.'**
  String get onboardingMovesBody;

  /// No description provided for @onboardingRobotsTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a robot'**
  String get onboardingRobotsTitle;

  /// No description provided for @onboardingRobotsBody.
  ///
  /// In en, this message translates to:
  /// **'{easy} plays for fun. {hard} learns your tricks!'**
  String onboardingRobotsBody(String easy, String hard);

  /// No description provided for @onboardingTrophiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Win stars and trophies'**
  String get onboardingTrophiesTitle;

  /// No description provided for @onboardingTrophiesBody.
  ///
  /// In en, this message translates to:
  /// **'First to 3 stars wins the match. Every game adds to your trophies.'**
  String get onboardingTrophiesBody;

  /// No description provided for @onboardingPage.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String onboardingPage(int current, int total);

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fa'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
