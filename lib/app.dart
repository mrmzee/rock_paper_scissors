import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rock_paper_scissors/core/audio/sound_service.dart';
import 'package:rock_paper_scissors/core/settings/app_settings.dart';
import 'package:rock_paper_scissors/core/settings/settings_cubit.dart';
import 'package:rock_paper_scissors/core/settings/settings_repository.dart';
import 'package:rock_paper_scissors/core/theme/app_motion.dart';
import 'package:rock_paper_scissors/core/theme/app_theme.dart';
import 'package:rock_paper_scissors/features/achievements/data/repositories/in_memory_achievements_repository.dart';
import 'package:rock_paper_scissors/features/achievements/domain/repositories/achievements_repository.dart';
import 'package:rock_paper_scissors/features/achievements/domain/usecases/unlock_achievements.dart';
import 'package:rock_paper_scissors/features/game/data/repositories/adaptive_opponent_strategy.dart';
import 'package:rock_paper_scissors/features/game/data/repositories/in_memory_stats_repository.dart';
import 'package:rock_paper_scissors/features/game/domain/repositories/opponent_strategy.dart';
import 'package:rock_paper_scissors/features/game/domain/repositories/stats_repository.dart';
import 'package:rock_paper_scissors/features/game/domain/usecases/play_round.dart';
import 'package:rock_paper_scissors/features/game/domain/usecases/record_match_stats.dart';
import 'package:rock_paper_scissors/features/home/presentation/views/home_page.dart';
import 'package:rock_paper_scissors/features/onboarding/presentation/views/onboarding_page.dart';
import 'package:rock_paper_scissors/l10n/app_localizations.dart';

/// Root widget and composition root: every dependency is provided here so
/// pages read them from context instead of passing them down by hand.
class RockPaperScissorsApp extends StatelessWidget {
  const RockPaperScissorsApp({
    super.key,
    this.home = const HomePage(),
    this.settingsRepository,
    this.statsRepository,
    this.achievementsRepository,
    this.opponentStrategy,
    this.soundService = const SilentSoundService(),
  });

  final Widget home;
  final SettingsRepository? settingsRepository;
  final StatsRepository? statsRepository;
  final AchievementsRepository? achievementsRepository;
  final OpponentStrategy? opponentStrategy;
  final SoundService soundService;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SoundService>.value(value: soundService),
        RepositoryProvider<StatsRepository>(
          create: (_) => statsRepository ?? InMemoryStatsRepository(),
        ),
        RepositoryProvider<AchievementsRepository>(
          create: (_) =>
              achievementsRepository ?? InMemoryAchievementsRepository(),
        ),
        RepositoryProvider<PlayRound>(
          create: (_) => PlayRound(
            opponentStrategy ?? AdaptiveOpponentStrategy(),
          ),
        ),
        RepositoryProvider<RecordMatchStats>(
          create: (context) =>
              RecordMatchStats(context.read<StatsRepository>()),
        ),
        RepositoryProvider<UnlockAchievements>(
          create: (context) =>
              UnlockAchievements(context.read<AchievementsRepository>()),
        ),
      ],
      child: BlocProvider(
        create: (_) => SettingsCubit(
          settingsRepository ?? InMemorySettingsRepository(),
        ),
        child: BlocBuilder<SettingsCubit, AppSettings>(
          buildWhen: (previous, current) =>
              previous.locale != current.locale ||
              previous.themeMode != current.themeMode,
          builder: (context, settings) {
            return MaterialApp(
              onGenerateTitle: (context) =>
                  AppLocalizations.of(context).appTitle,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: settings.themeMode,
              debugShowCheckedModeBanner: false,
              locale: settings.locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              home: _FirstRunGate(child: home),
            );
          },
        ),
      ),
    );
  }
}

/// Shows the onboarding slides until they are finished once.
class _FirstRunGate extends StatelessWidget {
  const _FirstRunGate({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, AppSettings>(
      buildWhen: (previous, current) =>
          previous.onboardingSeen != current.onboardingSeen,
      builder: (context, settings) {
        return AnimatedSwitcher(
          duration: AppMotion.of(context, AppMotion.page),
          child: settings.onboardingSeen
              ? child
              : OnboardingPage(
                  onDone: context.read<SettingsCubit>().completeOnboarding,
                ),
        );
      },
    );
  }
}
