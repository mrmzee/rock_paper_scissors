import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rock_paper_scissors/core/audio/sound_service.dart';
import 'package:rock_paper_scissors/core/l10n/l10n.dart';
import 'package:rock_paper_scissors/core/settings/app_settings.dart';
import 'package:rock_paper_scissors/core/settings/settings_cubit.dart';
import 'package:rock_paper_scissors/core/theme/app_motion.dart';
import 'package:rock_paper_scissors/core/theme/app_spacing.dart';
import 'package:rock_paper_scissors/core/widgets/app_background.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match_mode.dart';
import 'package:rock_paper_scissors/features/game/presentation/views/game_page.dart';
import 'package:rock_paper_scissors/features/home/presentation/widgets/home_hero.dart';
import 'package:rock_paper_scissors/features/home/presentation/widgets/home_top_bar.dart';
import 'package:rock_paper_scissors/features/home/presentation/widgets/mode_card.dart';
import 'package:rock_paper_scissors/features/home/presentation/widgets/play_button.dart';
import 'package:rock_paper_scissors/features/home/presentation/widgets/robot_card.dart';
import 'package:rock_paper_scissors/features/home/presentation/widgets/section_title.dart';
import 'package:rock_paper_scissors/features/onboarding/presentation/views/onboarding_page.dart';
import 'package:rock_paper_scissors/features/stats/presentation/views/stats_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _openGame(BuildContext context, AppSettings settings) {
    context.playSfx(Sfx.tap);
    Navigator.of(context).push(
      _fadeRoute(
        context,
        GamePage(mode: settings.mode, difficulty: settings.difficulty),
      ),
    );
  }

  void _openStats(BuildContext context) {
    context.playSfx(Sfx.tap);
    Navigator.of(context).push(_fadeRoute(context, const StatsPage()));
  }

  void _openHelp(BuildContext context) {
    context.playSfx(Sfx.tap);
    Navigator.of(context).push(OnboardingPage.route());
  }

  Route<void> _fadeRoute(BuildContext context, Widget page) {
    if (AppMotion.reduced(context)) {
      return MaterialPageRoute<void>(builder: (_) => page);
    }

    return PageRouteBuilder<void>(
      transitionDuration: AppMotion.page,
      reverseTransitionDuration: AppMotion.page,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: AppMotion.pageEnter,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.035),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<SettingsCubit>();

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: BlocBuilder<SettingsCubit, AppSettings>(
            builder: (context, settings) {
              final topBar = HomeTopBar(
                soundOn: settings.soundOn,
                onLanguage: () => cubit.toggleLanguage(
                  Localizations.localeOf(context),
                ),
                onSound: cubit.toggleSound,
                themeMode: settings.themeMode,
                onTheme: cubit.cycleThemeMode,
                onHelp: () => _openHelp(context),
                onStats: () => _openStats(context),
              );
              final hero = FittedBox(
                fit: BoxFit.scaleDown,
                child: HomeHero(difficulty: settings.difficulty),
              );
              final choices = Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SectionTitle(
                    icon: Icons.sports_esports_rounded,
                    text: l10n.gameType,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final mode in MatchMode.values) ...[
                          if (mode != MatchMode.values.first)
                            const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: ModeCard(
                              mode: mode,
                              selected: settings.mode == mode,
                              onPressed: () {
                                context.playSfx(Sfx.tap);
                                cubit.selectMode(mode);
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SectionTitle(
                    icon: Icons.smart_toy_rounded,
                    text: l10n.chooseRobot,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final difficulty in Difficulty.values) ...[
                          if (difficulty != Difficulty.values.first)
                            const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: RobotCard(
                              difficulty: difficulty,
                              selected: settings.difficulty == difficulty,
                              onPressed: () {
                                context.playSfx(Sfx.tap);
                                cubit.selectDifficulty(difficulty);
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  PlayButton(
                    onPressed: () => _openGame(context, settings),
                  ),
                ],
              );

              return LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth > constraints.maxHeight &&
                      constraints.maxWidth >= 600;

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.sm,
                      AppSpacing.lg,
                      AppSpacing.md,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: wide ? 960 : 520),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            topBar,
                            const SizedBox(height: AppSpacing.sm),
                            Expanded(
                              child: wide
                                  ? Row(
                                      children: [
                                        Expanded(child: hero),
                                        const SizedBox(width: AppSpacing.lg),
                                        Expanded(
                                          child: _ScaleToFit(child: choices),
                                        ),
                                      ],
                                    )
                                  : LayoutBuilder(
                                      builder: (context, box) => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(child: hero),
                                          const SizedBox(
                                            height: AppSpacing.sm,
                                          ),
                                          ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxHeight: box.maxHeight * 0.74,
                                            ),
                                            child: _ScaleToFit(child: choices),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Keeps [child] at the full available width and scales it down uniformly
/// when it is taller than the space, so the home screen never scrolls.
class _ScaleToFit extends StatelessWidget {
  const _ScaleToFit({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Center(
        heightFactor: 1,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(width: constraints.maxWidth, child: child),
        ),
      ),
    );
  }
}
